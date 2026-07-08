class AddCrtnModeToActArchivo < ActiveRecord::Migration[8.0]
  def change
    add_column :act_archivos, :crtn_mode, :string
    add_column :act_archivos, :fuente, :string
    add_column :act_archivos, :feha_envio, :datetime
    add_index :act_archivos, :crtn_mode
  end
end
