// app/javascript/controllers/application.js
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

const application = Application.start()
application.register("prtcpnts-fields", PrtcpntsFieldsController)

window.Stimulus = application
const context = require.context("controllers", true, /\.js$/)
Stimulus.load(definitionsFromContext(context))

export { application }
