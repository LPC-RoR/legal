class MontoConciliacion < ApplicationRecord

	TIPOS = ['Autorizado', 'Ofrecido', 'Propuesta', 'Contrapropuesta', 'Acuerdo', 'Sentencia']

	belongs_to :causa

	scope :ordr_fecha, -> { order(:created_at) }

	after_commit :actualizar_monto_pagado_causa, on: [:create, :update, :destroy]

	private

  def actualizar_monto_pagado_causa
    return unless causa.present?
    
    # Buscar el monto conciliación con fecha más reciente para esta causa
    ultimo_monto = causa.monto_conciliaciones.order(fecha: :desc).first
    
    # Si existe un registro y cumple la condición, actualizar
    if ultimo_monto.present? && ['Acuerdo', 'Sentencia'].include?(ultimo_monto.tipo)
      causa.update_column(:monto_pagado, ultimo_monto.monto)
    else
      # Si no hay registros o ninguno cumple la condición, establecer en nil
      causa.update_column(:monto_pagado, nil)
    end
  end

end
