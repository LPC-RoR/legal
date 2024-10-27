module Procs
 	extend ActiveSupport::Concern

	def cndtn(code)
		self.prtl_cndtn[code].blank? ? false : (self.prtl_cndtn[code][:cndtn].blank? ? false : self.prtl_cndtn[code][:cndtn])
	end

	def trsh(code)
		self.prtl_cndtn[code].blank? ? false : (self.prtl_cndtn[code][:trsh].blank? ? false : self.prtl_cndtn[code][:trsh])
	end

end