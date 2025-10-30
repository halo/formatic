import * as FilePond from "filepond"
// import DirectUpload from "@rails/activestorage"


export namespace File {
  export function setup() {
    const input = document.querySelector('.js-formatic-file__input')
    FilePond.create(input)
  }
}
