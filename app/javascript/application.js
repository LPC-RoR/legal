// app/javascript/application.js

// 1) Turbo debe cargar ANTES que cualquier otra cosa
import "@hotwired/turbo-rails"

// 2) Stimulus (instancia)
import { application } from "controllers/application"

// 3) Bootstrap (ESM)
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap

// 4) Scripts propios
import "ticker"

// 5) REGISTRO MANUAL DE CONTROLADORES (los nombres deben existir tal cual)
import HoverPartialController       from "controllers/hover_partial_controller"
import PrtcpntsFieldsController     from "controllers/prtcpnts_fields_controller"
import ConditionalFieldsController  from "controllers/conditional_fields_controller"

application.register("hover-partial",      HoverPartialController)
application.register("prtcpnts-fields",    PrtcpntsFieldsController)
application.register("conditional-fields", ConditionalFieldsController)

// 6) Debug
console.log("[app] window.Turbo:", typeof window.Turbo)
console.log("[app] Stimulus controllers:", Array.from(application.router.modulesByIdentifier.keys()))
