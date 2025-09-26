class Usuario < ApplicationRecord
  belongs_to :tenant, optional: true

  scope :ordered, -> { order(:created_at) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, 
         :lockable, :timeoutable, :confirmable

end
