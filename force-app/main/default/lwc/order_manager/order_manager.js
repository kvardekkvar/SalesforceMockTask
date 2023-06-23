import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';

    const FIELDS = [
    'Account.Name',
    'Account.AccountNumber'
    ];

export default class Order_manager extends LightningElement {


    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
    }

    @wire(getRecord, { recordId: "$accountId", fields: FIELDS })
    account;


    get accountId() {
        return this.currentPageReference?.state?.c__accountId;
    }

    get accountName(){
        return this.account.data?.fields.Name.value;
    }

    get accountNumber(){
        return this.account.data?.fields.AccountNumber.value;
    }

}