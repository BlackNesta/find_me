import { Controller } from "@hotwired/stimulus"

// Toggle between adding an existing user and creating a new one. Inputs in the
// hidden section are disabled so they aren't submitted.
export default class extends Controller {
  static targets = ["radio", "existing", "new"]

  connect() {
    this.toggle()
  }

  toggle() {
    const mode = this.radioTargets.find((radio) => radio.checked)?.value
    this.apply(this.existingTarget, mode === "existing")
    this.apply(this.newTarget, mode === "new")
  }

  apply(section, active) {
    section.hidden = !active
    section.querySelectorAll("input, select").forEach((el) => { el.disabled = !active })
  }
}
