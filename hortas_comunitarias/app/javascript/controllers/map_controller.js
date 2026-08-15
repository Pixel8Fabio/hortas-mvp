import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values = { gardens: Array }

  connect() {
    if (!window.L || this.gardensValue.length === 0) return

    const first = this.gardensValue[0]
    this.map = L.map(this.containerTarget).setView([first.latitude, first.longitude], 13)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "&copy; OpenStreetMap contributors"
    }).addTo(this.map)

    const bounds = []
    this.gardensValue.forEach((garden) => {
      const point = [garden.latitude, garden.longitude]
      bounds.push(point)
      L.marker(point)
        .addTo(this.map)
        .bindPopup(`<a href="${garden.url}">${garden.name}</a>`)
    })

    if (bounds.length > 1) this.map.fitBounds(bounds, { padding: [30, 30] })
  }

  disconnect() {
    this.map?.remove()
  }
}
