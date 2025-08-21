// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

// Importaciones ES (usando importmaps)
import "@hotwired/turbo-rails"
import "controllers/application"
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap // Make bootstrap available globally

import "echarts"
import "echarts/theme/dark"

// Finalmente tus controladores personalizados
import PrtcpntsFieldsController from "controllers/prtcpnts_fields"
import ConditionalFieldsController from "controllers/conditional_fields"
import { application } from "controllers/application"

application.register("prtcpnts-fields", PrtcpntsFieldsController)
application.register("conditional-fields", ConditionalFieldsController)

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

// Initialize Bootstrap components with Turbo compatibility
function initializeBootstrap() {
  // Initialize Tooltips
  const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })

  // Initialize Dropdowns
  const dropdownToggleList = [].slice.call(document.querySelectorAll('.dropdown-toggle'))
  dropdownToggleList.map(function (dropdownToggle) {
    dropdownToggle.addEventListener('click', function (e) {
      e.preventDefault()
      const dropdown = bootstrap.Dropdown.getOrCreateInstance(this)
      dropdown.toggle()
    })
  })

  // Close dropdowns when clicking outside
  document.addEventListener('click', function (e) {
    if (!e.target.closest('.dropdown')) {
      const openDropdowns = [].slice.call(document.querySelectorAll('.dropdown-toggle.show'))
      openDropdowns.map(function (openDropdown) {
        const dropdown = bootstrap.Dropdown.getInstance(openDropdown)
        if (dropdown) dropdown.hide()
      })
    }
  })

  // Initialize Modals
  const modalTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="modal"]'))
  modalTriggerList.map(function (modalTriggerEl) {
    modalTriggerEl.addEventListener('click', function () {
      const target = modalTriggerEl.getAttribute('data-bs-target')
      const modal = bootstrap.Modal.getOrCreateInstance(document.querySelector(target))
      modal.show()
    })
  })
}

// Turbo events
document.addEventListener('turbo:load', initializeBootstrap)
document.addEventListener('turbo:render', initializeBootstrap)
document.addEventListener('turbo:frame-render', initializeBootstrap)

// Regular load event
document.addEventListener('DOMContentLoaded', initializeBootstrap)