// app/javascript/controllers/hover_partial_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]
  static values = {
    url: String,
    loaded: { type: Boolean, default: false },
    open: { type: Boolean, default: false }
  }

  connect() {
    // Registro global para coordinar instancias
    window.__hoverPartialControllers ||= new Set()
    window.__hoverPartialControllers.add(this)
    this._requestId = 0
  }

  disconnect() {
    window.__hoverPartialControllers?.delete(this)
    if (window.__hoverPartialOpen === this) window.__hoverPartialOpen = null
  }

  async open(event) {
    try { await this.loadIfNeeded(); this.show() } catch (e) {}
  }

  close(event) {
    if (this.openValue) this.hide()
  }

  async toggle(event) {
    event?.preventDefault()
    if (this.openValue) {
      this.hide()
    } else {
      try { await this.loadIfNeeded(); this.show() } catch (e) {}
    }
  }

  keydown(event) {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault()
      this.toggle()
    }
  }

  async loadIfNeeded() {
    if (this.loadedValue) return
    if (!this.hasPanelTarget) return
    if (!this.urlValue) throw new Error("Falta data-hover-partial-url-value")

    this.panelTarget.innerHTML = '<div class="text-center py-3 small opacity-75">Cargando…</div>'

    const reqId = ++this._requestId
    const res = await fetch(this.urlValue, {
      headers: { "X-Requested-With": "XMLHttpRequest" },
      credentials: "same-origin",
      cache: "no-store"
    })

    if (!res.ok) {
      this.panelTarget.innerHTML = `<div class="alert alert-warning mb-0">No se pudo cargar el contenido (HTTP ${res.status}).</div>`
      this.loadedValue = true
      return
    }

    if (reqId !== this._requestId) return

    const html = await res.text()
    this.panelTarget.innerHTML = html
    this.loadedValue = true
  }

  show() {
    // Cierra el que estuviera abierto antes (si lo hay)
    if (window.__hoverPartialOpen && window.__hoverPartialOpen !== this) {
      window.__hoverPartialOpen.hide()
    }
    window.__hoverPartialOpen = this

    // Abrir con animación
    this.panelTarget.style.display = "block"
    this.panelTarget.style.maxHeight = "0px"
    this.panelTarget.classList.add("is-open")

    const targetHeight = this.panelTarget.scrollHeight
    requestAnimationFrame(() => {
      this.panelTarget.style.maxHeight = `${targetHeight}px`
      this.panelTarget.style.opacity = "1"
    })

    this.triggerElement.setAttribute("aria-expanded", "true")
    this.openValue = true
  }

  hide() {
    const onTransitionEnd = (e) => {
      if (e.propertyName === "max-height") {
        this.panelTarget.classList.remove("is-open")
        this.panelTarget.style.display = "none"
        this.panelTarget.style.opacity = "0"
        this.panelTarget.removeEventListener("transitionend", onTransitionEnd)
      }
    }
    this.panelTarget.addEventListener("transitionend", onTransitionEnd)

    // Cerrar con animación (¡resetear inline style!)
    this.panelTarget.style.maxHeight = "0px"
    this.triggerElement.setAttribute("aria-expanded", "false")
    this.openValue = false

    if (window.__hoverPartialOpen === this) {
      window.__hoverPartialOpen = null
    }
  }

  // Cierra cualquier otro usando su hide() para mantener estado consistente
  closeOthers() {
    (window.__hoverPartialControllers || []).forEach((ctrl) => {
      if (ctrl !== this && ctrl.openValue) ctrl.hide()
    })
  }

  get triggerElement() {
    return this.element.querySelector("[role='button']") || this.element
  }
}
