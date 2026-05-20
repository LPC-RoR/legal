# Gestión de KrnTexto en sus distintos usos
# Esta clase distribuye a las diferentes clases
class ClssTxt

	CAUSA_TXTS = ['causa_cuantia']	

	def self.causa_txt?(code)
		ClssTxt::CAUSA_TXTS.include?(code)
	end

	def self.txt_clss?(code)
		ClssTxt::CAUSA_TXTS.include?(code) ? ClssTxtCausa : ClssPdfRprt
	end

	def self.txt_name_clss?(code)
		ClssTxt::CAUSA_TXTS.include?(code) ? ClssTxtCausa : ClssPrcdmnt
	end

end