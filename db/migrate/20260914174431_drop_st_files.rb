class DropStFiles < ActiveRecord::Migration[8.0]
  def change
    drop_table :st_modelos
    drop_table :st_estados
    drop_table :st_logs
  end
end
