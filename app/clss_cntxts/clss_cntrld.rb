class ClssCntrld < ApplicationRecord
	CNTXT_CLSS = {
		invstgcns: 	ClssCntrldInvstgcns,
		pltfrm:		ClssCntrldPltfrm
	}.freeze

	def self.cntxt_clss(source)
		CNTXT_CLSS[ClssCntxt.cntxt_for(source)]
	end
end