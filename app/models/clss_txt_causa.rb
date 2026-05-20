# Gestión de KrnTexto en sus distintos usos
# Esta clase distribuye a las diferentes clases
class ClssTxtCausa

	CAUSA_TXTS = ['causa_cuantia']	

	def self.causa_txt?(code)
		ClssTxt::CAUSA_TXTS.include?(code)
	end

	def self.txt_clss?(code)
		ClssTxt::CAUSA_TXTS.include?(code) ? ClssTxtCausa : ClssPdfRprt
	end

	def self.txt_lst
		{
			causa_cuantia: ['causa_cuantia']
		}
	end

  	def self.act_nombre
    	{
          'causa_cuantia' 		=> 'Texto de detalle de cuantía',
        }
	end
end