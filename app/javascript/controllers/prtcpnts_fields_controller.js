// app/javascript/controllers/prtcpnts_fields_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["empresaCheckbox", "articuloCheckbox", "empresaField", "articuloField"]

  initialize() {
    console.log("Controlador de campos condicionales inicializado");
    this.updateFields(); // Establecer estado inicial
  }

  updateFields() {
    console.log("Actualizando campos condicionales");
    
    // Verificar si los targets existen antes de acceder a ellos
    if (this.hasEmpresaCheckboxTarget && this.hasEmpresaFieldTarget) {
      const visible = this.empresaCheckboxTarget.checked;
      this.empresaFieldTarget.style.display = visible ? 'block' : 'none';
      console.log(`Campo empresa: ${visible ? 'visible' : 'oculto'}`);
    }

    if (this.hasArticuloCheckboxTarget && this.hasArticuloFieldTarget) {
      const visible = this.articuloCheckboxTarget.checked;
      this.articuloFieldTarget.style.display = visible ? 'block' : 'none';
      console.log(`Campo artículo 516: ${visible ? 'visible' : 'oculto'}`);
    }
  }
}