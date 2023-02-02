class CreateRegReportes < ActiveRecord::Migration[5.2]
  def change
    create_table :reg_reportes do |t|
      t.string :clave

      t.timestamps
    end
    add_index :reg_reportes, :clave
  end
end
