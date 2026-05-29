class DocPago < ApplicationRecord
	belongs_to :doc_transaccion
	belongs_to :ownr, polymorphic: true, optional: true

  before_create :asignar_ownr

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
                          when Cliente
                            relacionable.doc_emitidos.find_by(folio: folio_referencia)
                          when Proveedor
                            relacionable.doc_recibidos.find_by(folio: folio_referencia)
                          else
                            nil
                          end

    if registro_encontrado
      self.ownr = registro_encontrado
    else
      errors.add(:base, "No se pudo crear el registro porque no se encontró su ownr")
      throw(:abort)
    end
  end

end
