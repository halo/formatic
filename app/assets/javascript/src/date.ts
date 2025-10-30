export class Date {
  private el: HTMLElement

  constructor(el: HTMLElement) {
    this.el = el
    this.setupBindings()
  }

  private setupBindings() {
    this.shortcutButtons.forEach((el) => {
      el.addEventListener('click', (event) => {
        event.preventDefault()
        const shortcut = <HTMLInputElement>event.currentTarget

        this.dayInput.value = shortcut.dataset.day
        this.monthInput.value = shortcut.dataset.month
        this.yearInput.value = shortcut.dataset.year
      })
    })
  }

  // ------------
  // DOM Elements
  // ------------

  private get dayInput() {
    return this.el.querySelector<HTMLSelectElement>('.js-formatic-date__day')
  }

  private get monthInput() {
    return this.el.querySelector<HTMLSelectElement>('.js-formatic-date__month')
  }

  private get yearInput() {
    return this.el.querySelector<HTMLSelectElement>('.js-formatic-date__year')
  }

  private get shortcutButtons() {
    return this.el.querySelectorAll<HTMLElement>('.js-formatic-date__shortcut')
  }
}
