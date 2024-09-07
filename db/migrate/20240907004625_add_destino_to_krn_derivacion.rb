class AddDestinoToKrnDerivacion < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_derivaciones, :destino, :string
    add_index :krn_derivaciones, :destino
  end
end
