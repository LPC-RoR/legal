class ClssCntrldPltfrm < ApplicationRecord

	def self.cntxt_key(ownr)
		case ownr.class.name
		when 'Causa'
			ownr.code_causa.to_sym
		when 'Cliente'
			ownr.kywrd[:sym]
		end
	end

	def self.archivos
		{
			instancia: [
				['demanda', 'Demanda', false],
				['contestacion', 'Contestación', false]
			],
			letras: [
				['demanda', 'Demanda', false],
				['contestacion', 'Contestación', false]
			],
			cobranza: [
				['sentencia', 'Sentencia', false],
				['carta_despido', 'Carta despido', false],
				['demanda', 'Demanda', false]
			],
			clnt: [
				['contrato_firmado', 'Contrato firmado', false]
			]
		}
	end

	def self.nombre
		{
			'demanda' 			=> 'Demanda',
			'contestación'		=> 'Contestación',
			'sentencia'			=> 'Sentencia',
			'contrato_firmado'	=> 'Contrato firmado'
		}
	end

	def self.has_one?(code)
		['demanda'].include?(code)
	end

	def self.cntrl_fecha?(code)
		[].include?(code)
	end

	def self.cntrl_fecha_hora?(code)
		[].include?(code)
	end

end