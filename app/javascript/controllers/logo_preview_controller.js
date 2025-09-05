// app/javascript/controllers/logo_preview_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["img", "filename"]

  show(event) {
    const file = event.target.files?.[0]
    if (!file) return

    // Nombre del archivo
    if (this.hasFilenameTarget) {
      this.filenameTarget.textContent = file.name
    }

    // Preview si es imagen raster (png/jpg/webp). Para SVG mostramos sin FileReader.
    if (file.type === "image/svg+xml") {
      const url = URL.createObjectURL(file)
      this.imgTarget.src = url
      return
    }

    if (file.type.startsWith("image/")) {
      const reader = new FileReader()
      reader.onload = e => {
        this.imgTarget.src = e.target.result
      }
      reader.readAsDataURL(file)
    }
  }
}
