class AddOrigenToKrnDerivacion < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_derivaciones, :origen, :string
    add_index :krn_derivaciones, :origen
  end
end
