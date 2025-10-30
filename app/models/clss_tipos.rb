class ClssTipos

	# tar_detalle_cuantias
	def self.cuantias
		{
			'moral' 		=> 'Daño moral',
			'sgr_csntia' 	=> 'Descuento seguro de cesantía',
			'frd_legal'		=> 'Feriado legal',
			'frd_prprcnl'	=> 'Feriado proporcional',
			'hrs_extrdnrs'	=> 'Horas extraordinarias',
			'avs_previo'	=> 'Indemnización del aviso previo',
			'artcl_489'		=> 'Indemnización especial artículo 489',
			'ans_srvc'		=> 'Indemnización por años de servicio',
			'lcr_csnt'		=> 'Lucro cesante',
			'nldd_dspd_1'	=> 'Nulidad del despido ( convalidación )',
			'nldd_dspd_2'	=> 'Nulidad del despido ( preparatoria )',
			'artcl_168'		=> 'Recargo legal art. 168 CT',
			'rmnrcn'		=> 'Remuneración',
			'otro'			=> 'Otro'
		}.freeze
	end

	def self.tipos_causa
		{
			'letras'		=> 'Juzgado de letras',
			'cobranza'		=> 'Juzgado de Cobranza',
			'apelaciones'	=> 'Corte de apelaciones',
			'suprema'		=> 'Corte suprema'
		}.freeze
	end

	def self.audiencias
		{
			letras: [
				['Audiencia preparatoria', false],
				['Audiencia de juicio', true],
				['Audiencia única', false]
			]
		}		
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
			]
		}
	end

	def self.act_nombre
		{
			'demanda' 		=> 'Demanda',
			'contestación'	=> 'Contestación',
			'sentencia'		=> 'Sentencia'
		}
	end

	def self.act_lst?(code)
		false
	end

	def self.act_fecha(code)
		true
	end

end