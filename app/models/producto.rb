class Producto < ApplicationRecord
	has_many :pro_nominas
	has_many :app_nominas, through: :pro_nominas

	has_many :pro_clientes
	has_many :clientes, through: :pro_clientes

	has_many :pro_etapas
end
