class AddRepresentanteToKrnDenunciante < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denunciantes, :dependencia_denunciante_id, :integer
    add_index :krn_denunciantes, :dependencia_denunciante_id
    add_column :krn_denunciantes, :representante, :string
    add_column :krn_denunciantes, :doc_representante, :string
  end
end
