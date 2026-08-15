import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ["menu", "button"]

  toggle() {
    const isOpen = this.menuTarget.classList.toggle("is-open")
    this.buttonTarget.classList.toggle("is-active", isOpen)
    this.buttonTarget.setAttribute("aria-expanded", isOpen)
  }

  close() {
    this.menuTarget.classList.remove("is-open")
    this.buttonTarget.classList.remove("is-active")
    this.buttonTarget.setAttribute("aria-expanded", "false")
  }
}
