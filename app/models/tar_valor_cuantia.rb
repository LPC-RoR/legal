class TarValorCuantia < ApplicationRecord
#	attr_readonly :valor_tarifa
	before_save :set_valor_tarifa

	belongs_to :tar_detalle_cuantia
	belongs_to :demandante, optional: true
	belongs_to :ownr, polymorphic: true

	scope :dsply, -> {order(:demandante_id, :tar_detalle_cuantia_id)}

    validates_presence_of :moneda, :valor

    # Cambié self.owner_class por Causa porque generaba un comportamiento anómalo

	def activado?
		self.desactivado.blank? ? true : false
	end

	# ------------------------------------------------- Métodos para el cálculo de tarifas

	def formula
		self.tar_detalle_cuantia.formula_cuantia
	end

	def remuneracion
		demandante&.remuneracion
	end

	# Busca fórmula de honorarios
	def formula_honorarios
		tarifa = ownr.class.name == 'Causa' ? ownr&.tar_tarifa : nil
		tarifa&.cuantia_tarifa ? tarifa&.tar_formula_cuantias.find_by(code_cuantia: code_cuantia)&.tar_formula_cuantia : nil
	end

	# Obtiene el porcentaje que se debe aplicar a la cuantía para determinar su aporte a la tarifa variable
	# code_causa es la de la causa
	# code_cuantía es la de self
	def porcentaje_variable
		tarifa = ownr.class.name == 'Causa' ? ownr&.tar_tarifa : nil
		tarifa.nil? ? nil : tarifa.porcentaje_variable(ownr.code_causa, code_cuantia)
	end

	def get_porcentaje_ahorro
		prcntj_code_cuantia = ownr&.tar_tarifa&.tar_formula_cuantias.find_by(code_cuantia: code_cuantia)&.porcentaje_base
		prcntj_code_causa   = ownr&.tar_tarifa&.tar_tipo_variables.find_by(code_causa: ownr.code_causa)&.variable_tipo_causa

		prcntj_code_cuantia.nil? ? ( prcntj_code_causa.nil? ? 0 : prcntj_code_causa ) : prcntj_code_cuantia
	end

	def calc_valor_tarifa
#		return nil if formula_honorarios.blank?

		v = valor
		r = remuneracion
		return nil if v.nil?

		if formula_honorarios and formula_honorarios != ''
			if remuneracion
				Keisan::Calculator.new.evaluate(
				  formula_honorarios,
				  "valor"        => v.to_f,
				  "remuneracion" => r.to_f
				)
			else
				nil
			end
		else
			valor
		end
	rescue Keisan::Exceptions::StandardError   # <= aquí
		nil
	end

	private

	def set_valor_tarifa
		self.valor_tarifa 	= calc_valor_tarifa
		self.porcentaje 	= get_porcentaje_ahorro
	end

end
