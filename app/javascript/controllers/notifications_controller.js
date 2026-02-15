import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    const panel = document.getElementById("notifications_panel")
    if (panel) panel.classList.toggle("hidden")
  }
}
