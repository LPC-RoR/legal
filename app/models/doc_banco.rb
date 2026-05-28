class DocBanco < ApplicationRecord
  has_many :doc_cuentas, dependent: :destroy

  validates :nombre, presence: true
  validates :rut, presence: true, uniqueness: true
end