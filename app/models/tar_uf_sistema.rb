class TarUfSistema < ApplicationRecord

	TABLA_FIELDS = [
		'fecha',
		'$2#valor',
	]

    validates_presence_of :fecha, :valor

end
