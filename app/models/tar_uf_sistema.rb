class TarUfSistema < ApplicationRecord

	TABLA_FIELDS = [
		'fecha',
		'$#valor',
	]

    validates_presence_of :fecha, :valor

end
