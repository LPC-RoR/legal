class CreateTarVariableBases < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_variable_bases do |t|
      t.integer :tar_tarifa_id
      t.integer :tipo_causa_id
      t.decimal :tar_base_variable

      t.timestamps
    end
    add_index :tar_variable_bases, :tar_tarifa_id
    add_index :tar_variable_bases, :tipo_causa_id
  end
end
