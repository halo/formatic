var Formatic;
(function (Formatic) {
    class Date {
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
    Formatic.Date = Date;
})(Formatic || (Formatic = {}));
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.js-formatic-date').forEach((el) => {
        console.debug('Instantiating Formatic.Date...');
        new Formatic.Date(el);
    });
});
var Formatic;
(function (Formatic) {
    class Select {
        constructor(el) {
            this.el = el;
            this.setupBindings();
        }
        setupBindings() {
            this.autosize();
            this.el.addEventListener('input', (event) => {
                event.preventDefault();
                if (this.autoSubmit)
                    this.actionSave();
            });
        }
        actionSave() {
            this.guiWaitingForSave();
            this.debounce(this.actionSaveNow.bind(this))();
        }
        actionSaveNow() {
            console.debug("Saving select...");
            this.el.classList.remove('is-loading');
            this.el.classList.add('is-saved');
            this.save();
        }
        guiWaitingForSave() {
            this.el.classList.add('is-loading');
            this.el.classList.remove('is-saved');
            this.el.classList.remove('is-failed');
        }
        guiSaved() {
            this.el.classList.remove('is-loading');
            this.el.classList.add('is-saved');
            this.el.classList.remove('is-failed');
        }
        guiFailed() {
            this.el.classList.remove('is-loading');
            this.el.classList.remove('is-saved');
            this.el.classList.add('is-failed');
        }
        get autoSubmit() {
            return this.el.classList.contains('is-autosubmit');
        }
        save() {
            const form = this.el.closest('form');
            const data = new FormData(form);
            data.set('_method', 'patch');
            fetch(form.action, { method: 'POST', body: data })
                .then(response => {
                if (response.status == 201) {
                    console.debug('Select content saved');
                    this.guiSaved();
                }
                else {
                    console.debug('Select content not saved');
                    this.guiFailed();
                }
            }).catch(err => {
                console.warn(err);
                console.debug('Failed badly to save');
            });
        }
        debounce(fn) {
            return () => {
                clearTimeout(this.timeoutId);
                this.timeoutId = setTimeout(() => fn(), 1000);
            };
        }
        autosize() {
            try {
                autosize(this.el);
            }
            catch (error) {
                console.warn(`Formatic is missing the autosize library`);
            }
        }
    }
    Formatic.Select = Select;
})(Formatic || (Formatic = {}));
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.js-formatic-select').forEach((el) => {
        console.debug('Instantiating Formatic.Select...');
        new Formatic.Select(el);
    });
});
var Formatic;
(function (Formatic) {
    class Stepper {
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
    Formatic.Stepper = Stepper;
})(Formatic || (Formatic = {}));
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.js-formatic-stepper').forEach((el) => {
        console.debug('Instantiating Formatic.Stepper...');
        new Formatic.Stepper(el);
    });
});
var Formatic;
(function (Formatic) {
    class String {
        constructor(el) {
            this.el = el;
            this.setupBindings();
        }
        setupBindings() {
            this.el.addEventListener('input', (event) => {
                event.preventDefault();
                if (this.autoSubmit)
                    this.actionSave();
            });
        }
        actionSave() {
            this.guiWaitingForSave();
            this.debounce(this.actionSaveNow.bind(this))();
        }
        actionSaveNow() {
            console.debug("Saving text input...");
            this.el.classList.remove('is-loading');
            this.el.classList.add('is-saved');
            this.save();
        }
        guiWaitingForSave() {
            this.el.classList.add('is-loading');
            this.el.classList.remove('is-saved');
            this.el.classList.remove('is-failed');
        }
        guiSaved() {
            this.el.classList.remove('is-loading');
            this.el.classList.add('is-saved');
            this.el.classList.remove('is-failed');
        }
        guiFailed() {
            this.el.classList.remove('is-loading');
            this.el.classList.remove('is-saved');
            this.el.classList.add('is-failed');
        }
        get autoSubmit() {
            return this.el.classList.contains('is-autosubmit');
        }
        save() {
            const form = this.el.closest('form');
            const data = new FormData(form);
            data.set('_method', 'patch');
            fetch(form.action, { method: 'POST', body: data })
                .then(response => {
                if (response.status == 201) {
                    console.debug('String content saved');
                    this.guiSaved();
                }
                else {
                    console.debug('String content not saved');
                    this.guiFailed();
                }
            }).catch(err => {
                console.warn(err);
                console.debug('Failed badly to save');
            });
        }
        debounce(fn) {
            return () => {
                clearTimeout(this.timeoutId);
                this.timeoutId = setTimeout(() => fn(), 1000);
            };
        }
    }
    Formatic.String = String;
    document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('.js-formatic-string').forEach((el) => {
            console.debug('Instantiating Formatic.String...');
            new Formatic.String(el);
        });
    });
})(Formatic || (Formatic = {}));
var Formatic;
(function (Formatic) {
    class Textarea {
        constructor(el) {
            this.el = el;
            this.setupBindings();
        }
        setupBindings() {
            this.autosize();
            this.el.addEventListener('input', (event) => {
                event.preventDefault();
                if (this.autoSubmit)
                    this.actionSave();
            });
        }
        actionSave() {
            this.guiWaitingForSave();
            this.debounce(this.actionSaveNow.bind(this))();
        }
        actionSaveNow() {
            console.debug("Saving textarea...");
            this.el.classList.remove('is-loading');
            this.el.classList.add('is-saved');
            this.save();
        }
        guiWaitingForSave() {
            this.el.classList.add('is-loading');
            this.el.classList.remove('is-saved');
            this.el.classList.remove('is-failed');
        }
        guiSaved() {
            this.el.classList.remove('is-loading');
            this.el.classList.add('is-saved');
            this.el.classList.remove('is-failed');
        }
        guiFailed() {
            this.el.classList.remove('is-loading');
            this.el.classList.remove('is-saved');
            this.el.classList.add('is-failed');
        }
        get autoSubmit() {
            return this.el.classList.contains('is-autosubmit');
        }
        save() {
            const form = this.el.closest('form');
            const data = new FormData(form);
            data.set('_method', 'patch');
            fetch(form.action, { method: 'POST', body: data })
                .then(response => {
                if (response.status == 201) {
                    console.debug('Textarea content saved');
                    this.guiSaved();
                }
                else {
                    console.debug('Textarea content not saved');
                    this.guiFailed();
                }
            }).catch(err => {
                console.warn(err);
                console.debug('Failed badly to save');
            });
        }
        debounce(fn) {
            return () => {
                clearTimeout(this.timeoutId);
                this.timeoutId = setTimeout(() => fn(), 1000);
            };
        }
        autosize() {
            try {
                autosize(this.el);
            }
            catch (error) {
                console.warn(`Formatic is missing the autosize library`);
            }
        }
    }
    Formatic.Textarea = Textarea;
    document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('.js-formatic-textarea').forEach((el) => {
            console.debug('Instantiating Formatic.Textarea...');
            new Formatic.Textarea(el);
        });
    });
})(Formatic || (Formatic = {}));
var Formatic;
(function (Formatic) {
    class Toggle {
        constructor(el) {
            this.el = el;
            this.setupBindings();
        }
        setupBindings() {
            this.checkbox.addEventListener('click', (event) => {
                event.preventDefault();
                const box = event.target;
                box.checked ? this.activate(box) : this.deactivate(box);
            });
        }
        activate(box) {
            const form = box.closest('form');
            const data = new FormData(form);
            data.set('_method', 'patch');
            fetch(form.action, { method: 'POST', body: data })
                .then(response => {
                if (response.status == 201) {
                    console.debug('Activation confirmed');
                    box.checked = true;
                }
                else {
                    console.debug('Activation not confirmed');
                    console.log("Activation denied");
                }
            }).catch(err => {
                console.warn(err);
                console.debug('Failed badly to activate');
            });
        }
        deactivate(box) {
            const form = box.closest('form');
            const data = new FormData(form);
            data.set('_method', 'delete');
            fetch(form.action, { method: 'POST', body: data })
                .then(response => {
                if (response.status == 204) {
                    console.debug('Deactivation confirmed');
                    box.checked = false;
                }
                else {
                    console.debug('Deactivation not confirmed');
                    console.log("Deactivation denied");
                }
            }).catch(err => {
                console.warn(err);
                console.debug('Failed badly to deactivate');
            });
        }
        get checkbox() {
            return this.el.querySelector('input[type="checkbox"]');
        }
    }
    Formatic.Toggle = Toggle;
})(Formatic || (Formatic = {}));
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.js-formatic-toggle').forEach((el) => {
        console.debug('Instantiating Formatic::Toggle...');
        new Formatic.Toggle(el);
    });
});
//# sourceMappingURL=formatic.js.map