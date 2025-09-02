// app/javascript/ticker.js
(() => {
  const ready = () => {
    document.querySelectorAll('.ticker-wrapper').forEach((wrapper) => {
      const ticker   = wrapper.querySelector('.ticker');
      const track    = wrapper.querySelector('.ticker__track');
      const panel    = wrapper.querySelector('[data-role="panel"]');
      const panelTxt = wrapper.querySelector('[data-role="panel-text"]');
      const btnClose = wrapper.querySelector('[data-role="panel-close"]');
      if (!ticker || !track || !panel || !panelTxt) return;

      // Velocidad desde data-speed (en segundos)
      const speedAttr = ticker.getAttribute('data-speed');
      if (speedAttr) track.style.setProperty('--ticker-speed', `${Number(speedAttr)}s`);

      // Usa Bootstrap Collapse si está disponible (Importmap: import "bootstrap" en application.js)
      const BsCollapse = window.bootstrap && window.bootstrap.Collapse ? window.bootstrap.Collapse : null;
      let collapse = null;

      if (BsCollapse) {
        try {
          collapse = new BsCollapse(panel, { toggle: false });
        } catch (e) {
          console.warn('[ticker] Error inicializando Bootstrap Collapse:', e);
        }
      } else if (!window.__tickerBootstrapWarned) {
        console.warn('[ticker] Bootstrap JS no detectado; se usará fallback sin animación.');
        window.__tickerBootstrapWarned = true;
      }

      const isOpen = () => panel.classList.contains('show');

      const openPanel = (text) => {
        panelTxt.textContent = text || '';
        if (collapse) collapse.show();
        else panel.classList.add('show'); // fallback sin animación
      };

      const closePanel = () => {
        if (collapse) collapse.hide();
        else panel.classList.remove('show'); // fallback sin animación
        panelTxt.textContent = '';
      };

      const items = Array.from(wrapper.querySelectorAll('.ticker__item'));

      const markActive = (el) => {
        items.forEach(i => {
          i.classList.remove('text-dark', 'is-active');
          if (!i.classList.contains('text-secondary')) i.classList.add('text-secondary');
          i.setAttribute('aria-selected', 'false');
        });
        el.classList.remove('text-secondary');
        el.classList.add('text-dark', 'is-active');
        el.setAttribute('aria-selected', 'true');
      };

      const clearActive = () => {
        items.forEach(i => {
          i.classList.remove('text-dark', 'is-active');
          if (!i.classList.contains('text-secondary')) i.classList.add('text-secondary');
          i.setAttribute('aria-selected', 'false');
        });
      };

      items.forEach((item) => {
        if (item.dataset.tickerBound) return; // evita doble bind con Turbo
        item.dataset.tickerBound = '1';

        const detail = item.getAttribute('data-detail') || '';

        // Mostrar panel al pasar (hover/focus) — no cambia color
        item.addEventListener('mouseenter', () => openPanel(detail));
        item.addEventListener('focusin',   () => openPanel(detail));

        // Selección con click/tap: alterna y cambia a text-dark
        item.addEventListener('click', (e) => {
          e.preventDefault();
          if (isOpen() && item.classList.contains('is-active') && panelTxt.textContent === detail) {
            closePanel();
            clearActive();
          } else {
            openPanel(detail);
            markActive(item);
          }
        });

        // Teclado accesible (Enter/Espacio)
        item.addEventListener('keydown', (e) => {
          if (e.key === 'Enter' || e.key === ' ') {
            e.preventDefault();
            if (isOpen() && item.classList.contains('is-active') && panelTxt.textContent === detail) {
              closePanel();
              clearActive();
            } else {
              openPanel(detail);
              markActive(item);
            }
          }
        });
      });

      // Cerrar con botón
      btnClose && btnClose.addEventListener('click', () => {
        closePanel();
        clearActive();
      });

      // Si el mouse sale de la CINTA (no del panel): cierra solo si no hay un ítem seleccionado
      ticker.addEventListener('mouseleave', () => {
        if (!wrapper.querySelector('.ticker__item.is-active')) {
          closePanel();
        }
      });
    });
  };

  // Soporta Turbo y DOM clásico
  document.addEventListener('turbo:load', ready);
  document.addEventListener('DOMContentLoaded', ready);
})();
