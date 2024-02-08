class CreateAgeUsuarios < ActiveRecord::Migration[5.2]
  def change
    create_table :age_usuarios do |t|
      t.string :owner_class
      t.integer :owner_id
      t.string :age_usuario

      t.timestamps
    end
    add_index :age_usuarios, :owner_class
    add_index :age_usuarios, :owner_id
    add_index :age_usuarios, :age_usuario
  end
end
