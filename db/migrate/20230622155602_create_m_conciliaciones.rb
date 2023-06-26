class CreateMConciliaciones < ActiveRecord::Migration[5.2]
  def change
    create_table :m_conciliaciones do |t|
      t.string :m_conciliacion
      t.integer :m_cuenta_id

      t.timestamps
    end
    add_index :m_conciliaciones, :m_cuenta_id
  end
end
