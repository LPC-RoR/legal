class ClssCntxt < ApplicationRecord
	def self.cntxt_for(source)
		src = source.is_a?(String) ? source : source.class.name.tableize
		if krn_source?(src)
			:invstgcns
		else
			:pltfrm
		end
	end

	def self.cntxt_for_objt(objt)
		src = objt.class.table_name
		if rcrss?(src)
			objt.ownr.present? ? cntxt_for(objt.ownr.class.table_name) : :pltfrm
		elsif krn_source?(src)
			:invstgcns
		else
			:pltfrm
		end
	end

	# En esta clase no se asignan contxt_clss porque no sabemos de que clase se trata: Ttl, Tipo, etc.

	private 

	def self.krn_source?(source)
		['empresas', 'cuentas'].include?(source) || source.split('_')[0] == 'krn'
	end

	def self.rcrss?(source)
		src = source.class.name == 'String' ? source : source.class.tabla_name
		['app_contactos', 'app_nominas', 'act_archivos', 'notas'].include?(src)		
	end
end