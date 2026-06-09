class DocHonorario < ApplicationRecord
  has_many :doc_boletas, dependent: :destroy
  has_one_attached :archivo

  validates :contribuyente_nombre, presence: true
  validates :contribuyente_rut, presence: true
  validates :mes, presence: true, inclusion: { in: 1..12 }
  validates :anio, presence: true
  validates :mes, uniqueness: {
    scope: [:contribuyente_rut, :anio],
    message: "ya existe un documento para este mes y año"
  }

  # Procesa boletas desde contenido HTML ya leído
  def procesar_contenido!(content)
    require 'nokogiri'

    doc = Nokogiri::HTML(content)

    boletas_data = []
    doc.css('tr').each do |row|
      cells = row.css('td')
      next if cells.length < 10
      next if cells[0].text.strip == 'N°'
      next if cells[0].text.strip.include?('Totales') || cells[0].text.strip.blank?

      boletas_data << {
        numero: cells[0].text.strip.to_i,
        fecha: parse_fecha(cells[1].text.strip),
        estado: cells[2].text.strip.upcase,
        fecha_anulacion: cells[3].text.strip.present? ? parse_fecha(cells[3].text.strip) : nil,
        emisor_rut: normalizar_rut(cells[4].text.strip),  # SIN GUION
        emisor_nombre: cells[5].text.strip,
        sociedad_profesional: cells[6].text.strip.upcase == 'SI',
        brutos: parse_monto(cells[7].text.strip),
        retenido: parse_monto(cells[8].text.strip),
        pagado: parse_monto(cells[9].text.strip)
      }
    end

    guardar_boletas(boletas_data)
  end

  # Reprocesa desde el archivo guardado en ActiveStorage
  def reprocesar!
    return false unless archivo.attached?

    content = archivo.download
    content = content.encode('UTF-8', 'ISO-8859-1', invalid: :replace, undef: :replace)

    procesar_contenido!(content)
  end

  private

  def guardar_boletas(boletas_data)
    DocBoleta.transaction do
      boletas_data.each do |data|
        # Normalizar rut al buscar (por si acaso)
        rut_normalizado = normalizar_rut(data[:emisor_rut])

        boleta = doc_boletas.find_or_initialize_by(
          numero: data[:numero],
          emisor_rut: rut_normalizado
        )

        if boleta.new_record? || boleta.vigente?
          boleta.assign_attributes(data.merge(emisor_rut: rut_normalizado))
          boleta.save!
        end
      end
    end

    recalcular_totales
  end

  def recalcular_totales
    vigentes = doc_boletas.where(estado: 'VIGENTE')
    update!(
      total_brutos: vigentes.sum(:brutos),
      total_retenido: vigentes.sum(:retenido),
      total_pagado: vigentes.sum(:pagado)
    )
  end

  def normalizar_rut(rut)
    rut.to_s.gsub('-', '').strip
  end

  def parse_fecha(valor)
    return nil if valor.blank?
    Date.parse(valor.to_s)
  rescue
    nil
  end

  def parse_monto(valor)
    return 0 if valor.blank?
    valor.to_s.gsub(/[.\s]/, '').to_i
  rescue
    0
  end
end