module Cmenu

	def scp_menu 
		{
			causas: [
				{scp: 'rvsn',	cndcn: operacion?},
				{scp: 'ingrs',	cndcn: operacion?},
				{scp: 'trmtcn',	cndcn: operacion?},
				{scp: 'archvd',	cndcn: operacion?},
				{scp: 'vacio', cndcn: finanzas?},
				{scp: 'incmplt',	cndcn: finanzas?},
				{scp: 'monto',	cndcn: finanzas?},
				{scp: 'cmplt', cndcn: finanzas?},
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
				rvsn: 	'revisión de causas',
				ingrs: 	'ingreso',
				trmtcn: 'en tramitación',
				archvd: 'archivadas',
				vacio: 	'sin pagos',
				incmplt: 'pagos incompletos',
				monto: 	'con monto',
				cmplt: 	'pagos completos',
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