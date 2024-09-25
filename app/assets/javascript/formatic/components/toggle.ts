namespace Formatic {
  export class Toggle {

    private el: HTMLElement

    constructor(el: HTMLElement) {
      this.el = el
      this.setupBindings()
    }

    private setupBindings() {
      this.checkbox.addEventListener('click', (event) => {
        event.preventDefault()
        const box = <HTMLInputElement>event.target
        box.checked ? this.activate(box) : this.deactivate(box)
      })
    }

    private activate(box: HTMLInputElement) {
      const form = box.closest<HTMLFormElement>('form')
      const data = new FormData(form)
      data.set('_method', 'patch')

      fetch(form.action, { method: 'POST', body: data })
        .then(response => {
          // For accurate user feedback, we make sure this is not an accidental 200.
          // Your controller needs to respond with 201 on create/update.
          if (response.status == 201) {
            console.debug('Activation confirmed')
            box.checked = true
          } else {
            console.debug('Activation not confirmed')
            console.log("Activation denied")
          }
        }).catch(err => {
          console.warn(err)
          console.debug('Failed badly to activate')
        })
    }

    private deactivate(box: HTMLInputElement) {
      const form = box.closest<HTMLFormElement>('form')
      const data = new FormData(form)
      data.set('_method', 'delete')

      fetch(form.action, { method: 'POST', body: data })
        .then(response => {
          // Your controller needs to respond with 204 on destroy.
          if (response.status == 204) {
            console.debug('Deactivation confirmed')
            box.checked = false
          } else {
            console.debug('Deactivation not confirmed')
            console.log("Deactivation denied")
          }
        }).catch(err => {
          console.warn(err)
          console.debug('Failed badly to deactivate')
        })
    }

    // ------------
    // DOM Elements
    // ------------

    private get checkbox() {
      return this.el.querySelector<HTMLInputElement>('input[type="checkbox"]')
    }
  }
}

// --------------
// Initialization
// --------------

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll<HTMLElement>('.js-formatic-toggle').forEach((el) => {
    console.debug('Instantiating Formatic::Toggle...')
    new Formatic.Toggle(el)
  })
})
