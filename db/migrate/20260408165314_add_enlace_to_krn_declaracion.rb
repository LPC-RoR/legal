class AddEnlaceToKrnDeclaracion < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_declaraciones, :enlace, :string
  end
end
