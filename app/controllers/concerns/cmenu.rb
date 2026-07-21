module Cmenu

	def scp_menu 
		{
			causas: [
				{scp: 'trmtcn',		cndcn: operacion?},
				{scp: 'archvd',		cndcn: operacion?},
				{scp: 'rcnts',		cndcn: operacion?},
			],
			clientes: [
				{scp: 'emprss', 	cndcn: operacion?},
				{scp: 'sndcts', 	cndcn: operacion?},
				{scp: 'trbjdrs',	cndcn: operacion?},
				{scp: 'actvs', 		cndcn: operacion?},
				{scp: 'inctvs', 	cndcn: admin?},
			],
			asesorias: [
				{scp: 'trmtcn', 	cndcn: operacion?},
				{scp: 'trmnds',		cndcn: operacion?},
				{scp: 'crrds', 		cndcn: finanzas?},
				{scp: 'mlts', 		cndcn: operacion?},
				{scp: 'crts_dspd', 	cndcn: operacion?},
				{scp: 'rdccns', 	cndcn: operacion?},
				{scp: 'cnslts',		cndcn: operacion?},
			],
			tar_facturas: [
				{scp: 'ingrss',		cndcn: admin?},
				{scp: 'fctrds', 	cndcn: admin?},
				{scp: 'pgds', 		cndcn: admin?}
			]
		}
	end

	def scp_item 
		{
			causas: {
				trmtcn: 	'en tramitación',
				archvd: 	'archivadas',
				rcnts: 		'últimos 30 días',
				vacios: 	'sin pagos',
				incmplt: 	'pagos incompletos',
				cmplt: 		'pagos completos',
				anno: 		'Año 2025',
			},
			clientes: {
				emprss: 	'Empresas',
				sndcts: 	'Sindicatos',
				trbjdrs: 	'Trabajadores',
				actvs: 		'Activos',
				inctvs: 	'Inactivos'
			},
			asesorias: {
				trmtcn: 	'en tramitación',
				trmnds: 	'terminadas',
				crrds: 		'cerradas',
				mlts: 		'Multas',
				crts_dspd: 	'Cartas de despido',
				rdccns: 	'Redacciones',
				cnslts: 	'Consultas'
			},
			tar_facturas: {
				ingrss: 	'ingresadas',
				fctrds: 	'facturadas',
				pgds: 		'pagadas'
			}
		}
	end

end