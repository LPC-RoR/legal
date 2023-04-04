class AddDatosToRegistro < ActiveRecord::Migration[5.2]
  def change
    add_column :registros, :horas, :integer
    add_column :registros, :minutos, :integer
    add_column :registros, :abogado, :string
  end
end
