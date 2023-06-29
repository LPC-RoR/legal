class CreateMPeriodos < ActiveRecord::Migration[5.2]
  def change
    create_table :m_periodos do |t|
      t.string :m_periodo
      t.integer :clave
      t.integer :m_modelo_id

      t.timestamps
    end
    add_index :m_periodos, :clave
    add_index :m_periodos, :m_modelo_id
  end
end
