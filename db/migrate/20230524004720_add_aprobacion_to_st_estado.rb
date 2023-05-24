class AddAprobacionToStEstado < ActiveRecord::Migration[5.2]
  def change
    add_column :st_estados, :aprobacion, :boolean
  end
end
