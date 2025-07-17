// app/javascript/controllers/application.js
import { Application } from "@hotwired/stimulus"
// import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

const application = Application.start()
// eagerLoadControllersFrom("app/javascript/controllers", application)

// Export for potential use elsewhere
export { application }