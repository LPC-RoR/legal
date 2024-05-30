class CreateTarCalculos < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_calculos do |t|
      t.integer :clnt_id
      t.string :ownr_clss
      t.integer :ownr_id
      t.integer :tar_pago_id
      t.string :moneda
      t.decimal :monto
      t.string :glosa
      t.decimal :cuantia

      t.timestamps
    end
    add_index :tar_calculos, :clnt_id
    add_index :tar_calculos, :ownr_clss
    add_index :tar_calculos, :ownr_id
    add_index :tar_calculos, :tar_pago_id
  end
end
