class CreateCtrEtapas < ActiveRecord::Migration[7.1]
  def change
    create_table :ctr_etapas do |t|
      t.integer :procedimiento_id
      t.string :codigo
      t.string :ctr_etapa

      t.timestamps
    end
    add_index :ctr_etapas, :procedimiento_id
    add_index :ctr_etapas, :codigo
  end
end
