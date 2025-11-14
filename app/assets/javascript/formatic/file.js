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
        this.url = this.input.dataset.directUploadUrl;
        this.setupBindings();
    }
    setupBindings() {
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
            onupdatefiles: () => this.updateSubmit(),
            onactivatefile: () => this.updateSubmit(),
            onreorderfiles: () => this.updateSubmit(),
            server: {
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
        });
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
    get form() {
        return this.el.closest('form');
    }
    get submitButtons() {
        return this.form.querySelectorAll('[type="submit"]');
    }
}
//# sourceMappingURL=file.js.map