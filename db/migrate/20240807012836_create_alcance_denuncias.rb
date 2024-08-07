class CreateAlcanceDenuncias < ActiveRecord::Migration[7.1]
  def change
    create_table :alcance_denuncias do |t|
      t.string :alcance_denuncia

      t.timestamps
    end
  end
end
