class CreateTarLiquidaciones < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_liquidaciones do |t|
      t.string :liquidacion
      t.string :owner_class
      t.integer :owner_id

      t.timestamps
    end
    add_index :tar_liquidaciones, :owner_class
    add_index :tar_liquidaciones, :owner_id
  end
end
