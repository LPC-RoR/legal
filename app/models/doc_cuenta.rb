class DocCuenta < ApplicationRecord
  belongs_to :doc_banco
  has_many :doc_cartolas, dependent: :destroy
  has_many :doc_transacciones, dependent: :destroy

  validates :numero_cuenta, presence: true, uniqueness: true
end