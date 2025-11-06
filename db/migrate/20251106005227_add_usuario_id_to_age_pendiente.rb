class AddUsuarioIdToAgePendiente < ActiveRecord::Migration[8.0]
  def change
    add_column :age_pendientes, :usuario_id, :integer
    add_index :age_pendientes, :usuario_id
  end
end
