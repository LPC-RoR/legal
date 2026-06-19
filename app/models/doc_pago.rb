class DocPago < ApplicationRecord
	belongs_to :doc_transaccion
	belongs_to :ownr, polymorphic: true, optional: true

  before_create :asignar_ownr

  def documento_ownr
    ownr.class.name == 'DocBoleta' ? 'Boleta' : 'Factura'
  end

  def titular_ownr
    case ownr.class.name
    when 'DocBoleta'
      ownr.ownr.class.name == 'Proveedor' ? ownr.ownr.razon_social : ownr.ownr.nombre
    when 'DocEmitido'
      ownr.cliente.razon_social
    when 'DocRecibido'
      ownr.proveedor.razon_social
    end
  end

  private

  def asignar_ownr
    # Verificar que exista el relacionable
    unless doc_transaccion.relacionable.present?
      errors.add(:base, "No se pudo crear el registro porque no se encontró su ownr")
      throw(:abort)
    end

    relacionable = doc_transaccion.relacionable

    # Buscar según el tipo de relacionable
    registro_encontrado = case relacionable
                          when Trabajador
                            relacionable.doc_boletas.find_by(numero: folio_referencia)
                          when Cliente
                            relacionable.doc_emitidos.find_by(folio: folio_referencia)
                          when Proveedor
                            relacionable.doc_recibidos.find_by(folio: folio_referencia) || relacionable.doc_boletas.find_by(numero: folio_referencia)
                          else
                            DocEmitido.find_by(folio: folio_referencia)
                          end

    if registro_encontrado && registro_encontrado.class.name == 'DocEmitido'
      cliente = registro_encontrado.cliente
      doc_transaccion.relacionable = cliente
      doc_transaccion.save
    end

    if registro_encontrado
      self.ownr = registro_encontrado
    else
      errors.add(:base, "No se pudo crear el registro porque no se encontró su ownr")
      throw(:abort)
    end
  end

end
