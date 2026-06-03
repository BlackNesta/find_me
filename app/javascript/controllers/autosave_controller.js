import { Controller } from "@hotwired/stimulus"

// Debounced autosave; aborts any in-flight request so a slow older save
// can't land after a newer one.
export default class extends Controller {
  static targets = ["field"]
  static values = { delay: { type: Number, default: 400 } }

  connect() {
    this.lastSaved = this.hasFieldTarget ? this.fieldTarget.value : ""
  }

  disconnect() {
    clearTimeout(this.timeout)
    this.abort()
  }

  save() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.perform(), this.delayValue)
  }

  submit(event) {
    event?.preventDefault()
    clearTimeout(this.timeout)
    this.perform()
  }

  async perform() {
    const value = this.hasFieldTarget ? this.fieldTarget.value : ""
    if (value === this.lastSaved) return

    this.abort()
    this.controller = new AbortController()

    try {
      const response = await fetch(this.element.action, {
        method: this.element.getAttribute("method") || "post",
        body: new FormData(this.element),
        headers: { Accept: "text/vnd.turbo-stream.html" },
        credentials: "same-origin",
        signal: this.controller.signal
      })

      window.Turbo.renderStreamMessage(await response.text())
      if (response.ok) this.lastSaved = value
    } catch (error) {
      if (error.name !== "AbortError") throw error
    }
  }

  abort() {
    this.controller?.abort()
    this.controller = null
  }
}
