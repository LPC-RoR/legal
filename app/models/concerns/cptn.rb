module Cptn
 	extend ActiveSupport::Concern

 	def clss_id
 		"#{self.class.name}_#{id}"
 	end

end