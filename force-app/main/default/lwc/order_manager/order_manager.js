import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';

import getFilteredProducts from '@salesforce/apex/OrderManagerController.getFilteredProducts';
import Id from '@salesforce/user/Id';

import Product__c from '@salesforce/schema/Product__c';
import Product__c_Type__c from '@salesforce/schema/Product__c.Type__c';
import Product__c_Family__c from '@salesforce/schema/Product__c.Family__c';
import User_IsManager__c from '@salesforce/schema/User.IsManager__c';

    const FIELDS = [
    'Account.Name',
    'Account.AccountNumber'
    ];

export default class Order_manager extends LightningElement {

    userId = Id;

    @track
    typeFilter = '';

    @track
    familyFilter = '';

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
    }

    @wire(getRecord, { recordId: "$accountId", fields: FIELDS })
    account;

    @wire(getRecord, { recordId: "$userId", fields: [User_isManager__c] })
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
        return this.user.data?.fields.IsManager__c.value;
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

}