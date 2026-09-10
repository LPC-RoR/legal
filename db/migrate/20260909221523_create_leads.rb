class CreateLeads < ActiveRecord::Migration[8.0]
  def change
    create_table :leads do |t|
      t.string :nombre
      t.string :email
      t.string :telefono
      t.string :empresa
      t.string :cargo
      t.text :mensaje
      t.integer :estado
      t.string :fuente

      t.timestamps
    end
  end
end
