module Cmenu

	def scp_menu 
		{
			causas: [
				{scp: 'trmtcn',	cndcn: operacion?},
				{scp: 'sn_fctrcn', cndcn: operacion?},
				{scp: 'trmnds',	cndcn: operacion?},
				{scp: 'crrds', cndcn: operacion?},
				{scp: 'en_rvsn', cndcn: admin?}
			],
			clientes: [
				{scp: 'emprss', cndcn: operacion?},
				{scp: 'sndcts', cndcn: operacion?},
				{scp: 'trbjdrs', cndcn: operacion?},
				{scp: 'actvs', cndcn: operacion?},
				{scp: 'de_bj', cndcn: admin?},
			],
			asesorias: [
				{scp: 'trmtcn', cndcn: operacion?},
				{scp: 'trmnds',	cndcn: operacion?},
				{scp: 'crrds', cndcn: finanzas?},
				{scp: 'mlts', cndcn: operacion?},
				{scp: 'crts_dspd', cndcn: operacion?},
				{scp: 'rdccns', cndcn: operacion?},
				{scp: 'cnslts',	cndcn: operacion?},
			],
			cargos: [
				{scp: 'trmtcn', cndcn: operacion?},
				{scp: 'trmnds', cndcn: operacion?},
				{scp: 'crrds', cndcn: finanzas?},
				{scp: 'crgs', cndcn: operacion?},
				{scp: 'mnsls', cndcn: operacion?},
			],
			tar_facturas: [
				{scp: 'ingrss',	cndcn: admin?},
				{scp: 'fctrds', cndcn: admin?},
				{scp: 'pgds', cndcn: admin?}
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

end