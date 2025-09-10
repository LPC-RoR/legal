class CreateCheckAuditorias < ActiveRecord::Migration[8.0]
  def change
    create_table :check_auditorias do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.string :mdl
      t.string :cdg
      t.boolean :prsnt
      t.datetime :audited_at
      t.integer :app_perfil_id

      t.timestamps
    end
    add_index :check_auditorias, :ownr_type
    add_index :check_auditorias, :ownr_id
    add_index :check_auditorias, :mdl
    add_index :check_auditorias, :cdg
    add_index :check_auditorias, :app_perfil_id
    add_index :check_auditorias, [:ownr_type, :ownr_id, :cdg], unique: true
  end
end
