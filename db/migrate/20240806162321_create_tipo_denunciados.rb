class CreateTipoDenunciados < ActiveRecord::Migration[7.1]
  def change
    create_table :tipo_denunciados do |t|
      t.string :tipo_denunciado

      t.timestamps
    end
  end
end
