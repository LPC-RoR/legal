// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

// Importaciones ES (usando importmaps)
import "@hotwired/turbo-rails"
//import "@popperjs/core"
import * as bootstrap from "bootstrap"
import "controllers"
window.bootstrap = bootstrap // Make bootstrap available globally

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

// Initialize Bootstrap components
function initializeBootstrap() {
  // Tooltips
  document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => {
    new bootstrap.Tooltip(el)
  })

  // Dropdowns - Correct initialization
  document.querySelectorAll('.dropdown-toggle').forEach(dropdown => {
    new bootstrap.Dropdown(dropdown)
  })

  // Modals
  document.querySelectorAll('[data-bs-toggle="modal"]').forEach(modalTriggerEl => {
    modalTriggerEl.addEventListener('click', () => {
      const target = modalTriggerEl.getAttribute('data-bs-target')
      const modal = bootstrap.Modal.getOrCreateInstance(document.querySelector(target))
      modal.show()
    })
  })
}

// Event listeners
document.addEventListener('turbo:load', initializeBootstrap)
document.addEventListener('turbo:render', initializeBootstrap)

// Initial call
document.addEventListener('DOMContentLoaded', initializeBootstrap)