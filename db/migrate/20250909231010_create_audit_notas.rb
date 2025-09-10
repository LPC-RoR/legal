class CreateAuditNotas < ActiveRecord::Migration[8.0]
  def change
    create_table :audit_notas do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.integer :app_perfil_id
      t.text :nota
      t.text :recomendacion
      t.integer :prioridad

      t.timestamps
    end
    add_index :audit_notas, :ownr_type
    add_index :audit_notas, :ownr_id
    add_index :audit_notas, :app_perfil_id
    add_index :audit_notas, :prioridad
  end
end
