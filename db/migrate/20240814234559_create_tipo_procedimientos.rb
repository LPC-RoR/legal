class CreateTipoProcedimientos < ActiveRecord::Migration[7.1]
  def change
    create_table :tipo_procedimientos do |t|
      t.string :tipo_procedimiento

      t.timestamps
    end
  end
end
