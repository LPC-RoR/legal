// app/javascript/controllers/hover_partial_controller.js
import { Controller } from "@hotwired/stimulus"

/**
 * Modo de uso en la vista:
 * data-controller="hover-partial"
 * data-hover-partial-url-value="<%= productos_partial_path('formales') %>"
 * data-action="mouseenter->hover-partial#open click->hover-partial#toggle keydown->hover-partial#keydown"
 * Targets: un contenedor para el contenido cargado: data-hover-partial-target="panel"
 *
 * Requiere un elemento "trigger" (el propio item) con role="button" para aria-expanded.
 */
export default class extends Controller {
  static targets = ["panel"]
  static values = {
    url: String,
    loaded: { type: Boolean, default: false },
    open: { type: Boolean, default: false }
  }

  connect() {
    console.log("Conectado:", this.element);
    // ID incremental para evitar race conditions entre múltiples fetch
    this._requestId = 0
  }

  // Abre al pasar el mouse (hover)
  async open(event) {
    try {
      await this.loadIfNeeded()
      this.show()
    } catch (e) {
      // opcional: console.warn(e)
    }
  }

  close(event) {
    // Cierra al salir del zoom-box (trigger), sin importar dónde vaya el puntero
    if (this.openValue) this.hide()
  }

  // Alterna con click o tap (móvil) y también sirve vía teclado
  async toggle(event) {
    event?.preventDefault()
    if (this.openValue) {
      this.hide()
    } else {
      try {
        await this.loadIfNeeded()
        this.show()
      } catch (e) {
        // opcional: console.warn(e)
      }
    }
  }

  // Soporte de teclado (Enter o Space)
  keydown(event) {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault()
      this.toggle()
    }
  }

  // Carga el partial vía AJAX una sola vez por wrapper
  async loadIfNeeded() {
    if (this.loadedValue) return
    if (!this.hasPanelTarget) return
    if (!this.urlValue) throw new Error("Falta data-hover-partial-url-value")

    // Indicador de carga simple (opcional)
    this.panelTarget.innerHTML = '<div class="text-center py-3 small opacity-75">Cargando…</div>'

    const reqId = ++this._requestId
    const res = await fetch(this.urlValue, {
      headers: { "X-Requested-With": "XMLHttpRequest" },
      credentials: "same-origin",   // necesario si usas authenticate_usuario!
      cache: "no-store"
    })

    if (!res.ok) {
      this.panelTarget.innerHTML = `<div class="alert alert-warning mb-0">No se pudo cargar el contenido (HTTP ${res.status}).</div>`
      this.loadedValue = true
      return
    }

    // Si llegó otra request luego, aborta esta inyección
    if (reqId !== this._requestId) return

    const html = await res.text()
    this.panelTarget.innerHTML = html
    this.loadedValue = true
  }

  show() {
    this.closeOthers()

    // Forzamos un reflow para poder animar desde 0
    this.panelTarget.style.display = "block"
    this.panelTarget.style.maxHeight = "0px"
    this.panelTarget.classList.add("is-open")

    // Calcular la altura real del contenido y animar hasta ahí
    const targetHeight = this.panelTarget.scrollHeight
    // En el siguiente frame aplicamos la altura final
    requestAnimationFrame(() => {
      this.panelTarget.style.maxHeight = `${targetHeight}px`
    })

    this.triggerElement.setAttribute("aria-expanded", "true")
    this.openValue = true
  }

  hide() {
    // Animar hacia 0 y, al terminar, ocultar
    const onTransitionEnd = (e) => {
      if (e.propertyName === "max-height") {
        this.panelTarget.classList.remove("is-open")
        this.panelTarget.style.display = "none"
        this.panelTarget.removeEventListener("transitionend", onTransitionEnd)
      }
    }
    this.panelTarget.addEventListener("transitionend", onTransitionEnd)

    this.panelTarget.style.maxHeight = "0px"
    this.triggerElement.setAttribute("aria-expanded", "false")
    this.openValue = false
  }

  // Cierra cualquier otro hover-panel abierto en la página
  closeOthers() {
    document.querySelectorAll(".hover-panel.is-open").forEach((panel) => {
      if (!this.element.contains(panel)) {
        panel.classList.remove("is-open")
        const btn = panel.closest(".hover-wrapper")?.querySelector("[role='button']")
        btn?.setAttribute("aria-expanded", "false")
      }
    })
  }

  // Encuentra el disparador para aria-expanded (o usa el wrapper como fallback)
  get triggerElement() {
    return this.element.querySelector("[role='button']") || this.element
  }
}
