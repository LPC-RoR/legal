class ClssTxts

	def self.txt_lst_cdg(ownr)
		case ownr.class.name
		when 'KrnInvestigador'
			'invstgdr'
		end
	end

 	def self.txt_lst
	  	{
	  		invstgdr: 	['txt_firma']
	  	}
  	end

end