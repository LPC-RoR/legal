class MontoConciliacion < ApplicationRecord
  TIPOS = ['Autorizado', 'Ofrecido', 'Propuesta', 'Contrapropuesta', 'Acuerdo', 'Sentencia']

  belongs_to :causa

  scope :ordr_fecha, -> { order(:created_at) }

  after_commit :actualizar_monto_pagado_causa, on: [:create, :update, :destroy]

  private

  def actualizar_monto_pagado_causa
    return unless causa.present?

    # CORRECCIÓN CRÍTICA: Buscar SOLO entre 'Acuerdo' y 'Sentencia', 
    # ordenar por fecha DESC y id DESC (determinístico), y tomar el primero
    ultimo_monto = causa.monto_conciliaciones
                         .where(tipo: ['Acuerdo', 'Sentencia'])
                         .order(fecha: :desc, id: :desc)
                         .first

    # CORRECCIÓN: Manejar nil, 0, y valores positivos correctamente
    # El error original era que si monto era 0 (falsy en algunos contextos de JS/frontend
    # pero no en Ruby), pero el verdadero problema era que ultimo_monto podía no ser
    # el registro esperado debido al orden no determinístico
    nuevo_monto = ultimo_monto&.monto
    
    # update_columns salta callbacks y validaciones, pero respeta el valor 0
    causa.update_columns(monto_pagado: nuevo_monto)
  end
end