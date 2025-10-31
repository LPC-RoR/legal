class AddUsuarioIdToNota < ActiveRecord::Migration[8.0]
  def change
    add_column :notas, :usuario_id, :integer
    add_index :notas, :usuario_id
  end
end
