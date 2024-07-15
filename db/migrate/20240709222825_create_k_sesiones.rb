class CreateKSesiones < ActiveRecord::Migration[7.1]
  def change
    create_table :k_sesiones do |t|
      t.datetime :fecha
      t.string :sesion

      t.timestamps
    end
  end
end
