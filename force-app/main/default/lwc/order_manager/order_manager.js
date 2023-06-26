import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import getFilteredProducts from '@salesforce/apex/OrderManagerController.getFilteredProducts';
import createOrder from '@salesforce/apex/OrderService.createOrder';

import Id from '@salesforce/user/Id';

import Product__c from '@salesforce/schema/Product__c';
import Product__c_Type__c from '@salesforce/schema/Product__c.Type__c';
import Product__c_Family__c from '@salesforce/schema/Product__c.Family__c';

    const FIELDS = [
    'Account.Name',
    'Account.AccountNumber'
    ];

export default class Order_manager extends NavigationMixin(LightningElement) {

    userId = Id;

    @track
    typeFilter = '';

    @track
    familyFilter = '';

    @track
    searchQuery = '';

    @track
    forceRerender = 0;

    @track
    cart = [];

    @track
    isDetailsModalShown = false;

    @track
    productIdForDetailsModal;

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
    }

    @wire(getRecord, { recordId: "$accountId", fields: FIELDS })
    account;

    @wire(getRecord, { recordId: "$userId", fields: ['User.IsManager__c'] })
    user;

    @wire(getFilteredProducts, { filterType: "$typeFilter", filterFamily: "$familyFilter" })
    products;

    @wire(getObjectInfo, { objectApiName: Product__c })
    productObjectInfo;

    @wire(getPicklistValues, { recordTypeId: '$productObjectInfo.data.defaultRecordTypeId', fieldApiName: Product__c_Type__c })
    typePicklistValues;
    @wire(getPicklistValues, { recordTypeId: '$productObjectInfo.data.defaultRecordTypeId', fieldApiName: Product__c_Family__c })
    familyPicklistValues;
    get accountId() {
        return this.currentPageReference?.state?.c__accountId;
    }

    get accountName(){
        return this.account.data?.fields.Name.value;
    }

    get accountNumber(){
        return this.account.data?.fields.AccountNumber.value;
    }

    get isManager(){
        console.log("user " + this.userId );
        console.log("lol " + this.user.data?.fields.IsManager__c.value);
        return this.user.data?.fields.IsManager__c.value;
    }

    get products2() {
        if (this.products.data) {
            return JSON.parse(JSON.stringify(
                  this.products.data.filter(
                      product => product.Description__c.toUpperCase().includes(this.searchQuery.toUpperCase())
                      || product.Name.toUpperCase().includes(this.searchQuery.toUpperCase())
                  )
                  )
                  );
        }
    }

    get isCartEmpty(){
        return this.cart.length == 0;
    }



    handleTypeFilter(event) {
        var previous = this.template.querySelector('.type-filter_selected');
        if (previous) {
            previous.classList.remove('type-filter_selected');
        }
        event.target.classList.add("type-filter_selected");
        this.typeFilter = event.target.dataset.id;
    }

    handleFamilyFilter(event){
        var previous = this.template.querySelector('.family-filter_selected');
        if(previous) {
            previous.classList.remove('family-filter_selected');
        }
        event.target.classList.add("family-filter_selected");
        this.familyFilter = event.target.dataset.id;
    }

    handleSearchInputChange(event){
        this.searchQuery = event.target.value;
    }

    handleSearch(event){
        if(event.keyCode === 13){
          this.forceRerender++;
        }
    }

    openDetailsModal(event){
    this.productIdForDetailsModal  = event.target.dataset.id;
    var modal = this.template.querySelector(".product-details-modal");
    var modalBackdrop = this.template.querySelector(".product-details-modal-backdrop");

    if(modal){
        modal.classList.add("slds-fade-in-open");
    }
    if(modalBackdrop){
        modalBackdrop.classList.add("slds-fade-in-open");
    }
    }

    closeDetailsModal(){
        var modal = this.template.querySelector(".product-details-modal");
        var modalBackdrop = this.template.querySelector(".product-details-modal-backdrop");

        modal.classList.remove("slds-fade-in-open");
        modalBackdrop.classList.remove("slds-fade-in-open");

    }
    openCartModal(event){
    let modal = this.template.querySelector(".cart-modal");
    let modalBackdrop = this.template.querySelector(".cart-modal-backdrop");

    if(modal){
        modal.classList.add("slds-fade-in-open");
    }
    if(modalBackdrop){
        modalBackdrop.classList.add("slds-fade-in-open");
    }
    }

    closeCartModal(){
        var modal = this.template.querySelector(".cart-modal");
        var modalBackdrop = this.template.querySelector(".cart-modal-backdrop");

        modal.classList.remove("slds-fade-in-open");
        modalBackdrop.classList.remove("slds-fade-in-open");
    }

    addProductToCart(event){
        let productId = event.target.dataset.id;
        let product = this.products.data.filter(product => product.Id == productId)[0];

        let existingCartItem = this.cart.filter(cartItem => cartItem.product.Id == productId);
        if (existingCartItem.length > 0){
            existingCartItem = existingCartItem[0];
            existingCartItem.quantity++;
            existingCartItem.total += product.Price__c;
        } else {
            let newCartItem = {};

            newCartItem.quantity = 1;
            newCartItem.product = product;
            newCartItem.total = product.Price__c;
            this.cart.push(newCartItem);
            existingCartItem = newCartItem;
        }

        console.log(JSON.parse(JSON.stringify(this.cart)));

        this.showSuccessMessage(`Successfully added ${existingCartItem.product.Name} to Cart`, `Quantity of ${existingCartItem.product.Name} in Cart: ` + existingCartItem.quantity)
            }

    showSuccessMessage(title, message){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }

    makeOrder(){
        let cartItemsIdAndQuantityList = this.cart.map(cartItem => {
            let entry ={};
            entry.id = cartItem.product.Id;
            entry.quantity = cartItem.quantity;
            return entry;
        });

        cartItemsIdAndQuantityList = JSON.parse(JSON.stringify(cartItemsIdAndQuantityList));
        console.log(cartItemsIdAndQuantityList);
        createOrder({accountIdString: this.accountId, cart: cartItemsIdAndQuantityList}).then(resultId => {
                                   this.showSuccessMessage("Order was successfully created", "You will be redirected to order page");
                                   this.navigateToOrderPage(resultId);
                               })
                               .catch(error => {
                                   console.log(error);
                               });
        this.closeCartModal();

    }

    navigateToOrderPage(orderId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: orderId,
                    objectApiName: 'Order__c',
                    actionName: 'view'
                }
            });
    }

}