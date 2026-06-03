import { Controller } from "@hotwired/stimulus"

// When an existing user is chosen from the dropdown, hide and disable the
// new-user fields so they aren't submitted.
export default class extends Controller {
  static targets = ["select", "new"]

  connect() {
    this.toggle()
  }

  toggle() {
    const creatingNew = this.selectTarget.value === ""
    this.newTarget.hidden = !creatingNew
    this.newTarget.querySelectorAll("input").forEach((el) => { el.disabled = !creatingNew })
  }
}
