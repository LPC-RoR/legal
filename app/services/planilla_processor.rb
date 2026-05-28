require 'nokogiri'
require 'tempfile'

class PlanillaProcessor
  DOC_COLS = {
    tipo_dte: 0, folio: 1, fecha_emision: 2, tipo_despacho: 3,
    forma_pago: 4, rut_emisor: 5, razon_social_emisor: 6, giro_emisor: 7,
    acteco: 8, cod_sii_sucursal: 9, direccion_emisor: 10,
    comuna_emisor: 11, ciudad_emisor: 12, rut_receptor: 13,
    razon_social_receptor: 14, giro_receptor: 15,
    direccion_receptor: 16, comuna_receptor: 17, ciudad_receptor: 18,
    total_neto: 19, total_exento: 20, total_iva: 21,
    total_monto_total: 22, monto_periodo: 23,
    monto_no_facturable: 24, saldo_anterior: 25, valor_pagar: 26
  }.freeze

  attr_reader :errores, :documentos_procesados, :clientes_encontrados, :clientes_no_encontrados

  def initialize(planilla)
    @planilla = planilla
    @errores = []
    @documentos_procesados = 0
    @clientes_encontrados = 0
    @clientes_no_encontrados = 0
  end

  def procesar!
    @planilla.update!(estado: 'procesando')

    ActiveRecord::Base.transaction do
      archivo_temp = descargar_archivo_temporal

      begin
        filas = leer_archivo(archivo_temp)
        Rails.logger.info "[PlanillaProcessor] Archivo leído: #{filas.size} filas"

        documentos = parsear_documentos(filas)
        Rails.logger.info "[PlanillaProcessor] Documentos detectados: #{documentos.size}"

        @planilla.update!(total_documentos: documentos.size)

        documentos.each_with_index do |doc_data, idx|
          Rails.logger.info "[PlanillaProcessor] Procesando doc #{idx + 1}/#{documentos.size}: Folio #{doc_data[:folio]}"
          guardar_documento(doc_data)
        end

        estado_final = (@documentos_procesados == 0 && documentos.size > 0) ? 'error' : 'completado'

        @planilla.update!(
          estado: estado_final,
          documentos_cargados: @documentos_procesados,
          errores: @errores.join("\n"),
          procesado: Time.current
        )

        Rails.logger.info "[PlanillaProcessor] RESUMEN: #{@documentos_procesados} docs OK, #{@clientes_encontrados} clientes asociados, #{@clientes_no_encontrados} sin cliente"

      ensure
        File.delete(archivo_temp) if File.exist?(archivo_temp)
      end
    end

  rescue StandardError => e
    @errores << "FATAL: #{e.class}: #{e.message}"
    @planilla.update!(
      estado: 'error',
      errores: @errores.join("\n"),
      procesado: Time.current
    )
    Rails.logger.error "[PlanillaProcessor] ERROR FATAL: #{e.message}"
    raise
  end

  private

  def descargar_archivo_temporal
    ext = File.extname(@planilla.archivo.filename.to_s).downcase
    temp = Tempfile.new(['planilla', ext])
    temp.binmode
    temp.write(@planilla.archivo.download)
    temp.close
    temp.path
  end

  def leer_archivo(ruta)
    contenido = File.read(ruta)
    contenido.strip.start_with?('<') ? leer_html(contenido) : leer_excel(ruta)
  end

  def leer_html(contenido)
    doc = Nokogiri::HTML(contenido)
    tabla = doc.at('table')
    raise "No se encontró tabla HTML" unless tabla

    filas = []
    tabla.css('tr').each do |tr|
      fila = []
      tr.css('td, th').each { |celda| fila << convertir_valor(celda.inner_text.strip) }
      filas << fila unless fila.empty?
    end
    filas
  end

  def leer_excel(ruta)
    extension = File.extname(ruta).downcase
    case extension
    when '.xls'
      require 'roo-xls'
      hoja = Roo::Excel.new(ruta)
    when '.xlsx'
      hoja = Roo::Excelx.new(ruta)
    end
    (1..hoja.last_row).map { |i| hoja.row(i) }
  end

  def parsear_documentos(filas)
    documentos = []
    i = 0

    while i < filas.size
      fila = filas[i]
      if fila.nil? || fila.empty?
        i += 1
        next
      end

      if fila[0].to_s.strip == 'TipoDTE'
        if i + 1 < filas.size
          doc_data = extraer_documento(filas[i + 1])
          if doc_data
            # Saltar las filas de detalle hasta el siguiente documento
            j = i + 2
            while j < filas.size
              fila_j = filas[j]
              break if fila_j.nil? || fila_j.empty? || fila_j.all? { |c| c.nil? || c.to_s.strip.empty? }
              break if fila_j[0].to_s.strip == 'TipoDTE'
              j += 1
            end

            documentos << doc_data
            i = j
            next
          end
        end
      end
      i += 1
    end

    documentos
  end

  def extraer_documento(fila)
    c = DOC_COLS
    tipo_dte = fila[c[:tipo_dte]]
    return nil if tipo_dte.nil?

    {
      tipo_dte: tipo_dte.to_i,
      folio: valor_entero(fila[c[:folio]]),
      fecha_emision: parsear_fecha(fila[c[:fecha_emision]]),
      tipo_despacho: valor_entero(fila[c[:tipo_despacho]]),
      forma_pago: valor_entero(fila[c[:forma_pago]]),
      rut_emisor: limpiar_rut(fila[c[:rut_emisor]]),
      razon_social_emisor: valor_texto(fila[c[:razon_social_emisor]]),
      giro_emisor: valor_texto(fila[c[:giro_emisor]]),
      acteco: valor_texto(fila[c[:acteco]]),
      cod_sii_sucursal: valor_texto(fila[c[:cod_sii_sucursal]]),
      direccion_emisor: valor_texto(fila[c[:direccion_emisor]]),
      comuna_emisor: valor_texto(fila[c[:comuna_emisor]]),
      ciudad_emisor: valor_texto(fila[c[:ciudad_emisor]]),
      rut_receptor: limpiar_rut(fila[c[:rut_receptor]]),
      razon_social_receptor: valor_texto(fila[c[:razon_social_receptor]]),
      giro_receptor: valor_texto(fila[c[:giro_receptor]]),
      direccion_receptor: valor_texto(fila[c[:direccion_receptor]]),
      comuna_receptor: valor_texto(fila[c[:comuna_receptor]]),
      ciudad_receptor: valor_texto(fila[c[:ciudad_receptor]]),
      total_neto: valor_decimal(fila[c[:total_neto]]),
      total_exento: valor_decimal(fila[c[:total_exento]]),
      total_iva: valor_decimal(fila[c[:total_iva]]),
      total_monto_total: valor_decimal(fila[c[:total_monto_total]]),
      monto_periodo: valor_decimal(fila[c[:monto_periodo]]),
      monto_no_facturable: valor_decimal(fila[c[:monto_no_facturable]]),
      saldo_anterior: valor_decimal(fila[c[:saldo_anterior]]),
      valor_pagar: valor_decimal(fila[c[:valor_pagar]])
    }
  rescue StandardError => e
    @errores << "Error extrayendo documento: #{e.message}"
    nil
  end

  def guardar_documento(doc_data)
    if @planilla.tipo == 'recibidos'
      proveedor = buscar_proveedor(doc_data[:rut_receptor])
    else
      cliente = buscar_cliente(doc_data[:rut_receptor])
    end

    doc = modelo_documento.find_or_initialize_by(
      tipo_dte: doc_data[:tipo_dte],
      folio: doc_data[:folio],
      rut_emisor: doc_data[:rut_emisor]
    )

    doc.assign_attributes(
      doc_planilla: @planilla,
      fecha_emision: doc_data[:fecha_emision],
      tipo_despacho: doc_data[:tipo_despacho],
      forma_pago: doc_data[:forma_pago],
      razon_social_emisor: doc_data[:razon_social_emisor],
      giro_emisor: doc_data[:giro_emisor],
      acteco: doc_data[:acteco],
      cod_sii_sucursal: doc_data[:cod_sii_sucursal],
      direccion_emisor: doc_data[:direccion_emisor],
      comuna_emisor: doc_data[:comuna_emisor],
      ciudad_emisor: doc_data[:ciudad_emisor],
      rut_receptor: doc_data[:rut_receptor],
      razon_social_receptor: doc_data[:razon_social_receptor],
      giro_receptor: doc_data[:giro_receptor],
      direccion_receptor: doc_data[:direccion_receptor],
      comuna_receptor: doc_data[:comuna_receptor],
      ciudad_receptor: doc_data[:ciudad_receptor],
      total_neto: doc_data[:total_neto],
      total_exento: doc_data[:total_exento],
      total_iva: doc_data[:total_iva],
      total_monto_total: doc_data[:total_monto_total],
      monto_periodo: doc_data[:monto_periodo],
      monto_no_facturable: doc_data[:monto_no_facturable],
      saldo_anterior: doc_data[:saldo_anterior],
      valor_pagar: doc_data[:valor_pagar]
    )

      if @planilla.tipo == 'recibidos'
        doc.proveedor = proveedor
      else
        doc.cliente = cliente
      end

    doc.save!
    @documentos_procesados += 1

  rescue ActiveRecord::RecordInvalid => e
    @errores << "Folio #{doc_data[:folio]}: #{e.message}"
  rescue StandardError => e
    @errores << "Folio #{doc_data[:folio]}: #{e.message}"
  end

  def modelo_documento
    @planilla.tipo == 'recibidos' ? DocRecibido : DocEmitido
  end

  def buscar_cliente(rut_limpio)
    return nil if rut_limpio.blank?
    cliente = Cliente.find_by(rut: rut_limpio)
    cliente ? @clientes_encontrados += 1 : @clientes_no_encontrados += 1
    cliente
  end

  def buscar_proveedor(rut_limpio)
    return nil if rut_limpio.blank?
    proveedor = Proveedor.find_by(rut: rut_limpio)
    proveedor ? @clientes_encontrados += 1 : @clientes_no_encontrados += 1
    proveedor
  end

  def limpiar_rut(valor)
    return nil if valor.nil?
    valor.to_s.strip.gsub(/[.\-]/, '').upcase
  end

  def valor_texto(valor)
    return '' if valor.nil?
    valor.to_s.strip
  end

  def valor_entero(valor)
    return nil if valor.nil? || valor.to_s.strip.empty?
    valor.to_i
  end

  def valor_decimal(valor)
    return nil if valor.nil? || valor.to_s.strip.empty?
    BigDecimal(valor.to_s)
  end

  def parsear_fecha(valor)
    return nil if valor.nil? || valor.to_s.strip.empty?
    Date.parse(valor.to_s)
  end

  def convertir_valor(texto)
    return nil if texto.nil? || texto.strip.empty?
    texto = texto.strip
    return Date.parse(texto) if texto =~ /^\d{4}-\d{2}-\d{2}$/
    return texto.to_i if texto =~ /^\d+$/
    return BigDecimal(texto) if texto =~ /^\d+\.\d+$/
    texto
  end
end