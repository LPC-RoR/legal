class CreateDocHonorarios < ActiveRecord::Migration[8.0]
  def change
    create_table :doc_honorarios do |t|
      t.string :contribuyente_nombre, null: false
      t.string :contribuyente_rut, null: false
      t.integer :mes, null: false
      t.integer :anio, null: false
      t.integer :total_brutos, default: 0
      t.integer :total_retenido, default: 0
      t.integer :total_pagado, default: 0

      t.timestamps
    end

    # Un doc_honorario por mes/año para un contribuyente
    add_index :doc_honorarios, [:contribuyente_rut, :mes, :anio], 
              unique: true, name: 'index_doc_honorarios_on_rut_mes_anio'
  end
end
