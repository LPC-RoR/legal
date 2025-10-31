class CreateActTextos < ActiveRecord::Migration[8.0]
  def change
    create_table :act_textos do |t|
      t.references :act_archivo, null: false, foreign_key: true
      t.string :tipo_documento, null: false
      t.string :titulo, null: false
      t.text :notas
      t.jsonb :metadata, default: {}
      t.integer :version, default: 1
      t.timestamps
    end

    add_index :act_textos, [:act_archivo_id, :tipo_documento], unique: true
  end
end
