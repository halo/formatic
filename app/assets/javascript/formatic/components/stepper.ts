namespace Formatic {
  export class Stepper {
    private el: HTMLElement

    constructor(el: HTMLElement) {
      this.el = el
      this.setupBindings()
    }

    private setupBindings() {
      this.incrementButtons.forEach((el) => {
        el.addEventListener('click', (event) => {
          event.preventDefault()
          this.increment()
        })
      })

      this.decrementButtons.forEach((el) => {
        el.addEventListener('click', (event) => {
          event.preventDefault()
          this.decrement()
        })
      })

      this.numberInput.addEventListener('click', (event) => {
        this.numberInput.select()
      })
    }

    private increment() {
      if (!this.number && this.number != 0) {
        // Incrementing leads to `0` (it's common to quickly want to achieve the number zero).
        // But if the minimum is e.g. `1` then it should be that instead.
        this.numberInput.value = Math.max(...[0, this.minimum]).toString()
      } else if (isNaN(this.number)) {
        // Do nothing on weird stuff.
        return
      } else if (this.number < this.minimum) {
        this.numberInput.value = this.minimum.toString()
      } else {
        this.numberInput.value = (this.number + 1).toString()
      }
    }

    private decrement() {
      if (!this.number && this.number != 0) {
        // Decementing empty leads to `-1`.
        // But if the minimum is e.g. `0` then it should be that instead.
        this.numberInput.value = Math.max(...[-1, this.minimum]).toString()
      } else if (isNaN(this.number)) {
        // Do nothing on weird stuff.
        return
      } else if (this.number <= this.minimum) {
        // Do nothing if at the minimum already
        return
      } else {
        // Normal decrement.
        this.numberInput.value = (this.number - 1).toString()
      }
    }

    private get minimum() {
      return parseInt(this.numberInput.min)
    }

    private get number() {
      return parseInt(this.numberInput.value)
    }

    private get incrementButtons() {
      return this.el.querySelectorAll<HTMLLinkElement>('.js-formatic-stepper__increment')
    }

    private get decrementButtons() {
      return this.el.querySelectorAll<HTMLLinkElement>('.js-formatic-stepper__decrement')
    }

    private get numberInput() {
      return this.el.querySelector<HTMLInputElement>('.js-formatic-stepper__number')
    }
  }
}

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll<HTMLElement>('.js-formatic-stepper').forEach((el) => {
    console.debug('Instantiating Formatic.Stepper...')
    new Formatic.Stepper(el)
  })
})
