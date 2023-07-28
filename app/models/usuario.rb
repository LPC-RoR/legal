class Usuario < ApplicationRecord
	TABLA_FIELDS = 	[
		'email'
	]

	scope :ordered, -> { order(:created_at) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
