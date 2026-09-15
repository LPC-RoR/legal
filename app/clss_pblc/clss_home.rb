class ClssHome < ApplicationRecord
	def self.titles
		{
			index: 			'Externalización de investigaciones Ley 21.643',
			metodologia: 	'Etapas y plazos del procedimiento de investigación | Laborsafe',
			laborsafe: 		'Plataforma tecnológica para investigaciones Ley 21.643 | Laborsafe',
			equipo: 		'Equipo legal: abogados especialistas en Ley 21.643 | Laborsafe',
			simulador: 		'Simulador de plazos del procedimiento Ley 21.643 | Laborsafe',
			registro: 		'Cuenta demo gratuita: evalúe Laborsafe por 10 días'
		}.freeze
	end
end