var Formatic;
(function (Formatic) {
    class Date {
    }
    Formatic.Date = Date;
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