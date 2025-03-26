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