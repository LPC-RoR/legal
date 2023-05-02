class AddCamposToCausa < ActiveRecord::Migration[5.2]
  def change
    add_column :causas, :rol, :string
    add_index :causas, :rol
    add_column :causas, :era, :integer
    add_index :causas, :era
    add_column :causas, :fecha_ingreso, :datetime
    add_index :causas, :fecha_ingreso
    add_column :causas, :caratulado, :string
    add_column :causas, :ubicacion, :string
    add_column :causas, :fecha_ubicacion, :datetime
    add_column :causas, :tribunal_corte_id, :integer
    add_index :causas, :tribunal_corte_id
    add_column :causas, :rit, :string
    add_column :causas, :estado_causa, :string
    add_index :causas, :estado_causa
  end
end
