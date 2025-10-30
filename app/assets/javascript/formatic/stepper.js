export class Stepper {
    constructor(el) {
        this.el = el;
        this.setupBindings();
    }
    setupBindings() {
        this.incrementButtons.forEach((el) => {
            el.addEventListener('click', (event) => {
                event.preventDefault();
                this.increment();
            });
        });
        this.decrementButtons.forEach((el) => {
            el.addEventListener('click', (event) => {
                event.preventDefault();
                this.decrement();
            });
        });
        this.numberInput.addEventListener('click', (event) => {
            this.numberInput.select();
        });
    }
    increment() {
        if (!this.number && this.number != 0) {
            this.numberInput.value = Math.max(...[0, this.minimum]).toString();
        }
        else if (isNaN(this.number)) {
            return;
        }
        else if (this.number < this.minimum) {
            this.numberInput.value = this.minimum.toString();
        }
        else {
            this.numberInput.value = (this.number + 1).toString();
        }
    }
    decrement() {
        if (!this.number && this.number != 0) {
            this.numberInput.value = Math.max(...[-1, this.minimum]).toString();
        }
        else if (isNaN(this.number)) {
            return;
        }
        else if (this.number <= this.minimum) {
            return;
        }
        else {
            this.numberInput.value = (this.number - 1).toString();
        }
    }
    get minimum() {
        return parseInt(this.numberInput.min);
    }
    get number() {
        return parseInt(this.numberInput.value);
    }
    get incrementButtons() {
        return this.el.querySelectorAll('.js-formatic-stepper__increment');
    }
    get decrementButtons() {
        return this.el.querySelectorAll('.js-formatic-stepper__decrement');
    }
    get numberInput() {
        return this.el.querySelector('.js-formatic-stepper__number');
    }
}
//# sourceMappingURL=stepper.js.map