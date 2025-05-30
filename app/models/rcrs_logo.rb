class RcrsLogo < ApplicationRecord

	require 'carrierwave/orm/activerecord'

	mount_uploader :logo, LogoUploader

	belongs_to :ownr, polymorphic:true
	
end