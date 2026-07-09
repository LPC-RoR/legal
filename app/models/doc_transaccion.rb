class DocTransaccion < ApplicationRecord

  TNSCCN_CTA = {
    'DocBoleta'   => 'Honorarios',
    'DocEmiido'   => 'Cliente',
    'DocRecibido' => 'Proveedor',
    'Trabajador'  => 'Trabajador'
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

  def clasifica_columna
    if relacionable
      clasificacion.present? ? clasificacion : relacionable.class.name
    else
      clasificacion.present? ? clasificacion : 'Pendiente'
    end
  end

  # *****************************************************  Exportación a Excel
  def self.exportar_a_excel(fecha_inicio, fecha_termino)
    # Precarga las asociaciones para evitar N+1 y asegurar que los datos estén disponibles
    transacciones = entre_fechas(fecha_inicio, fecha_termino)
      .includes(:doc_notas, doc_pagos: :ownr)

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: 'Transacciones') do |sheet|
      # Encabezados
      sheet.add_row ['Fecha', 'Descripción', 'Clasificación', 'Detalle', 'Monto', 'Tipo Monto', 'Nota']
      
      # Datos
      transacciones.find_each do |transaccion|
        sheet.add_row [
          transaccion.fecha&.strftime('%d/%m/%Y'),
          transaccion.descripcion,
          transaccion.clasifica_columna,
          transaccion.dtll_cnclcn,
          transaccion.monto,
          transaccion.tipo_movimiento,
          transaccion.nota_cnclcn || ''  # Asegura string vacío en lugar de nil
        ]
      end

      sheet.column_widths 15, 40, 20, 30, 15, 15, 30
    end

    package
  end

  def nota_cnclcn
    # Usa el association cache si está precargado, o carga la primera nota
    nota = doc_notas.loaded? ? doc_notas.first : doc_notas&.first
    nota&.nota
  end

  def dtll_cnclcn
    # Usa el association cache si está precargado
    pagos = doc_pagos.loaded? ? doc_pagos.to_a : doc_pagos.to_a
    
    cnclcn_ownr = pagos.map { |pg| pg&.ownr&.class&.name }.compact.first

    return 'Sin documentos asociados' unless cnclcn_ownr

    cnclcn_rut = case cnclcn_ownr
                 when 'DocBoleta'    then pagos.map { |pg| pg&.ownr&.emisor_rut }.compact.first
                 when 'DocRecibido'  then pagos.map { |pg| pg&.ownr&.rut_emisor }.compact.first
                 when 'DocEmitido'   then pagos.map { |pg| pg&.ownr&.rut_receptor }.compact.first
                 end

    cnclcn_docs = case cnclcn_ownr
                  when 'DocBoleta'   then pagos.map { |pg| pg&.ownr&.numero }.compact.join('-')
                  when 'DocRecibido', 'DocEmitido'
                    then pagos.map { |pg| pg&.ownr&.folio }.compact.join('-')
                  end

    tipo_doc = cnclcn_ownr == 'DocBoleta' ? 'Boleta(s)' : (['DocEmiido', 'DocRecibido'].include?(cnclcn_ownr) ? 'Factura(s)' : nil )

    "#{TNSCCN_CTA[cnclcn_ownr] || 'Remuneraciones'} #{cnclcn_rut}: #{tipo_doc} #{cnclcn_docs}"
  end  
  # *****************************************************  Exportación a Excel (final)

  def vincular!
    return if descripcion_rut.blank?
    return if vinculada?

    cliente = Cliente.find_by(rut: descripcion_rut)
    if cliente
      update!(relacionable: cliente)
      return
    end

    proveedor = Proveedor.find_by(rut: descripcion_rut)
    if proveedor
      update!(relacionable: proveedor)
      return
    end

    colaborador = Trabajador.find_by(rut: descripcion_rut)
    if colaborador
      update!(relacionable: colaborador)
      return
    end
  end

  def vinculada?
    relacionable.present?
  end
end