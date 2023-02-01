class SbLista < ApplicationRecord

	ACCESOS = ['dog', 'admin', 'usuario']

	TABLA_FIELDS = [
		's#lista'
	]

	has_many :sb_elementos

end
