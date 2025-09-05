# config/importmap.rb

pin "application", preload: true

# Hotwire
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus",    to: "stimulus.min.js", preload: true
# (no usamos @hotwired/stimulus-loading en modo manual)

# Bootstrap + Popper (ESM desde CDN)
pin "bootstrap",      to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.esm.min.js", preload: true
pin "@popperjs/core", to: "https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/esm/index.js", preload: true

# ===== Pines explícitos para controllers (nota el .js al final de "to:")
pin "controllers/application",                  to: "controllers/application.js", preload: true
pin "controllers/hover_partial_controller",     to: "controllers/hover_partial_controller.js"
pin "controllers/prtcpnts_fields_controller",   to: "controllers/prtcpnts_fields_controller.js"
pin "controllers/conditional_fields_controller",to: "controllers/conditional_fields_controller.js"
pin "controllers/logo_preview_controller",		to: "controllers/logo_preview_controller.js"

# (IMPORTANTE) Quita cualquier pin_all_from previo para evitar duplicados/ambigüedad.
# # pin_all_from "app/javascript/controllers", under: "controllers"

# Tus scripts propios
pin "ticker", to: "ticker.js", preload: true
