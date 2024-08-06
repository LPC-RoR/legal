class CreateTipoDenuncias < ActiveRecord::Migration[7.1]
  def change
    create_table :tipo_denuncias do |t|
      t.string :tipo_denuncia

      t.timestamps
    end
  end
end
