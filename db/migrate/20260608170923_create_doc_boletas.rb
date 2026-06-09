class CreateDocBoletas < ActiveRecord::Migration[8.0]
  def change
    create_table :doc_boletas do |t|
      t.references :doc_honorario, null: false, foreign_key: true
      t.integer :numero, null: false
      t.date :fecha, null: false
      t.string :estado, null: false, default: 'VIGENTE'
      t.date :fecha_anulacion
      t.string :emisor_rut, null: false
      t.string :emisor_nombre, null: false
      t.boolean :sociedad_profesional, default: false
      t.integer :brutos, default: 0
      t.integer :retenido, default: 0
      t.integer :pagado, default: 0

      t.timestamps
    end

    # CLAVE DE UNICIDAD: numero + emisor_rut dentro del mismo doc_honorario
    add_index :doc_boletas, [:doc_honorario_id, :numero, :emisor_rut],
              unique: true, name: 'index_dos_boletas_on_doc_numero_rut'

    add_index :doc_boletas, :emisor_rut
    add_index :doc_boletas, :fecha
    add_index :doc_boletas, :estado
  end
end
