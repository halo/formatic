import * as FilePond from "filepond";
import { DirectUpload } from "@rails/activestorage";
export class FormaticFile {
    constructor(el) {
        this.busyStatuses = new Set([
            FilePond.FileStatus.LOADING,
            FilePond.FileStatus.PROCESSING_QUEUED,
            FilePond.FileStatus.PROCESSING,
        ]);
        this.el = el;
        this.url = (this.input.dataset.directUploadUrl || '');
        this.inputID = this.input.id;
        this.inputName = this.input.name;
        this.setupBindings();
    }
    setupBindings() {
        console.log(this.input.dataset.entries);
        this.pond = FilePond.create(this.input, {
            credits: false,
            onwarning: () => this.updateSubmit(),
            onerror: () => this.updateSubmit(),
            onaddfilestart: () => this.updateSubmit(),
            onaddfileprogress: () => this.updateSubmit(),
            onaddfile: () => this.updateSubmit(),
            onprocessfilestart: () => this.updateSubmit(),
            onprocessfileprogress: () => this.updateSubmit(),
            onprocessfileabort: () => this.updateSubmit(),
            onprocessfilerevert: () => this.updateSubmit(),
            onprocessfile: () => this.updateSubmit(),
            onprocessfiles: () => this.updateSubmit(),
            onremovefile: () => this.updateSubmit(),
            onpreparefile: () => this.updateSubmit(),
            onactivatefile: () => this.updateSubmit(),
            onreorderfiles: () => this.updateSubmit(),
            onupdatefiles: () => this.updatedFiles(),
            files: JSON.parse(this.input.dataset.entries || '[]'),
            server: {
                revert: null,
                process: (fieldName, file, _metadata, load, error, progress, abort, transfer, options) => {
                    const uploader = new DirectUpload(file, this.url, {
                        directUploadWillStoreFileWithXHR: (request) => {
                            request.upload.addEventListener('progress', event => progress(event.lengthComputable, event.loaded, event.total));
                        }
                    });
                    uploader.create((errorResponse, blob) => {
                        if (errorResponse) {
                            error(`Something went wrong: ${errorResponse}`);
                        }
                        else {
                            load(blob.signed_id);
                        }
                    });
                    return {
                        abort: () => abort()
                    };
                },
                headers: {
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content
                }
            },
            oninit: () => this.updateLabelId(),
        });
    }
    updateLabelId() {
        if (!this.inputID)
            return;
        const labels = this.form.querySelectorAll(`label[for="${this.inputID}"]`);
        if (labels.length === 0)
            return;
        const pondInput = this.input.querySelector('input[type="file"]');
        if (!pondInput)
            return;
        const pondInputId = pondInput.id;
        if (!pondInputId)
            return;
        labels.forEach(label => label.setAttribute('for', pondInputId));
    }
    updatedFiles() {
        if (this.pond.allowMultiple)
            return;
        const files = this.pond.getFiles();
        this.hiddenFieldsContainer.innerHTML = '';
        files.forEach(file => {
            if (file.serverId) {
                const h = document.createElement('input');
                h.type = 'hidden';
                h.name = this.inputName;
                h.value = file.serverId;
                this.hiddenFieldsContainer.appendChild(h);
            }
        });
        if (files.length === 0) {
            const h = document.createElement('input');
            h.type = 'hidden';
            h.name = this.inputName;
            h.value = '';
            this.hiddenFieldsContainer.appendChild(h);
        }
        this.updateSubmit();
    }
    updateSubmit() {
        const files = this.pond.getFiles();
        const busyFiles = files.some(f => this.busyStatuses.has(f.status));
        busyFiles ? this.disableSubmit() : this.enableSubmit();
    }
    enableSubmit() {
        this.submitButtons.forEach((button) => {
            button.disabled = false;
        });
    }
    disableSubmit() {
        this.submitButtons.forEach((button) => {
            button.disabled = true;
        });
    }
    get input() {
        return this.el.querySelector('.js-formatic-file__input');
    }
    get hiddenFieldsContainer() {
        return this.el.querySelector('.js-formatic-file__hidden-fields');
    }
    get form() {
        return this.el.closest('form');
    }
    get submitButtons() {
        return this.form.querySelectorAll('[type="submit"]');
    }
}
//# sourceMappingURL=file.js.map