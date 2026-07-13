class ClssCntxt < ApplicationRecord
	def self.cntxt_for(source)
		src = source.is_a?(String) ? source : source.class.name.tableize
		if krn_source?(src)
			:invstgcns
		else
			:pltfrm
		end
	end

	def self.cntxt_clss
		{
			
		}
	end

	private 

	def self.krn_source?(source)
		source == 'empresas' || source.split('_')[0] == 'krn'
	end
end