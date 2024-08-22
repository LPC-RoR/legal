class CreateLglTramoEmpresas < ActiveRecord::Migration[7.1]
  def change
    create_table :lgl_tramo_empresas do |t|
      t.integer :orden
      t.string :lgl_tramo_empresa
      t.decimal :min
      t.decimal :max

      t.timestamps
    end
    add_index :lgl_tramo_empresas, :orden
  end
end
