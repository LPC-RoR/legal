class CreateAudiencias < ActiveRecord::Migration[5.2]
  def change
    create_table :audiencias do |t|
      t.integer :tipo_causa_id
      t.string :audiencia
      t.string :tipo
      t.integer :orden

      t.timestamps
    end
    add_index :audiencias, :tipo_causa_id
    add_index :audiencias, :orden
  end
end
