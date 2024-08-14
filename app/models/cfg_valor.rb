class CfgValor < ApplicationRecord

	CFG_NAMES = ['app_nombre', 'app_sigla', 'app_home',
		'lyt_o_menu_padd',
		'lyt_o_bann', 'lyt_o_bann_padd',
		'lyt_navbar', 'lyt_navbar_padd',
		'lyt_body_padd']

	belongs_to :app_version
end
