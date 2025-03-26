import { Turbo } from "@hotwired/turbo-rails"
window.Turbo = Turbo
console.log("Turbo cargado, versión:", Turbo.VERSION)