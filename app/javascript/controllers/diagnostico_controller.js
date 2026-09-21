import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "formCard", "exito", "invitacion"]

  connect() {
    this.mostrarPaso(1)
  }

  get pasos() {
    return Array.from(this.element.querySelectorAll("[data-ls-paso]"))
  }

  mostrarPaso(n) {
    this.pasos.forEach((p) => {
      p.hidden = Number(p.dataset.lsPaso) !== n
    })
  }

  mostrarFeedback(event) {
    const paso = event.target.closest("[data-ls-paso]")
    const feedback = paso.querySelector(".ls-feedback")
    feedback.textContent = event.target.dataset.feedback
    feedback.hidden = false
    paso.querySelector(".ls-siguiente").hidden = false
  }

  siguiente(event) {
    const actual = Number(event.target.closest("[data-ls-paso]").dataset.lsPaso)
    if (actual === this.pasos.length) {
      if (this.hasInvitacionTarget) this.invitacionTarget.hidden = false
      this.formCardTarget.classList.add("ls-form-card--destacado")
      this.formCardTarget.scrollIntoView({ behavior: "smooth", block: "center" })
      return
    }
    this.mostrarPaso(actual + 1)
  }

  async enviar(event) {
    event.preventDefault()
    const boton = this.element.querySelector(".ls-enviar")
    boton.disabled = true
    const tokenMeta = document.querySelector("meta[name='csrf-token']")

    try {
      const resp = await fetch(this.formTarget.action, {
        method: "POST",
        headers: {
          "Accept": "application/json",
          "X-CSRF-Token": tokenMeta ? tokenMeta.content : ""
        },
        body: new FormData(this.formTarget)
      })

      if (resp.ok) {
        this.formTarget.hidden = true
        this.exitoTarget.hidden = false
        this.exitoTarget.scrollIntoView({ behavior: "smooth", block: "center" })
      } else {
        const datos = await resp.json().catch(() => ({}))
        alert((datos.errors || []).join("\n") || "No pudimos enviar el formulario. Revise los datos.")
        boton.disabled = false
      }
    } catch {
      this.formTarget.submit()
    }
  }
}