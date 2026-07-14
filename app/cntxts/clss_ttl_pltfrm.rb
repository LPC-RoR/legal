class ClssTtlPltfrm < ApplicationRecord

	def self.clss_dflt
		:indx
	end

	def self.lyt
		{
			indx: {
				clss_str: "pltfrm-titulo-borde rounded-3 p-1 app_lnk",
				styl_str: "font-size: 1.3rem;line-height: 1.5"
			},
			indx_md: {
				clss_str: "pltfrm-titulo-borde-md rounded-2 app_lnk",
				styl_str: "font-size: 1rem;line-height: 1.5"
			},
		}.freeze
	end

end