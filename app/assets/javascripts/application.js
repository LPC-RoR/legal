// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require popper
//= require bootstrap-sprockets
//= require chartkick
//= require Chart.bundle

$(document).ready(function(){
  $('[data-toggle="tooltip"]').tooltip(); 
});

// app/javascript/packs/application.js
document.addEventListener('turbolinks:load', function() {
  const formModal = document.getElementById('formModal');

  formModal.addEventListener('show.bs.modal', function (event) {
    const button = event.relatedTarget; // Botón que activó el modal
    const action = button.getAttribute('data-action'); // Acción (new o edit)

    if (action === 'new') {
      const modalBody = document.getElementById('modalBody');
      const form = modalBody.querySelector('form');

      if (form) {
        // Inicializar campos aquí
        const campoInput = form.querySelector('#tu_modelo_campo');
        if (campoInput) {
          campoInput.value = 'Valor predeterminado';
        }
      }
    }
  });
});

// app/javascript/packs/application.js
document.addEventListener('turbolinks:load', function() {
  const formModal = document.getElementById('formModal');

  // Limpiar el contenido del modal cuando se cierre
  formModal.addEventListener('hidden.bs.modal', function () {
    document.getElementById('modalBody').innerHTML = ''; // Vacía el contenido del modal
  });
});