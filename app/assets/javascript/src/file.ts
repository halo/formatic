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
  private inputID: string
  private inputName: string

  constructor(el: HTMLElement) {
    this.el = el
    this.url = (this.input.dataset.directUploadUrl as string || '')
    this.inputID = this.input.id
    this.inputName = this.input.name
    this.setupBindings()
  }

  private setupBindings() {
    console.log(this.input.dataset.entries)
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
      // onremovefile: (error, file) => this.removedFile(error, file),
      onupdatefiles: () => this.updatedFiles(),
      files: JSON.parse(this.input.dataset.entries || '[]') as FilePond.FilePondInitialFile[],
      server: {
        revert: null, // Don't send DELETE request when removing a file on a not-submitted-yet form.

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
      oninit: () => this.updateLabelId(),
    })
  }

  // FilePond replaces the <input id="X"> with <div id="X"><input id="something-new">
  // But the <form> may have <label for="X"> so we need to update them.
  // to become <label for="something-new">
  private updateLabelId() {
    if (!this.inputID) return

    const labels = this.form.querySelectorAll(`label[for="${this.inputID}"]`)
    if (labels.length === 0) return

    const pondInput = this.input.querySelector('input[type="file"]')
    if (!pondInput) return

    const pondInputId = pondInput.id;
    if (!pondInputId) return

    labels.forEach(label => label.setAttribute('for', pondInputId))
  }

  private updatedFiles() {
    // Showing a <form> for an existing record or submitting an invalid form
    // where multiple=true does not play well with filepond at all.
    if (this.pond.allowMultiple) return

    const files = this.pond.getFiles()
    this.hiddenFieldsContainer.innerHTML = ''

    files.forEach(file => {
      if (file.serverId) {
        const h = document.createElement('input')
        h.type = 'hidden'
        h.name = this.inputName
        h.value = file.serverId
        this.hiddenFieldsContainer.appendChild(h)
      }
    })

    if (files.length === 0) {
      const h = document.createElement('input')
      h.type = 'hidden'
      h.name = this.inputName
      h.value = ''
      this.hiddenFieldsContainer.appendChild(h)
    }

    this.updateSubmit()
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
    return this.el.querySelector<HTMLInputElement>('.js-formatic-file__input')
  }

  private get hiddenFieldsContainer() {
    return this.el.querySelector<HTMLElement>('.js-formatic-file__hidden-fields')
  }

  private get form() {
    return this.el.closest<HTMLFormElement>('form')
  }

  private get submitButtons() {
    return this.form.querySelectorAll<HTMLButtonElement>('[type="submit"]')
  }
}
