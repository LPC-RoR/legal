class TarValorCuantia < ApplicationRecord

	belongs_to :tar_detalle_cuantia
	belongs_to :demandante

    validates_presence_of :moneda

    # Cambié self.owner_class por Causa porque generaba un comportamiento anómalo
 	def owner
#		self.owner_class.constantize.find(self.owner_id)
		Causa.find(self.owner_id)
	end

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
		causa = self.owner_class == 'Causa' ? self.owner : nil
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
		tarifa = self.owner.class.name == 'Causa' ? self.owner.tar_tarifa : nil
		unless tarifa.blank?
			tipo_causa = self.owner.tipo_causa
			variable_base = tarifa.tar_variable_bases.find_by(tipo_causa_id: tipo_causa.id)
			base = variable_base.blank? ? nil : variable_base.tar_base_variable
			excepcion_base = tarifa.tar_formula_cuantias.find_by(tar_detalle_cuantia_id: self.tar_detalle_cuantia.id) 
			excepcion = excepcion_base.blank? ? nil : excepcion_base.porcentaje_base
			excepcion.blank? ? base : excepcion
		else
			nil
		end
	end

end
