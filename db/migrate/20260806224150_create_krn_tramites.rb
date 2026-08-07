class CreateKrnTramites < ActiveRecord::Migration[8.0]
  def change
    create_table :krn_tramites do |t|
      t.references :krn_denuncia, null: false, foreign_key: true
      t.string :tipo, null: false
      t.string :numero_solicitud, null: false
      t.datetime :fecha_hora, null: false  # Fecha y hora del ticket de la plataforma DT

      t.timestamps
    end

    add_index :krn_tramites, [:krn_denuncia_id, :tipo], unique: true
    add_index :krn_tramites, :numero_solicitud, unique: true
  end
end
