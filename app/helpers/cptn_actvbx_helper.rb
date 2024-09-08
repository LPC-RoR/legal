module CptnActvbxHelper
	def actvbx_gly
		{
			'Derivación' => 'arrow-up-right',
			'Confirmación' => 'check2-square',
			'Selección' => 'toggles',
			'Recepción' => 'box-arrow-in-down-right',
			'Info' => 'toggle-on'
		}
	end

	def answ_accn(accn)
		case accn
		when 'Selección'
			'Info'
		else
			accn
		end		
	end

	def actvbx_q_txt
		{
			'riohs' => 'RIOHS que incluye el procedimiento de investigación y sanción NO está vigente',
			'a41' => 'Aplica artículo 4 inciso primero del Código del trabajo.',
			'i_optns' => 'Informar al denunciante su opciones de derivación ( investigación )',
			'd_optn' => 'Denunciante define opción derivación denuncia ( empresa o multi )',
			'e_optn' => 'Empresa define opción derivación denuncia ( empresa o multi )',
			'r_multi' => 'Recepción derivación de denuncia multi empresa',
			'invstgdr' => 'Seleccione investigador a cargo de la denuncia',
			'leida' => 'Investigador debe leer la denuncia'
		}
	end

	def actvbx_a_txt
		{
			'i_optns' => 'Denunciante ya fue informado de sus opciones de investigación ( derivación )',
			'd_optn' => 'Denunciante opto por investigación en : ',
			'e_optn' => 'Empresa opto por investigación en : ',
			'invstgdr' => 'Investigador seleccionado : ',
			'leida' => 'Investigador ya leyó la denuncia'
		}
	end
end
