class AddTituloToKrnTexto < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_textos, :titulo, :string
  end
end
