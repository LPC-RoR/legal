module Cmenu
	def cmenu_clss
		{
			'clientes' => {
				estados: [
					{
						std: 'activo',
						cndcn: admin?
					},
					{
						std: 'baja',
						cndcn: admin?
					}
				],
				items: {
					'activo' => 'Activos',
					'baja' => 'Dados de baja'
				},
				selectors: [
					['Empresas', admin?],
					['Sindicatos', admin?],
					['Trabajadores', operacion?]
				]

			},
			'causas' => {
				estados: [
					{
						std: 'tramitación',
						cndcn: operacion?
					},
					{
						std: 'terminada',
						cndcn: operacion?
					},
					{
						std: 'cerrada',
						cndcn: general?
					}
				],
				items: {
					'tramitación' => 'En Tramitación',
					'terminada' => 'Terminadas',
					'cerrada' => 'Cerradas'
				},
				selectors: nil
			},
			'asesorias' => {
				estados: [
					{
						std: 'tramitación',
						cndcn: operacion?
					},
					{
						std: 'terminada',
						cndcn: operacion?
					},
					{
						std: 'cerrada',
						cndcn: finanzas?
					}
				],
				items: {
					'tramitación' => 'En Tramitación',
					'terminada' => 'Terminadas',
					'cerrada' => 'Cerradas',
					'CartaDespido' => 'Carta de despido'
				},
				selectors: [
					['Multas', admin?],
					['CartaDespido', admin?],
					['Redacciones', admin?],
					['Consultas', admin?]
				]
			},
			'cargos' => {
				estados: [
					{
						std: 'tramitación',
						cndcn: operacion?
					},
					{
						std: 'terminada',
						cndcn: operacion?
					},
					{
						std: 'cerrada',
						cndcn: finanzas?
					}
				],
				items: {
					'tramitación' => 'En Tramitación',
					'terminada' => 'Terminadas',
					'cerrada' => 'Cerradas'
				},
				selectors: [
					['Cargos', admin?],
					['Mensuales', admin?]
				]
			},
			'tar_facturas' => {
				estados: [
					{
						std: 'ingreso',
						cndcn: operacion?
					},
					{
						std: 'facturada',
						cndcn: operacion?
					},
					{
						std: 'pagada',
						cndcn: finanzas?
					}
				],
				items: {
					'ingreso' => 'Por facturar',
					'facturada' => 'Facturadas',
					'pagada' => 'Pagadas'
				},
				selectors: nil
			},
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
			'home' => {
				estados: nil,
				items: nil,
				selectors: [
					['Causas', operacion?],
					['Pagos', admin?],
					['Facturas', finanzas?]
				]
			}
		}
	end

	def display_name(c, item)
		k_name = item.class.name == 'String' ? item : item[0]
		d_name = cmenu_clss[c][:items][k_name]
		d_name.blank? ? k_name : d_name
	end

	def first_estado(controller)
		estado = nil
		cmenu_clss[controller][:estados].each do |std|
			estado = std[:std] if estado.blank? and std[:cndcn]
		end
		estado
	end

	def first_selector(controller)
		selector = nil
		cmenu_clss[controller][:selectors].each do |slctr|
			selector = slctr[0] if selector.blank? and slctr[1]
		end
		selector
	end

	def get_first_es(controller)
		first_estado(controller).blank? ? (first_selector(controller).blank? ? nil : ['selector', first_selector(controller)]) : ['estado', first_estado(controller)]
	end
end