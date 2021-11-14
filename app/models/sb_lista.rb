class SbLista < ApplicationRecord

	ACCESOS = ['dog', 'admin', 'usuario']

	TABLA_FIELDS = [
		['lista', 'show']
	]

	has_many :sb_elementos

end
