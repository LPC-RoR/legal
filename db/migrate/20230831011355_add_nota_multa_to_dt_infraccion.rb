class AddNotaMultaToDtInfraccion < ActiveRecord::Migration[5.2]
  def change
    add_column :dt_infracciones, :nota_multa, :string
  end
end
