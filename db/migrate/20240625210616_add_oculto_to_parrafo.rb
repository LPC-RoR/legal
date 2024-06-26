class AddOcultoToParrafo < ActiveRecord::Migration[7.1]
  def change
    add_column :parrafos, :oculto, :boolean
  end
end
