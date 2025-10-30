import { Date } from 'formatic/date'
import { Select } from 'formatic/select'
import { Stepper } from 'formatic/stepper'
import { String } from 'formatic/string'
import { Textarea } from 'formatic/textarea'
import { Toggle } from 'formatic/toggle'
import { File } from 'formatic/file'

export namespace Formatic {
  export function setup() {
    File.setup()

    document.querySelectorAll<HTMLElement>('.js-formatic-date').forEach((el) => {
      console.debug('[Formatic] Instantiating Date...')
      new Date(el)
    })

    document.querySelectorAll<HTMLElement>('.js-formatic-select').forEach((el) => {
      console.debug('[Formatic] Instantiating Select...')
      new Select(el)
    })

    document.querySelectorAll<HTMLElement>('.js-formatic-stepper').forEach((el) => {
      console.debug('[Formatic] Instantiating Stepper...')
      new Stepper(el)
    })

    document.querySelectorAll<HTMLElement>('.js-formatic-string').forEach((el) => {
      console.debug('[Formatic] Instantiating String...')
      new String(el)
    })

    document.querySelectorAll<HTMLElement>('.js-formatic-textarea').forEach((el) => {
      console.debug('[Formatic] Instantiating Textarea...')
      new Textarea(el)
    })

    document.querySelectorAll<HTMLElement>('.js-formatic-toggle').forEach((el) => {
      console.debug('[Formatic] Instantiating Toggle...')
      new Toggle(el)
    })
  }
}
