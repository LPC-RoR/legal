class HechoArchivo < ApplicationRecord
	belongs_to :hecho
	belongs_to :app_archivo

	def text_color
		self.establece.blank? ? 'dark' : self.establece
	end
end
