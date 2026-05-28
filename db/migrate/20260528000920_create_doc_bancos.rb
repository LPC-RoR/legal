class CreateDocBancos < ActiveRecord::Migration[8.0]
  def change
    create_table :doc_bancos do |t|
      t.string :nombre, null: false
      t.string :rut, null: false

      t.timestamps
    end

    add_index :doc_bancos, :rut, unique: true
  end
end
