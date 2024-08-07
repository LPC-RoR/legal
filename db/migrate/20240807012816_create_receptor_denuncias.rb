class CreateReceptorDenuncias < ActiveRecord::Migration[7.1]
  def change
    create_table :receptor_denuncias do |t|
      t.string :receptor_denuncia

      t.timestamps
    end
  end
end
