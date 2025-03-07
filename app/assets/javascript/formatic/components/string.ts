namespace Formatic {
  export class String {
    private el: HTMLElement
    private timeoutId: ReturnType<typeof setTimeout>

    constructor(el: HTMLElement) {
      this.el = el
      this.setupBindings()
    }

    private setupBindings() {
      this.el.addEventListener('input', (event) => {
        event.preventDefault()
        if (this.autoSubmit) this.actionSave()
      })
    }

    // ACTIONS

    private actionSave() {
      this.guiWaitingForSave()
      this.debounce(this.actionSaveNow.bind(this))()
    }

    private actionSaveNow() {
      console.debug("Saving text input...")
      this.el.classList.remove('is-loading')
      this.el.classList.add('is-saved')
      this.save()
    }

    // GUI

    private guiWaitingForSave() {
      this.el.classList.add('is-loading')
      this.el.classList.remove('is-saved')
      this.el.classList.remove('is-failed')
    }

    private guiSaved() {
      this.el.classList.remove('is-loading')
      this.el.classList.add('is-saved')
      this.el.classList.remove('is-failed')
    }

    private guiFailed() {
      this.el.classList.remove('is-loading')
      this.el.classList.remove('is-saved')
      this.el.classList.add('is-failed')
    }

    // Attributes

    private get autoSubmit() {
      return this.el.classList.contains('is-autosubmit')
    }

    // Helpers

    private save() {
      const form = this.el.closest<HTMLFormElement>('form')
      const data = new FormData(form)
      data.set('_method', 'patch')

      fetch(form.action, {
        method: 'POST',
        headers: { 'Accept': 'text/javascript' },
        body: data
      })
        .then(response => {
          if (response.status == 201) {
            console.debug('String content saved')
            this.guiSaved()
          } else {
            console.debug('String content not saved')
            this.guiFailed()
          }
        }).catch(err => {
          console.warn(err)
          console.debug('Failed badly to save')
        })
    }

    private debounce(fn: Function) {
      return () => {
        clearTimeout(this.timeoutId)
        this.timeoutId = setTimeout(() => fn(), 1000)
      }
    }

  }

  // --------------
  // Initialization
  // --------------

  document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll<HTMLElement>('.js-formatic-string').forEach((el) => {
      console.debug('Instantiating Formatic.String...')
      new Formatic.String(el)
    })
  })
}
