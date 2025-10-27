# app/helpers/menu_helper.rb

# Menú en OffCanvas para ADDT
module AppMenuHelper
  # Devuelve nil si no hay menú disponible → el offcanvas no se pintará
  def menu_for_current_context
    # Prioridad: el primero que cumpla la policy
#    %w[admin accounting vendor].each do |key|
    %w[admin].each do |key|
      menu = Menu.enabled.find_by(key:)
      next unless menu
      return menu if policy(menu).show?
    end
    nil
  end

  def visible_menu_items(menu)
    menu.items.select do |it|
      policy([:menu_item]).visible?(it['id'])
    end
  end

  def h_menus
    {
      admin: {
        key:     'admin',
        enabled: true,
        items:   [
          { id: 'actividades',  name: 'Actividades',  path: '/age_actividades',   icon: 'bi bi-calendar4-event' },
          { id: 'clientes',     name: 'Clientes',     path: '/clientes',          icon: 'bi bi-building' },
          { id: 'causas',       name: 'Causas',       path: '/causas',            icon: 'bi bi-journal-text' },
          { id: 'asesorias',    name: 'Asesorías',    path: '/asesorias',         icon: 'bi bi-briefcase' },
          { id: 'cargos',       name: 'Cargos',       path: '/cargos',            icon: 'bi bi-currency-dollar' },
          { id: 'aprobaciones', name: 'Aprobaciones', path: '/tar_aprobaciones',  icon: 'bi bi-check-all' },
          { id: 'facturas',     name: 'Facturas',     path: '/tar_facturas',      icon: 'bi bi-receipt' },
          { id: 'laborsafe',              name: 'Laborsafe',                icon: 'bi bi-caret-right-fill',
            children: [
              { id: 'empresas',           name: 'Empresas',                 path: '/empresas',              icon: 'bi bi-buildings' },
              { id: 'contactos',          name: 'Contactos comerciales',    path: '/com_requerimientos',    icon: 'bi bi-person-raised-hand' },
              { id: 'com_documentos',     name: 'Documentos comerciales',   path: '/com_documentos',        icon: 'bi bi-file-earmark-pdf' },
            ]
          },
          { id: 'tablas',                 name: 'Tablas',                   icon: 'bi bi-caret-right-fill',
            children: [
              { id: 'tribunales_cortes',  name: 'Tribunales / Cortes',      path: '/tablas/tribunal_corte',       icon: nil },
              { id: 'etapas_tipos',       name: 'Etapas & Tipos',           path: '/tablas/tipos',                icon: nil },
              { id: 'cuantias',           name: 'Cuantías',                 path: '/tablas/cuantias_tribunales',  icon: nil },
              { id: 'tarifas_generales',  name: 'Tarifas generales',        path: '/tablas/tarifas_generales',    icon: nil },
              { id: 'uf_regiones',        name: 'UF & Regiones',            path: '/tablas/uf_regiones',          icon: nil },
              { id: 'enlaces',            name: 'Enlaces',                  path: '/rcrs_enlaces',                icon: nil },
              { id: 'feriados',           name: 'Feriados',                 path: '/tablas/agenda',               icon: nil },
            ]
          },
          { id: 'administracion',         name: 'Administración',           icon: 'bi bi-caret-right-fill',
            children: [
              { id: 'nomina',             name: 'Nómina',                   path: '/app_nominas',           icon: 'bi bi-person-workspace' },
              { id: 'personalizacion',    name: 'Personalización',          path: '/st_modelos',            icon: 'bi bi-question' },
            ]
          },
          { id: 'dog',                    name: 'Dog',                      icon: 'bi bi-caret-right-fill',
            children: [
              { id: 'versiones',          name: 'Versiones',                path: '/app_versiones',         icon: 'bi bi-gear' },
              { id: 'slides',             name: 'Slides',                   path: '/slides',                icon: 'bi bi-file-slides' },
              { id: 'global_usuarios',    name: 'Usuarios plataforma',      path: '/global_usuarios',       icon: 'bi bi-people' },
            ]
          },
        ]
      }
    }.freeze
  end

end