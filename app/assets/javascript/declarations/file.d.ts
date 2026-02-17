export declare class FormaticFile {
    private el;
    private url;
    private pond;
    private busyStatuses;
    private inputID;
    private inputName;
    constructor(el: HTMLElement);
    private setupSync;
    private setupAsync;
    private updateLabelId;
    private updatedFiles;
    private updateSubmit;
    private enableSubmit;
    private disableSubmit;
    private get input();
    private get hiddenFieldsContainer();
    private get form();
    private get submitButtons();
}
