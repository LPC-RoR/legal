class CreateEmailLegals < ActiveRecord::Migration[8.0]
  def change
    create_table :email_legales do |t|
      t.references :act_archivo, null: false, foreign_key: true
      t.references :ownr, polymorphic: true, null: true
      
      t.string  :reporte,      null: false
      t.string  :destinatario, null: false
      t.string  :asunto
      t.integer :estado,       default: 0, null: false
      t.text    :error
      t.datetime :enviado_en
      t.integer :intentos,     default: 0, null: false
      
      t.timestamps
    end
    
    add_index :email_legales, [:act_archivo_id, :estado]
    add_index :email_legales, [:estado, :created_at]
  end
end