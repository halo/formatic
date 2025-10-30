import { Date } from 'formatic/date';
import { Select } from 'formatic/select';
import { Stepper } from 'formatic/stepper';
import { String } from 'formatic/string';
import { Textarea } from 'formatic/textarea';
import { Toggle } from 'formatic/toggle';
export var Formatic;
(function (Formatic) {
    function setup() {
        document.querySelectorAll('.js-formatic-date').forEach((el) => {
            console.debug('[Formatic] Instantiating Date...');
            new Date(el);
        });
        document.querySelectorAll('.js-formatic-select').forEach((el) => {
            console.debug('[Formatic] Instantiating Select...');
            new Select(el);
        });
        document.querySelectorAll('.js-formatic-stepper').forEach((el) => {
            console.debug('[Formatic] Instantiating Stepper...');
            new Stepper(el);
        });
        document.querySelectorAll('.js-formatic-string').forEach((el) => {
            console.debug('[Formatic] Instantiating String...');
            new String(el);
        });
        document.querySelectorAll('.js-formatic-textarea').forEach((el) => {
            console.debug('[Formatic] Instantiating Textarea...');
            new Textarea(el);
        });
        document.querySelectorAll('.js-formatic-toggle').forEach((el) => {
            console.debug('[Formatic] Instantiating Toggle...');
            new Toggle(el);
        });
    }
    Formatic.setup = setup;
})(Formatic || (Formatic = {}));
//# sourceMappingURL=setup.js.map