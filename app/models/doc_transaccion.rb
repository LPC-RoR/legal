class DocTransaccion < ApplicationRecord

  TNSCCN_CTA = {
    'DocBoleta'   => 'Honorarios',
    'DocEmiido'   => 'Cliente',
    'DocRecibido' => 'Proveedor'
  }.freeze

  belongs_to :doc_cartola
  belongs_to :doc_cuenta
  belongs_to :relacionable, polymorphic: true, optional: true

  has_many :doc_pagos
  has_many :doc_notas, as: :ownr

  scope :entre_fechas, ->(fecha_inicial, fecha_termino) {
    where(fecha: fecha_inicial..fecha_termino)
      .order(fecha: :asc, id: :asc)
  }

  validates :monto, presence: true
  validates :descripcion, presence: true

  # Método para determinar el tipo de monto (positivo/negativo)
  def clasifica_columna
    if relacionable
      if clasificacion.present?
        clasificacion
      else
        relacionable.class.name
      end
    else
      if clasificacion.present?
        clasificacion
      else
        'Pendiente'
      end
    end
  end

  # *****************************************************  Exportación a Excel
  def self.exportar_a_excel(fecha_inicio, fecha_termino)
    transacciones = entre_fechas(fecha_inicio, fecha_termino)

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: 'Transacciones') do |sheet|
      # Encabezados
      sheet.add_row ['Fecha', 'Descripción', 'Clasificación', 'Monto', 'Tipo Monto']
      
      # Datos
      transacciones.find_each do |transaccion|
        sheet.add_row [
          transaccion.fecha&.strftime('%d/%m/%Y'),
          transaccion.descripcion,
          transaccion.clasifica_columna,
          transaccion.dtll_cnclcn,
          transaccion.monto,
          transaccion.tipo_movimiento,
          transaccion.nota_cnclcn
        ]
#        transaccion.doc_pagos.each do |pg|
#          sheet.add_row [
#            'Análisis',
#            pg.titular_ownr,
#            "#{pg.documento_ownr} - #{pg.folio_referencia}",
#            pg.monto
#          ]
#        end
#        transaccion.doc_notas.each do |nt|
#          sheet.add_row [
#            'Nota',
#            nt.nota
#          ]
#        end
#      end

      # Estilos opcionales
      sheet.column_widths 15, 40, 20, 30, 15, 15, 30
    end

    package
  end

  def nota_cnclcn
    doc_notas&.first&.nota
  end

  def dtll_cnclcn
    cnclcn_ownr = doc_pagos.map {|pg| pg&.ownr.class.name}.compact.first

    cnclcn_rut  = doc_pagos.map {|pg| pg&.ownr&.emisor_rut}.compact.first if cnclcn_ownr == 'DocBoleta'
    cnclcn_rut  = doc_pagos.map {|pg| pg&.ownr&.rut_emisor}.compact.first if cnclcn_ownr == 'DocRecibido'
    cnclcn_rut  = doc_pagos.map {|pg| pg&.ownr&.rut_receptor}.compact.first if cnclcn_ownr == 'DocEmitido'

    cnclcn_docs = doc_pagos.map {|pg| pg&.ownr&.numero}.join('-') if cnclcn_ownr == 'DocBoleta'
    cnclcn_docs = doc_pagos.map {|pg| pg&.ownr&.folio}.join('-') if ['DocEmitido', 'DocRecibido'].include?(cnclcn_ownr)
    case cnclcn_ownr
    when 'DocBoleta'
      "#{TNSCCN_CTA[cnclcn_ownr]} #{s_rut(cnclcn_rut)}: #{cnclcn_ownr == 'DocBoleta' ? 'Boleta(s)' : 'Factura(s)'} #{cnclcn_docs}"
    end
  end
  # *****************************************************  Exportación a Excel (final)

  # Busca y vincula la transacción con Cliente, Proveedor o Trabajador
  def vincular!
    return if descripcion_rut.blank?
    return if vinculada?

    # 1. Buscar en Cliente
    cliente = Cliente.find_by(rut: descripcion_rut)
    if cliente
      update!(relacionable: cliente)
      return
    end

    # 2. Buscar en Proveedor
    proveedor = Proveedor.find_by(rut: descripcion_rut)
    if proveedor
      update!(relacionable: proveedor)
      return
    end

    # 3. Buscar en Colaborador
    colaborador = Trabajador.find_by(rut: descripcion_rut)
    if colaborador
      update!(relacionable: colaborador)
      return
    end
  end

  # Verifica si está vinculada
  def vinculada?
    relacionable.present?
  end
end