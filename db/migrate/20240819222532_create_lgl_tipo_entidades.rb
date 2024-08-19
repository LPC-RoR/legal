class CreateLglTipoEntidades < ActiveRecord::Migration[7.1]
  def change
    create_table :lgl_tipo_entidades do |t|
      t.string :lgl_tipo_entidad

      t.timestamps
    end
  end
end
