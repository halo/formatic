import * as autosize from 'autosize';
export class Textarea {
    constructor(el) {
        this.el = el;
        this.setupBindings();
    }
    setupBindings() {
        this.autosize();
        this.el.addEventListener('input', (event) => {
            event.preventDefault();
            if (this.autoSubmit)
                this.actionSave();
        });
    }
    actionSave() {
        this.guiWaitingForSave();
        this.debounce(this.actionSaveNow.bind(this))();
    }
    actionSaveNow() {
        console.debug("Saving textarea...");
        this.el.classList.remove('is-loading');
        this.el.classList.add('is-saved');
        this.save();
    }
    guiWaitingForSave() {
        this.el.classList.add('is-loading');
        this.el.classList.remove('is-saved');
        this.el.classList.remove('is-failed');
    }
    guiSaved() {
        this.el.classList.remove('is-loading');
        this.el.classList.add('is-saved');
        this.el.classList.remove('is-failed');
    }
    guiFailed() {
        this.el.classList.remove('is-loading');
        this.el.classList.remove('is-saved');
        this.el.classList.add('is-failed');
    }
    get autoSubmit() {
        return this.el.classList.contains('is-autosubmit');
    }
    save() {
        const form = this.el.closest('form');
        const data = new FormData(form);
        data.set('_method', 'patch');
        fetch(form.action, {
            method: 'POST',
            headers: { 'Accept': 'text/javascript' },
            body: data
        })
            .then(response => {
            if (response.status == 201) {
                console.debug('Textarea content saved');
                this.guiSaved();
            }
            else {
                console.debug('Textarea content not saved');
                this.guiFailed();
            }
        }).catch(err => {
            console.warn(err);
            console.debug('Failed badly to save');
        });
    }
    debounce(fn) {
        return () => {
            clearTimeout(this.timeoutId);
            this.timeoutId = setTimeout(() => fn(), 1000);
        };
    }
    autosize() {
        try {
            autosize(this.el);
        }
        catch (error) {
            console.warn(`Formatic is missing the autosize library`);
        }
    }
}
//# sourceMappingURL=textarea.js.map