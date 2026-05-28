class DocCartola < ApplicationRecord
  belongs_to :doc_cuenta, optional: true
  has_many :doc_transacciones, dependent: :destroy
  has_one_attached :archivo

  # Sin validaciones obligatorias al crear
end