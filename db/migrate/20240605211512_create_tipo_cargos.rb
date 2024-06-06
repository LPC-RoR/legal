class CreateTipoCargos < ActiveRecord::Migration[5.2]
  def change
    create_table :tipo_cargos do |t|
      t.string :tipo_cargo

      t.timestamps
    end
    add_index :tipo_cargos, :tipo_cargo
  end
end
