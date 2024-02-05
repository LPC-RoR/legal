class AddClaveToCalMes < ActiveRecord::Migration[5.2]
  def change
    add_column :cal_meses, :clave, :string
  end
end
