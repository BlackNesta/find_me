import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.tooltip = new window.bootstrap.Tooltip(this.element, {
      title: this.element.dataset.title || ""
    });
  }

  disconnect() {
    this.tooltip.dispose()
  }
}
