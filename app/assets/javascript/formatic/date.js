export class Date {
    constructor(el) {
        this.el = el;
        this.setupBindings();
    }
    setupBindings() {
        this.shortcutButtons.forEach((el) => {
            el.addEventListener('click', (event) => {
                event.preventDefault();
                const shortcut = event.currentTarget;
                this.dayInput.value = shortcut.dataset.day;
                this.monthInput.value = shortcut.dataset.month;
                this.yearInput.value = shortcut.dataset.year;
            });
        });
    }
    get dayInput() {
        return this.el.querySelector('.js-formatic-date__day');
    }
    get monthInput() {
        return this.el.querySelector('.js-formatic-date__month');
    }
    get yearInput() {
        return this.el.querySelector('.js-formatic-date__year');
    }
    get shortcutButtons() {
        return this.el.querySelectorAll('.js-formatic-date__shortcut');
    }
}
//# sourceMappingURL=date.js.map