require 'roo'

class CartolaLoader
  DESCRIPCION_RUT_PATTERN = /\A(\d+[Kk]?)\s+(.*)\z/
  HTML_TAG_PATTERN = /<[^>]+>/

  def initialize(doc_cartola)
    @doc_cartola = doc_cartola
    @errores = []
  end

  attr_reader :errores

  def cargar!
    return false unless @doc_cartola.archivo.attached?

    @errores = []
    archivo_temp = descargar_archivo_temporal

    begin
      spreadsheet = Roo::Spreadsheet.open(archivo_temp.path)
      sheet = spreadsheet.sheet(0)

      # Buscar dinámicamente las filas clave
      filas = encontrar_filas_clave(sheet)

      Rails.logger.info "[CartolaLoader] Filas encontradas: #{filas.inspect}"

      # Extraer todos los datos del Excel
      datos_banco   = extraer_datos_banco(sheet, filas[:rut_empresa])
      datos_cuenta  = extraer_datos_cuenta(sheet, filas)
      datos_saldos  = extraer_datos_saldos(sheet, filas[:saldos])
      datos_credito = extraer_datos_credito(sheet, filas[:credito])

      Rails.logger.info "[CartolaLoader] datos_cuenta: #{datos_cuenta.inspect}"
      Rails.logger.info "[CartolaLoader] datos_saldos: #{datos_saldos.inspect}"
      Rails.logger.info "[CartolaLoader] datos_credito: #{datos_credito.inspect}"

      # Crear o encontrar banco y cuenta
      banco  = buscar_o_crear_banco(datos_banco)
      cuenta = buscar_o_crear_cuenta(banco, datos_cuenta)

      # Guardar la cartola con todos sus datos
      @doc_cartola.assign_attributes(
        doc_cuenta: cuenta,
        numero_cartola: datos_cuenta[:numero_cartola],
        fecha_desde: datos_cuenta[:fecha_desde],
        fecha_hasta: datos_cuenta[:fecha_hasta],
        **datos_saldos,
        **datos_credito
      )
      
      @doc_cartola.save(validate: false)

      Rails.logger.info "[CartolaLoader] Cartola guardada: id=#{@doc_cartola.id}, numero_cartola=#{@doc_cartola.numero_cartola}, saldo_final=#{@doc_cartola.saldo_final}"

      # Crear transacciones (con deduplicación inteligente)
      transacciones = crear_transacciones(sheet, cuenta, filas[:movimientos])
      vincular_transacciones(transacciones)

      Rails.logger.info "[CartolaLoader] Transacciones creadas: #{transacciones.count}, omitidas por duplicado: #{@transacciones_omitidas || 0}"

      true
    rescue => e
      @errores << "Error al procesar la cartola: #{e.message}"
      Rails.logger.error "[CartolaLoader] ERROR: #{e.message}"
      Rails.logger.error e.backtrace.first(15).join("\n")
      false
    ensure
      archivo_temp.close
      archivo_temp.unlink
    end
  end

  private

  def descargar_archivo_temporal
    extension = @doc_cartola.archivo.filename.to_s.split('.').last.downcase
    temp = Tempfile.new(['cartola', ".#{extension}"])
    temp.binmode
    temp.write(@doc_cartola.archivo.download)
    temp.rewind
    temp
  end

  # Busca filas clave por contenido en lugar de usar índices fijos
  def encontrar_filas_clave(sheet)
    filas = {
      empresa: nil,
      rut_empresa: nil,
      datos_cuenta: nil,
      numero_cartola: nil,
      saldos: nil,
      credito: nil,
      movimientos: nil
    }

    (1..[sheet.last_row, 30].min).each do |fila|
      valor_celda = limpiar_celda(sheet.cell(fila, 1))
      next if valor_celda.blank?

      case valor_celda
      when /Empresa:/i
        filas[:empresa] = fila
      when /RUT empresa:/i
        filas[:rut_empresa] = fila
      when /Cuenta Corriente/i, /Cuenta.*N°/i
        filas[:datos_cuenta] = fila
      when /Número cartola/i
        filas[:numero_cartola] = fila
      when /SALDO INICIAL/i
        filas[:saldos] = fila + 1
      when /CUPO APROBADO/i
        filas[:credito] = fila + 1
      when /Detalle movimientos/i
        # Buscar dinámicamente la primera fila con datos numéricos después del header
        filas[:movimientos] = encontrar_primera_fila_datos(sheet, fila)
      end
    end

    filas
  end

  def encontrar_primera_fila_datos(sheet, fila_inicio)
    # Buscar desde fila_inicio+1 hasta fila_inicio+5
    ((fila_inicio + 1)..[sheet.last_row, fila_inicio + 5].min).each do |f|
      valor = limpiar_celda(sheet.cell(f, 1))
      next if valor.blank?
      # Es una fila de datos si la columna A es un número (positivo, negativo, o con $)
      return f if valor.match?(/\A-?[\$\d]/)
    end
    fila_inicio + 2  # fallback conservador
  end

  def detectar_fila_datos(sheet, fila_detalle)
    # Buscar desde fila_detalle+1 hacia abajo la primera fila con un número en col A
    ((fila_detalle + 1)..[sheet.last_row, fila_detalle + 5].min).each do |f|
      valor = limpiar_celda(sheet.cell(f, 1))
      next if valor.blank?
      return f if valor.match?(/\A-?\d/)  # Empieza con dígito (positivo o negativo)
    end
    fila_detalle + 2  # fallback
  end

  def limpiar_celda(valor)
    return nil if valor.blank?
    texto = valor.to_s
    texto = texto.gsub(HTML_TAG_PATTERN, '')
    texto.strip.presence
  end

  def extraer_datos_banco(sheet, fila_rut)
    fila_rut ||= 4
    {
      rut_empresa: limpiar_celda(sheet.cell(fila_rut, 2)),
      nombre_empresa: limpiar_celda(sheet.cell(fila_rut - 1, 2))
    }
  end

  def extraer_datos_cuenta(sheet, filas)
    fila_cuenta = filas[:datos_cuenta] || 7
    fila_cartola = filas[:numero_cartola] || 8
    
    cuenta_raw = limpiar_celda(sheet.cell(fila_cuenta, 1))
    moneda_raw = limpiar_celda(sheet.cell(fila_cuenta, 3))
    sucursal_raw = limpiar_celda(sheet.cell(fila_cuenta, 4))
    
    numero_cartola_raw = limpiar_celda(sheet.cell(fila_cartola, 1))
    fecha_desde_raw = limpiar_celda(sheet.cell(fila_cartola, 3))
    fecha_hasta_raw = limpiar_celda(sheet.cell(fila_cartola, 4))

    Rails.logger.info "[CartolaLoader] numero_cartola_raw (limpio): #{numero_cartola_raw.inspect}"

    {
      numero_cuenta: extraer_numero_cuenta(cuenta_raw),
      moneda: extraer_valor_despues_dos_puntos(moneda_raw),
      sucursal: extraer_valor_despues_dos_puntos(sucursal_raw),
      numero_cartola: extraer_numero_cartola(numero_cartola_raw),
      fecha_desde: parsear_fecha(extraer_valor_despues_dos_puntos(fecha_desde_raw)),
      fecha_hasta: parsear_fecha(extraer_valor_despues_dos_puntos(fecha_hasta_raw))
    }
  end

  def extraer_numero_cartola(valor_raw)
    return nil if valor_raw.blank?

    valor_limpio = extraer_valor_despues_dos_puntos(valor_raw)
    
    if valor_limpio.blank?
      Rails.logger.warn "[CartolaLoader] No se pudo extraer número de cartola de: #{valor_raw.inspect}"
      return nil
    end

    numero = valor_limpio.to_i
    
    Rails.logger.info "[CartolaLoader] Número de cartola extraído: #{numero}"
    numero
  end

  def extraer_datos_saldos(sheet, fila_saldos)
    fila_saldos ||= 10
    
    Rails.logger.info "[CartolaLoader] Leyendo saldos de fila #{fila_saldos}"
    
    valores = {
      saldo_inicial: sheet.cell(fila_saldos, 1),
      depositos: sheet.cell(fila_saldos, 2),
      otros_abonos: sheet.cell(fila_saldos, 3),
      cheques: sheet.cell(fila_saldos, 4),
      otros_cargos: sheet.cell(fila_saldos, 5),
      impuestos: sheet.cell(fila_saldos, 6),
      saldo_final: sheet.cell(fila_saldos, 7)
    }
    
    Rails.logger.info "[CartolaLoader] Valores crudos saldos: #{valores.inspect}"
    
    {
      saldo_inicial: parsear_monto(valores[:saldo_inicial]),
      depositos: parsear_monto(valores[:depositos]),
      otros_abonos: parsear_monto(valores[:otros_abonos]),
      cheques: parsear_monto(valores[:cheques]),
      otros_cargos: parsear_monto(valores[:otros_cargos]),
      impuestos: parsear_monto(valores[:impuestos]),
      saldo_final: parsear_monto(valores[:saldo_final])
    }
  end

  def extraer_datos_credito(sheet, fila_credito)
    # Si no se encontró fila de crédito, retornar valores por defecto
    if fila_credito.nil?
      Rails.logger.info "[CartolaLoader] No hay sección de crédito en esta cartola"
      return {
        cupo_aprobado: 0,
        monto_utilizado: 0,
        saldo_disponible: 0
      }
    end

    Rails.logger.info "[CartolaLoader] Leyendo crédito de fila #{fila_credito}"

    valores = {
      cupo_aprobado: sheet.cell(fila_credito, 1),
      monto_utilizado: sheet.cell(fila_credito, 3),
      saldo_disponible: sheet.cell(fila_credito, 5)
    }

    Rails.logger.info "[CartolaLoader] Valores crudos crédito: #{valores.inspect}"

    {
      cupo_aprobado: parsear_monto(valores[:cupo_aprobado]),
      monto_utilizado: parsear_monto(valores[:monto_utilizado]),
      saldo_disponible: parsear_monto(valores[:saldo_disponible])
    }
  end

  def buscar_o_crear_banco(datos)
    rut = normalizar_rut(datos[:rut_empresa])
    
    DocBanco.find_or_create_by!(rut: rut) do |b|
      b.nombre = datos[:nombre_empresa]
    end
  end

  def buscar_o_crear_cuenta(banco, datos)
    banco.doc_cuentas.find_or_create_by!(numero_cuenta: datos[:numero_cuenta]) do |c|
      c.moneda = datos[:moneda]
      c.sucursal = datos[:sucursal]
    end
  end

  # ============================================================
  # NUEVO: Métodos de deduplicación con contador de ocurrencias
  # ============================================================

  # Construye la clave de deduplicación para una transacción
  def clave_deduplicacion(fecha, monto, descripcion)
    fecha_key = fecha.is_a?(Date) ? fecha.to_s : fecha.to_s.strip
    
    monto_key = begin
      decimal = monto.is_a?(BigDecimal) ? monto : BigDecimal(monto.to_s)
      decimal.to_s('F')
    rescue
      monto.to_s.strip
    end
    
    desc_key = descripcion.to_s.strip.downcase
    
    "#{fecha_key}|#{monto_key}|#{desc_key}"
  end
  
  # Cuenta las ocurrencias de cada clave en las transacciones existentes de la cuenta
  # dentro del rango de fechas de la cartola actual
  def contar_transacciones_existentes(cuenta, fecha_desde, fecha_hasta)
    return {} unless fecha_desde && fecha_hasta

    conteo = Hash.new(0)
    
    DocTransaccion
      .where(doc_cuenta: cuenta)
      .where(fecha: fecha_desde..fecha_hasta)
      .find_each do |trans|
        clave = clave_deduplicacion(trans.fecha, trans.monto, trans.descripcion)
        conteo[clave] += 1
      end

    Rails.logger.info "[CartolaLoader] Transacciones existentes en rango #{fecha_desde} a #{fecha_hasta}: #{conteo.size} claves únicas"
    conteo
  end

  def crear_transacciones(sheet, cuenta, fila_inicio)
    transacciones = []
    fila = fila_inicio || 17
    @transacciones_omitidas = 0

    Rails.logger.info "[CartolaLoader] Creando transacciones desde fila #{fila}"

    # Obtener conteo de transacciones existentes para deduplicación
    conteo_existentes = contar_transacciones_existentes(
      cuenta, 
      @doc_cartola.fecha_desde, 
      @doc_cartola.fecha_hasta
    )
    
    # Contador de ocurrencias procesadas en esta carga (para manejar duplicados en la misma cartola)
    conteo_nuevas = Hash.new(0)

    while fila <= sheet.last_row
      monto = sheet.cell(fila, 1)
      descripcion = limpiar_celda(sheet.cell(fila, 2))
      fecha = sheet.cell(fila, 4)
      numero_documento_raw = sheet.cell(fila, 5)
      sucursal = limpiar_celda(sheet.cell(fila, 6))
      tipo_movimiento = limpiar_celda(sheet.cell(fila, 8))

      break if monto.blank? && descripcion.blank?
      break if seccion_nueva?(descripcion)

      # Saltar filas que son headers de tabla (MONTO, DESCRIPCIÓN MOVIMIENTO, etc.)
      next if monto.to_s.strip.match?(/\A<.*>?(MONTO|SALDO|DEPOSITOS|CARGOS)\b/i) ||
              descripcion.to_s.strip.match?(/\A<.*>?DESCRIPCI[ÓO]N/i)

      next if monto.blank?

      # Defensa: saltar si el "monto" es texto de header
      monto_limpio = limpiar_celda(monto)
      next if monto_limpio&.match?(/\A(MONTO|SALDO|DEPOSITOS|CARGOS|ABONOS)\z/i)
      
      # Parsear valores
      monto_parsed = parsear_monto(monto)
      fecha_parsed = parsear_fecha(fecha)
      numero_documento = validar_numero_documento(numero_documento_raw)
      descripcion_rut = extraer_rut_descripcion(descripcion)

      # Construir clave de deduplicación
      clave = clave_deduplicacion(fecha_parsed, monto_parsed, descripcion)
      
      # Incrementar contador de esta nueva transacción
      conteo_nuevas[clave] += 1
      
      # DEDUPLICACIÓN: Solo crear si la ocurrencia actual excede las existentes
      # Ejemplo: Si ya hay 2 transacciones idénticas en BD y esta es la 3ra, se crea.
      # Si ya hay 2 y esta es la 1ra o 2da, se omite.
      if conteo_nuevas[clave] <= (conteo_existentes[clave] || 0)
        @transacciones_omitidas += 1
        Rails.logger.info "[CartolaLoader] Omitiendo transacción duplicada (ocurrencia #{conteo_nuevas[clave]} de #{conteo_existentes[clave]} existentes): #{clave}"
        fila += 1
        next
      end

      transaccion = DocTransaccion.create!(
        doc_cartola: @doc_cartola,
        doc_cuenta: cuenta,
        monto: monto_parsed,
        descripcion: descripcion,
        descripcion_rut: descripcion_rut,
        fecha: fecha_parsed,
        numero_documento: numero_documento,
        sucursal: sucursal,
        tipo_movimiento: tipo_movimiento
      )

      transacciones << transaccion
      fila += 1
    end

    transacciones
  end

  def vincular_transacciones(transacciones)
    transacciones.each do |transaccion|
      next if transaccion.descripcion_rut.blank?
      transaccion.vincular!
    end
  end

  def seccion_nueva?(descripcion)
    return false if descripcion.blank?
    palabras_clave = ['Resumen', 'Saldos diarios', 'Información de la Línea de Crédito']
    palabras_clave.any? { |palabra| descripcion.to_s.include?(palabra) }
  end

  def extraer_rut_descripcion(descripcion)
    return nil if descripcion.blank?
    
    match = DESCRIPCION_RUT_PATTERN.match(descripcion.to_s.strip)
    return nil unless match
    
    rut_raw = match[1]
    rut_limpio = rut_raw.sub(/\A0+/, '')
    rut_limpio = '0' if rut_limpio.empty?
    
    rut_limpio.upcase
  end

  def extraer_numero_cuenta(cuenta_raw)
    return nil if cuenta_raw.blank?
    match = cuenta_raw.match(/N°?:\s*(.+)/)
    match ? match[1].strip : cuenta_raw
  end

  def extraer_valor_despues_dos_puntos(texto)
    return nil if texto.blank?
    partes = texto.split(':', 2)
    partes.length > 1 ? partes[1].strip : texto.strip
  end

  def parsear_fecha(valor)
    return nil if valor.blank?
    return valor.to_date if valor.is_a?(Date) || valor.is_a?(Time)
    
    Date.strptime(valor.to_s.strip, '%d/%m/%Y')
  rescue
    Date.parse(valor.to_s.strip) rescue nil
  end

  def parsear_monto(valor)
    Rails.logger.info "[CartolaLoader] parsear_monto input: #{valor.inspect} (class: #{valor.class})"

    return 0 if valor.blank?
    return valor if valor.is_a?(Numeric)

    # FIX: Forzar encoding UTF-8 para evitar errores de concatenación en logs
    valor_str = valor.to_s.dup.force_encoding('UTF-8')

    # PRIMERO limpiar HTML si existe
    limpio = valor_str.gsub(HTML_TAG_PATTERN, '')
    # Luego quitar $ y espacios
    limpio = limpio.gsub(/[\$\s]/, '')
    # Reemplazar coma por punto (decimal)
    limpio = limpio.gsub(',', '.')

    Rails.logger.info "[CartolaLoader] parsear_monto limpio: #{limpio.inspect}"

    resultado = BigDecimal(limpio)

    Rails.logger.info "[CartolaLoader] parsear_monto output: #{resultado}"
    resultado
  rescue => e
    Rails.logger.error "[CartolaLoader] parsear_monto error: #{e.message} for value: #{valor.inspect}"
    0
  end

  def normalizar_rut(rut)
    return nil if rut.blank?
    rut.to_s.gsub(/[\.\-]/, '').upcase
  end

  def validar_numero_documento(valor)
    return nil if valor.blank?
    
    limpio = valor.to_s.strip
    # Solo permite dígitos (y opcionalmente letras K/k para casos especiales de RUT)
    # Para cartolas bancarias, N° DOCUMENTO debería ser solo números
    return nil unless limpio.match?(/\A\d+\z/)
    
    limpio
  end
end