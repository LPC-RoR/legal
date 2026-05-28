class DocTransaccion < ApplicationRecord
  belongs_to :doc_cartola
  belongs_to :doc_cuenta
  belongs_to :relacionable, polymorphic: true, optional: true

  validates :monto, presence: true
  validates :descripcion, presence: true

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