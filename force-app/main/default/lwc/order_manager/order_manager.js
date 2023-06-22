import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

export default class Order_manager extends LightningElement {

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
    }
    get accountId() {
        return this.currentPageReference?.state?.c__accountId;
    }

}