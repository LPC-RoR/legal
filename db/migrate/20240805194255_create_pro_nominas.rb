class CreateProNominas < ActiveRecord::Migration[7.1]
  def change
    create_table :pro_nominas do |t|
      t.integer :app_nomina_id
      t.integer :producto_id

      t.timestamps
    end
    add_index :pro_nominas, :app_nomina_id
    add_index :pro_nominas, :producto_id
  end
end
