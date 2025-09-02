// app/javascript/controllers/dynamic_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "receptorDenuncia",
    "empresaExternaGroup",
    "viaDeclaracion",
    "tipoDeclaracionGroup",
    "presentadoPor",
    "representanteGroup"
  ]

  connect() {
    console.log("Conectado:", this.element);
    // Mostrar/ocultar campos inicialmente según los valores actuales
    this.toggleEmpresaExterna();
    this.toggleTipoDeclaracion();
    this.toggleRepresentante();
  }

  // Método para receptor_denuncia → empresa_externa
  toggleEmpresaExterna() {
    const show = this.receptorDenunciaTarget.value === 'Empresa externa';
    this.empresaExternaGroupTarget.hidden = !show;
    
    // Actualizar clases de form-floating
    this.toggleFloatingClass(this.empresaExternaGroupTarget, show);
  }

  // Método para via_declaracion → tipo_declaracion
  toggleTipoDeclaracion() {
    const show = this.viaDeclaracionTarget.value === 'Presencial';
    this.tipoDeclaracionGroupTarget.hidden = !show;
    
    // Actualizar clases de form-floating
    this.toggleFloatingClass(this.tipoDeclaracionGroupTarget, show);
  }

  // Método para presentado_por → representante
  toggleRepresentante() {
    const show = this.presentadoPorTarget.value === 'Representante';
    this.representanteGroupTarget.hidden = !show;
    
    // Actualizar clases de form-floating
    this.toggleFloatingClass(this.representanteGroupTarget, show);
  }

  // Helper para manejar las clases de form-floating de Bootstrap
  toggleFloatingClass(element, show) {
    if (show) {
      element.classList.add('form-floating');
      element.querySelector('select, input')?.classList.add('form-control');
    } else {
      element.classList.remove('form-floating');
      element.querySelector('select, input')?.classList.remove('form-control');
    }
  }
}