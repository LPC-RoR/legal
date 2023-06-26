class MConciliacion < ApplicationRecord

	belongs_to :m_cuenta

	mount_uploader :m_conciliacion, ArchivoUploader

end
