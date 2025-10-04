class DropControlFiles < ActiveRecord::Migration[8.0]
  def change
    drop_table :tipo_procedimientos
    drop_table :procedimientos
    drop_table :ctr_etapas
  end
end
