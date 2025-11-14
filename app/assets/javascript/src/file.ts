import * as FilePond from "filepond"
import { DirectUpload } from "@rails/activestorage"

export class FormaticFile {
  private el: HTMLElement
  private url: string
  private pond: FilePond.FilePond
  private busyStatuses = new Set([
    FilePond.FileStatus.LOADING,
    FilePond.FileStatus.PROCESSING_QUEUED,
    FilePond.FileStatus.PROCESSING,
  ]);

  constructor(el: HTMLElement) {
    this.el = el
    this.url = this.input.dataset.directUploadUrl
    this.setupBindings()
  }

  private setupBindings() {
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

          const uploader = new DirectUpload(file as File, this.url, {
            directUploadWillStoreFileWithXHR: (request) => {
              request.upload.addEventListener(
                'progress',
                event => progress(event.lengthComputable, event.loaded, event.total)
              )
            }
          })

          uploader.create((errorResponse, blob) => {
            if (errorResponse) {
              error(`Something went wrong: ${errorResponse}`)
            } else {
              // See https://edgeguides.rubyonrails.org/active_storage_overview.html#direct-upload-javascript-events
              // See https://stackoverflow.com/questions/75586818
              load(blob.signed_id)
            }
          })

          return {
            abort: () => abort()
          }
        },
        headers: {
          'X-CSRF-Token': document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]')?.content
        }
      },
    })
  }

  private updateSubmit() {
    const files = this.pond.getFiles()
    const busyFiles = files.some(f => this.busyStatuses.has(f.status))
    busyFiles ? this.disableSubmit() : this.enableSubmit()
  }

  private enableSubmit() {
    this.submitButtons.forEach((button) => {
      button.disabled = false
    })
  }

  private disableSubmit() {
    this.submitButtons.forEach((button) => {
      button.disabled = true
    })
  }

  private get input() {
    return this.el.querySelector<HTMLLinkElement>('.js-formatic-file__input')
  }

  private get form() {
    return this.el.closest<HTMLFormElement>('form')
  }

  private get submitButtons() {
    return this.form.querySelectorAll<HTMLButtonElement>('[type="submit"]')
  }
}
