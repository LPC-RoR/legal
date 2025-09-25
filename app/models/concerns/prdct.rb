# Aplicables a Cliente y Empresa
module Prdct
    extend ActiveSupport::Concern

    def demo?
        self.pro_dtll_ventas.empty?
    end

    def demo_vencido?
        self.pro_dtll_ventas.empty? and (not self.fecha_demo_activa?)
    end

    def producto_vencido?
        self.pro_dtll_ventas.any? and self.pro_dtll_ventas.activos.empty?
    end

    def cta_demo_completa?
        self.pro_dtll_ventas.empty? and self.fecha_demo_activa? and (self.krn_denuncias.count == 10)
    end

    def cta_producto_completa?
        self.pro_dtll_ventas.empty? and self.pro_dtll_ventas.activos.any? and (self.krn_denuncias.count == 10)
    end

    def demo_activo?
        self.producto_activo? ? false : (self.fecha_demo_activa? and (self.krn_denuncias.count < 10))
    end

    def producto_activo?
        activos = self.pro_dtll_ventas.activos
        activos.any? and activos.last.capacidad.present? and (self.krn_denuncias.count < activos.last.capacidad)
    end

    def krn_activo?
        self.demo_activo? or self.producto_activo?
    end

    def recepcion_habilitada?
      krn_investigadores.exists? &&
      ((not principal_usuaria) or (principal_usuaria && krn_empresa_externas.exists?)) &&
      app_contactos.exists?(grupo: 'RRHH') &&
      app_contactos.exists?(grupo: 'Apt')
      app_contactos.exists?(grupo: 'Backup')
    end

    # Registros mínimos
    def rgstrs_mnms?
        self.krn_investigadores.any? and (self.principal_usuaria ? self.empresas_externas? : true)
    end

    def denuncias_activas?
        self.krn_activo? and self.rgstrs_mnms?
    end
end