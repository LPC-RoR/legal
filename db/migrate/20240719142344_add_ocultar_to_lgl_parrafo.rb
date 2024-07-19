class AddOcultarToLglParrafo < ActiveRecord::Migration[7.1]
  def change
    add_column :lgl_parrafos, :ocultar, :boolean
  end
end
