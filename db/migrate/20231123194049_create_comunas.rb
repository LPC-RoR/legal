class CreateComunas < ActiveRecord::Migration[5.2]
  def change
    create_table :comunas do |t|
      t.string :comuna
      t.integer :region_id

      t.timestamps
    end
    add_index :comunas, :region_id
  end
end
