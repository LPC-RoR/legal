// app/javascript/controllers/prtcpnts_fields_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["empresaCheckbox", "articuloCheckbox", "empresaField", "articuloField"]

  connect() {
    console.log("Controlador conectado - Targets encontrados:", {
      empresaCheckbox: this.empresaCheckboxTarget,
      articuloCheckbox: this.articuloCheckboxTarget,
      empresaField: this.empresaFieldTarget,
      articuloField: this.articuloFieldTarget
    })
    
    this.updateFields() // Estado inicial
  }

  updateFields() {
    this.updateFieldVisibility(this.empresaCheckboxTarget, this.empresaFieldTarget)
    this.updateFieldVisibility(this.articuloCheckboxTarget, this.articuloFieldTarget)
  }

  updateFieldVisibility(checkbox, fieldElement) {
    if (!checkbox || !fieldElement) {
      console.error("Elemento no encontrado:", { checkbox, fieldElement })
      return
    }
    
    const isVisible = checkbox.checked
    fieldElement.style.display = isVisible ? 'block' : 'none'
    
    // Opcional: deshabilitar campos ocultos
    fieldElement.querySelectorAll('input, select').forEach(input => {
      input.disabled = !isVisible
    })
  }
}