// app/javascript/ticker.js
(() => {
  const ready = () => {
    document.querySelectorAll('.ticker-wrapper').forEach((wrapper) => {
      const ticker   = wrapper.querySelector('.ticker');
      const track    = wrapper.querySelector('.ticker__track');
      const panel    = wrapper.querySelector('[data-role="panel"]');
      const panelTxt = wrapper.querySelector('[data-role="panel-text"]');
      const btnClose = wrapper.querySelector('[data-role="panel-close"]');
      
      if (!ticker || !track) return;

      // ── DUPLICAR ITEMS PARA LOOP INFINITO ──
      const originalItems = track.innerHTML;
      track.innerHTML = originalItems + originalItems;

      // Velocidad desde data-speed
      const speedAttr = ticker.getAttribute('data-speed');
      if (speedAttr) track.style.setProperty('--ticker-speed', `${Number(speedAttr)}s`);

      // ── PANEL OPCIONAL ──
      const hasPanel = !!(panel && panelTxt);
      let collapse = null;

      if (hasPanel) {
        const BsCollapse = window.bootstrap && window.bootstrap.Collapse ? window.bootstrap.Collapse : null;
        if (BsCollapse) {
          try {
            collapse = new BsCollapse(panel, { toggle: false });
          } catch (e) {
            console.warn('[ticker] Error inicializando Bootstrap Collapse:', e);
          }
        }
      }

      const isOpen = () => hasPanel && panel.classList.contains('show');

      const openPanel = (text) => {
        if (!hasPanel) return;
        panelTxt.textContent = text || '';
        if (collapse) collapse.show();
        else panel.classList.add('show');
      };

      const closePanel = () => {
        if (!hasPanel) return;
        if (collapse) collapse.hide();
        else panel.classList.remove('show');
        panelTxt.textContent = '';
      };

      const items = Array.from(wrapper.querySelectorAll('.ticker__item'));

      // ... resto del código igual
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
        if (item.dataset.tickerBound) return;
        item.dataset.tickerBound = '1';

        const detail = item.getAttribute('data-detail') || '';

        // ── Solo bindear eventos de panel si existe ──
        if (hasPanel) {
          item.addEventListener('mouseenter', () => openPanel(detail));
          item.addEventListener('focusin',   () => openPanel(detail));

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
        }
      });

      // Cerrar con botón
      if (hasPanel && btnClose) {
        btnClose.addEventListener('click', () => {
          closePanel();
          clearActive();
        });
      }

      // Si el mouse sale de la CINTA: cierra solo si no hay ítem seleccionado
      if (hasPanel) {
        ticker.addEventListener('mouseleave', () => {
          if (!wrapper.querySelector('.ticker__item.is-active')) {
            closePanel();
          }
        });
      }
    });
  };

  document.addEventListener('turbo:load', ready);
  document.addEventListener('DOMContentLoaded', ready);
})();