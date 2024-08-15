class CreateLglNEmpleados < ActiveRecord::Migration[7.1]
  def change
    create_table :lgl_n_empleados do |t|
      t.string :lgl_n_empleados
      t.decimal :n_min
      t.decimal :n_max

      t.timestamps
    end
  end
end
