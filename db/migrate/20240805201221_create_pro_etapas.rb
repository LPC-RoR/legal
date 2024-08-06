class CreateProEtapas < ActiveRecord::Migration[7.1]
  def change
    create_table :pro_etapas do |t|
      t.integer :producto_id
      t.integer :orden
      t.string :code_descripcion
      t.string :pro_etapa
      t.string :estado

      t.timestamps
    end
    add_index :pro_etapas, :producto_id
    add_index :pro_etapas, :orden
    add_index :pro_etapas, :code_descripcion
  end
end
