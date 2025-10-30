import * as FilePond from "filepond";
export var File;
(function (File) {
    function setup() {
        const input = document.querySelector('.js-formatic-file__input');
        FilePond.create(input);
    }
    File.setup = setup;
})(File || (File = {}));
//# sourceMappingURL=file.js.map