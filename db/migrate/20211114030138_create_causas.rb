class CreateCausas < ActiveRecord::Migration[5.2]
  def change
    create_table :causas do |t|
      t.string :causa
      t.string :identificador
      t.string :cliente_id

      t.timestamps
    end
  end
end
