class TarValorCuantia < ApplicationRecord

	belongs_to :tar_detalle_cuantia
	belongs_to :demandante, optional: true
	belongs_to :ownr, polymorphic: true

	scope :dsply, -> {order(:demandante_id, :tar_detalle_cuantia_id)}

    validates_presence_of :moneda

    # Cambié self.owner_class por Causa porque generaba un comportamiento anómalo

	def detalle
		self.tar_detalle_cuantia.tar_detalle_cuantia == 'Otro' ? self.otro_detalle : self.tar_detalle_cuantia.tar_detalle_cuantia
	end

	def activado?
		self.desactivado.blank? ? true : false
	end

	# ------------------------------------------------- Métodos para el cálculo de tarifas

	def formula
		self.tar_detalle_cuantia.formula_cuantia
	end

	# Busca fórmula de honorarios
	def formula_honorarios
		causa = self.ownr_type == 'Causa' ? self.ownr : nil
		detalle_cuantia = self.tar_detalle_cuantia
		unless causa.blank? or causa.tar_tarifa.blank? or causa.tar_tarifa.cuantia_tarifa == false
			tarifa = causa.tar_tarifa
			tar_formula = tarifa.tar_formula_cuantias.find_by(tar_detalle_cuantia_id: detalle_cuantia.id)
			tar_formula.blank? ? nil : tar_formula.tar_formula_cuantia
		else
			nil
		end
	end

	# Obtiene el porcentaje que se debe aplicar a la cuantía para determinar su aporte a la tarifa variable
	def porcentaje_variable
		tarifa = self.ownr.class.name == 'Causa' ? self.ownr.tar_tarifa : nil
		unless tarifa.blank?
			tipo_causa = self.ownr.tipo_causa
			porcentaje_base = tarifa.tar_tipo_variables.find_by(tipo_causa_id: tipo_causa.id)
			base = porcentaje_base.blank? ? nil : porcentaje_base.variable_tipo_causa
			excepcion_base = tarifa.tar_formula_cuantias.find_by(tar_detalle_cuantia_id: self.tar_detalle_cuantia.id) 
			excepcion = excepcion_base.blank? ? nil : excepcion_base.porcentaje_base
			excepcion.blank? ? base : excepcion
		else
			nil
		end
	end

end
