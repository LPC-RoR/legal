// app/javascript/controllers/application.js
import { Application } from "@hotwired/stimulus"

export const application = Application.start()
application.debug = true

console.log("[Stimulus] application iniciada (manual)")
