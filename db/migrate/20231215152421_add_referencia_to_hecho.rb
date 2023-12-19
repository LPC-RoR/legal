class AddReferenciaToHecho < ActiveRecord::Migration[5.2]
  def change
    add_column :hechos, :documento, :string
    add_column :hechos, :paginas, :string
  end
end
