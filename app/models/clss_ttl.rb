class ClssTtl < ApplicationRecord

	def self.clss_dflt
		:indx
	end

	def self.clss_lyt
		{
			indx: {
				mrgn_pddn: "px-1 py-1",
				brdr: "border border-dark-subtle border-4",
				rndd: "rounded-4",
				fnt: "fs-5",
				bg_crl: nil,
				clr: "dark-subtle",
				lnks: "app_lnk",
				styl: "margin-left: 1px;margin-right: 1px; margin-bottom: 1px;"
			},
			head: {
				mrgn_pddn: "px-1 py-1",
				brdr: "border",
				rndd: "rounded-2",
				fnt: "fs-5",
				bg_crl: "bg_azul_claro",
				clr: "text-primary",
				lnks: "app_lnk",
				styl: "margin-left: 1px;margin-right: 1px; margin-bottom: 1px;"
			},
		}.freeze
	end

	def self.clss_str(clss)
		ClssTtl.clss_lyt[clss].except(:styl).values.compact.join(' ')
	end

	def self.styl_str(clss)
		ClssTtl.clss_lyt[clss][:styl]
	end

end