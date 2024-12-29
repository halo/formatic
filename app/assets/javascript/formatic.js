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
        console.debug('Instantiating InputDateComponent...');
        new Formatic.Date(el);
    });
});
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