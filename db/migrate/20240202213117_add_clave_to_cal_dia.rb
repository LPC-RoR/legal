class AddClaveToCalDia < ActiveRecord::Migration[5.2]
  def change
    add_column :cal_dias, :clave, :string
  end
end
