import { Application } from "@hotwired/stimulus"
import PrtcpntsFieldsController from "./controllers/prtcpnts_fields_controller"

const application = Application.start()
application.register("prtcpnts-fields", PrtcpntsFieldsController)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

console.log("Controllers registrados:", application.controllers)