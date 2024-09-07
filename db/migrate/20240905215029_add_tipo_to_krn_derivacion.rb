class AddTipoToKrnDerivacion < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_derivaciones, :tipo, :string
    add_index :krn_derivaciones, :tipo
  end
end
