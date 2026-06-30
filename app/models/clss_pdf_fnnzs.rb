# app/models/clss_pdf_fnnzs.rb
class ClssPdfFnnzs
  class << self

    # ============================================
    # REPORTE: APROBACIÓN DE FACTURACIONES
    # ============================================
    # @param objeto_id [Integer] ID de CliAprobacion
    # @param opciones [Hash] Opciones adicionales (puede ser vacío {})
    # @param ownr [Cliente, nil] Propietario polimórfico del ActArchivo
    def datos_aprobacion(objeto_id, opciones = {}, ownr: nil)
      aprobacion = CliAprobacion.find(objeto_id)
      facturaciones = aprobacion.tar_facturaciones.order(:created_at)
      total = facturaciones.sum(:monto)
      
      {
        aprobacion: aprobacion,
        objeto: aprobacion,
        ownr: ownr || aprobacion.cliente,
        cliente: aprobacion.cliente,
        facturaciones: facturaciones,
        total: total,
        fecha_aprobacion: aprobacion.fecha,
        cantidad_facturaciones: facturaciones.count,
        numero_documento: aprobacion.try(:id),
#        estado: aprobacion.try(:estado),
#        observaciones: aprobacion.try(:observaciones)
        nombre_act_archivo: "#{aprobacion.fecha} : aprobacion #{aprobacion.id}"  # ← Personalizado
      }
    end



    # ownr puede ser un Contribuyente, Empresa, o nil
    def datos_doc_honorario(objeto_id, opciones = {}, ownr: nil)
      # Si ownr es nil, se deriva del objeto_id o se requiere
      contribuyente = ownr || Contribuyente.find_by(id: objeto_id)
      
      raise "Contribuyente no encontrado" unless contribuyente

      mes = opciones[:mes]
      anio = opciones[:anio]
      
      raise "Mes y año son requeridos" unless mes && anio

      honorarios = Honorario.where(contribuyente: contribuyente, mes: mes, anio: anio)
      
      {
        contribuyente: contribuyente,
        ownr: ownr,  # ← Devolver para que el servicio lo use
        mes: mes,
        anio: anio,
        honorarios: honorarios,
        total: honorarios.sum(:monto)
      }
    end

    def datos_balance_general(objeto_id, opciones = {}, ownr: nil)
      empresa = ownr || Empresa.find(objeto_id)
      periodo = opciones[:periodo]
      
      {
        empresa: empresa,
        ownr: ownr,
        activos: empresa.cuentas.activos.where(periodo: periodo),
        pasivos: empresa.cuentas.pasivos.where(periodo: periodo),
        patrimonio: empresa.cuentas.patrimonio.where(periodo: periodo)
      }
    end

    def assets_para(reporte)
      {
        logo: 'fnnzs/logo.png',
        css:  'pdfs/fnnzs/styles.css'
      }
    end

    # ************************************************************* Métodos propios

    def pagos_con_detalle(array)
      (['monto_fijo', 'monto_variable'] & array).any?
    end

    def pago_con_detalle(codigo_formula)
      ['monto_fijo', 'monto_variable'].include?(codigo_formula)
    end

  end
end