class ClssTbl < ApplicationRecord

	def self.kminr_nlines
		25
	end

	def self.clss_dflt
		:lst
	end

	def self.clss_lyt
		{
			lst: {
				bx: {
					clss: "p-1 open-sans-regular",
					styl: nil
				},
				tbl_clss: "table table-sm table-borderless table-striped table-hover",
				objt: {
					mrgn_pddn: "px-1 py-1",
					brdr: nil,
					rndd: "rounded-2",
					fnt: nil,
					bg_crl: nil,
					clr: "text-secondary",
					lnks: "app_lnk",
					styl: "font-size: 1rem;margin-bottom: 1px;"
				}
			}
		}.freeze
	end

	def self.clss_str(clss)
		ClssTbl.clss_lyt[clss][:objt].except(:styl).values.compact.join(' ')
	end

	def self.styl_str(clss)
		ClssTbl.clss_lyt[clss][:objt][:styl]
	end

end