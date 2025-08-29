class CreateComRequerimientos < ActiveRecord::Migration[8.0]
  def change
    create_table :com_requerimientos do |t|
      t.string :rut
      t.string :razon_social
      t.string :nombre
      t.string :email
      t.boolean :contacto_comercial
      t.boolean :reunion_telematica
      t.boolean :laborsafe
      t.boolean :auditoria
      t.boolean :externalizacion
      t.boolean :consultoria
      t.boolean :capacitacion
      t.string :asesoria_legal

      t.timestamps
    end
    add_index :com_requerimientos, :rut
  end
end
