export declare class String {
    private el;
    private timeoutId;
    constructor(el: HTMLElement);
    private setupBindings;
    private actionSave;
    private actionSaveNow;
    private guiWaitingForSave;
    private guiSaved;
    private guiFailed;
    private get autoSubmit();
    private save;
    private debounce;
}
