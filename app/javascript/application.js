// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"
import "turbo_init"
import "controllers"
//import { Turbo } from "@hotwired/turbo-rails"

// Debugging de carga de Turbo
document.addEventListener('DOMContentLoaded', () => {
  console.log('Turbo disponible:', typeof Turbo !== 'undefined')
  
  if (typeof Turbo === 'undefined') {
    console.error('Turbo no se cargó correctamente. Verifica:')
    console.error('1. Importación en application.js')
    console.error('2. Preload en importmap.rb')
    console.error('3. Errores en la consola')
  }
})

export default class extends Controller {
  connect() {
    console.log("Controlador PRTCPNT-FIELDS conectado!")
  }

  logAction() {
    console.log("¡Acción ejecutada correctamente!")
    alert("¡Funciona!") // Para verlo visualmente
  }
}

// app/javascript/application.js (o donde tengas tu JS principal)
document.addEventListener('DOMContentLoaded', () => {
  // Polyfill para redirección post-login
  if (window.location.pathname.includes('sign_in') && 
      document.cookie.includes('_legal_session')) {
    window.location.href = '/'
  }
  
  // Deshabilitar doble submit
  document.querySelectorAll('form').forEach(form => {
    form.addEventListener('submit', () => {
      const submitBtn = form.querySelector('[type="submit"]')
      if (submitBtn) submitBtn.disabled = true
    })
  })
})

// app/javascript/packs/application.js
document.addEventListener('turbo:load', function() {
  if (window.location.pathname === '/usuarios/sign_in' && document.cookie.match(/signed_in=true/)) {
    window.location.href = '/'
  }
})