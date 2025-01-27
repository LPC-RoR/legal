class CreateTarTipoVariables < ActiveRecord::Migration[7.1]
  def change
    create_table :tar_tipo_variables do |t|
      t.integer :tar_tarifa_id
      t.integer :tipo_causa_id
      t.decimal :variable_tipo_causa

      t.timestamps
    end
    add_index :tar_tipo_variables, :tar_tarifa_id
    add_index :tar_tipo_variables, :tipo_causa_id
  end
end
