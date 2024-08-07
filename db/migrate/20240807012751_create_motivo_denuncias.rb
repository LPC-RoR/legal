class CreateMotivoDenuncias < ActiveRecord::Migration[7.1]
  def change
    create_table :motivo_denuncias do |t|
      t.string :motivo_denuncia

      t.timestamps
    end
  end
end
