class CreateCheckRealizados < ActiveRecord::Migration[8.0]
  def change
    create_table :check_realizados do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.integer :app_perfil_id
      t.string :mdl
      t.string :cdg
      t.boolean :rlzd
      t.datetime :chequed_at

      t.timestamps
    end
    add_index :check_realizados, :ownr_type
    add_index :check_realizados, :ownr_id
    add_index :check_realizados, :app_perfil_id
    add_index :check_realizados, :mdl
    add_index :check_realizados, :cdg
    add_index :check_realizados, :rlzd
  end
end
