module Cmenu

	def scp_menu 
		{
			causas: [
				{
					scp: 'trmtcn',
					cndcn: operacion?
				},
				{
					scp: 'sn_fctrcn',
					cndcn: operacion?
				},
				{
					scp: 'trmnds',
					cndcn: operacion?
				},
				{
					scp: 'crrds',
					cndcn: operacion?
				},
				{
					scp: 'en_rvsn',
					cndcn: admin?
				}
			],
			clientes: [
				{
					scp: 'emprss',
					cndcn: operacion?
				},
				{
					scp: 'sndcts',
					cndcn: operacion?
				},
				{
					scp: 'trbjdrs',
					cndcn: operacion?
				},
				{
					scp: 'actvs',
					cndcn: operacion?
				},
				{
					scp: 'de_bj',
					cndcn: admin?
				},
			],
			asesorias: [
				{
					scp: 'trmtcn',
					cndcn: operacion?
				},
				{
					scp: 'trmnds',
					cndcn: operacion?
				},
				{
					scp: 'crrds',
					cndcn: finanzas?
				},
				{
					scp: 'mlts',
					cndcn: operacion?
				},
				{
					scp: 'crts_dspd',
					cndcn: operacion?
				},
				{
					scp: 'rdccns',
					cndcn: operacion?
				},
				{
					scp: 'cnslts',
					cndcn: operacion?
				},
			],
			cargos: [
				{
					scp: 'trmtcn',
					cndcn: operacion?
				},
				{
					scp: 'trmnds',
					cndcn: operacion?
				},
				{
					scp: 'crrds',
					cndcn: finanzas?
				},
				{
					scp: 'crgs',
					cndcn: operacion?
				},
				{
					scp: 'mnsls',
					cndcn: operacion?
				},
			],
			tar_facturas: [
				{
					scp: 'ingrss',
					cndcn: admin?
				},
				{
					scp: 'fctrds',
					cndcn: admin?
				},
				{
					scp: 'pgds',
					cndcn: admin?
				}
			]
		}
	end

	def scp_item 
		{
			causas: {
				trmtcn: 'en tramitación',
				sn_fctrcn: 'sin facturación',
				trmnds: 'terminadas',
				crrds: 'cerradas',
				en_rvsn: 'en revisión'
			},
			clientes: {
				emprss: 'Empresas',
				sndcts: 'Sindicatos',
				trbjdrs: 'Trabajadores',
				actvs: 'Activos',
				de_bj: 'Dados de Baja'
			},
			asesorias: {
				trmtcn: 'en tramitación',
				trmnds: 'terminadas',
				crrds: 'cerradas',
				mlts: 'Multas',
				crts_dspd: 'Cartas de despido',
				rdccns: 'Redacciones',
				cnslts: 'Consultas'
			},
			cargos: {
				trmtcn: 'en tramitación',
				trmnds: 'terminadas',
				crrds: 'cerradas',
				crgs: 'Cargos',
				mnsls: 'Mensuales'
			},
			tar_facturas: {
				ingrss: 'ingresadas',
				fctrds: 'facturadas',
				pgds: 'pagadas'
			}
		}
	end

	def cmenu_clss
		{
			'tar_tarifas' => {
				estados: nil,
				items: {
					'causas' => 'Tarifas de Causas',
					'asesorias' => 'Tarifas de asesorías'
				},
				selectors: [
					['causas', operacion?],
					['asesorias', operacion?]
				]
			},
			'denuncias' => {
				estados: [
					{
						std: 'recepción',
						cndcn: admin?
					},
					{
						std: 'diligencias',
						cndcn: admin?
					},
					{
						std: 'cierre',
						cndcn: admin?
					},
					{
						std: 'cerrada',
						cndcn: admin?
					}
				],
				items: {
					'recepción' => 'Recepcionadas',
					'diligencias' => 'Etapa de diligencias',
					'cierre' => 'Etapa de cierre',
					'cerrada' => 'Cerradas'
				},
				selectors: nil
			},
		}
	end

	def display_name(c, item)
		k_name = item.class.name == 'String' ? item : item[0]
		d_name = cmenu_clss[c][:items].blank? ? nil : cmenu_clss[c][:items][k_name]
		d_name.blank? ? k_name : d_name
	end

	def frst_std(cntrllr)
		stts = cmenu_clss[cntrllr][:estados]
		stts.blank? ? nil : stts.map {|st| st[:std] if st[:cndcn]}.compact.first
	end

	def frst_typ(cntrllr)
		slctrs = cmenu_clss[cntrllr][:selectors]
		slctrs.blank? ? nil : slctrs.map {|slctr| slctr[0] if slctr[1]}.compact.first
	end

	def std(cntrllr, prms_e, prms_t)
		(prms_e.blank? and prms_t.blank?) ? frst_std(cntrllr) : prms_e
	end

	def typ(cntrllr, prms_e, prms_t)
		(prms_t.blank? and std(cntrllr, prms_e, prms_t).blank?) ? frst_typ(cntrllr) : prms_t
	end

end