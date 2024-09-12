class CreateKrnTestigos < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_testigos do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.integer :krn_empresa_externa_id
      t.string :rut
      t.string :nombre
      t.string :cargo
      t.string :lugar_trabajo
      t.string :email
      t.boolean :email_ok
      t.boolean :info_reglamento
      t.boolean :info_procedimiento
      t.boolean :info_derechos

      t.timestamps
    end
    add_index :krn_testigos, :ownr_type
    add_index :krn_testigos, :ownr_id
    add_index :krn_testigos, :krn_empresa_externa_id
    add_index :krn_testigos, :rut
  end
end
