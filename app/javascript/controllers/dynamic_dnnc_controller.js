// app/javascript/controllers/dynamic_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["viaDeclaracion"]

  toggleTipoDeclaracion() {
    const viaDeclaracion = this.viaDeclaracionTarget.value
    const container = document.getElementById('tipo-declaracion-container')

    if (viaDeclaracion === 'Presencial') {
      container.classList.remove('d-none')
      
      // Opcional: Cargar el campo dinámicamente si no está en el DOM
      if (!container.innerHTML.trim()) {
        this.loadTipoDeclaracionField()
      }
    } else {
      container.classList.add('d-none')
    }
  }

  // Opcional: Cargar el campo via AJAX si prefieres
  loadTipoDeclaracionField() {
    fetch('/krn_denuncias/tipo_declaracion_field', {
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
  }
}