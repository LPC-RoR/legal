// app/javascript/controllers/aprobacion_select_controller.js
import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  static values = { url: String, cliente: Number }

  connect() {
    this.cleanupOrphans()

    this.select = new TomSelect(this.element, {
      valueField: "id",
      labelField: "text",
      searchField: "text",
      preload: true,
      placeholder: "Buscar aprobación del cliente...",
      dropdownParent: "body",
      load: (query, callback) => {
        const params = new URLSearchParams({ q: query, cliente_id: this.clienteValue })
        fetch(`${this.urlValue}?${params}`)
          .then((response) => response.json())
          .then((json) => callback(json))
          .catch(() => callback())
      },
      render: {
        no_results: () => '<div class="p-2 text-muted">Sin aprobaciones para este cliente</div>'
      }
    })

    // Apertura garantizada con click (esquiva interferencias de otros scripts)
    this.select.control.addEventListener("click", () => {
      if (!this.select.isOpen) this.select.open()
    })
  }

  cleanupOrphans() {
    if (this.element.tomselect) {
      try { this.element.tomselect.destroy() } catch (e) {}
    }
    const wrapper = this.element.closest(".ts-wrapper")
    if (wrapper && wrapper.parentElement) {
      wrapper.replaceWith(this.element)
    }
    this.element.classList.remove("tomselected")
    this.element.style.display = ""
  }

  disconnect() {
    if (this.select) {
      try { this.select.destroy() } catch (e) {}
      this.select = null
    }
  }
}