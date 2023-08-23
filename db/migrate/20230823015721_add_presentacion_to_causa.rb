class AddPresentacionToCausa < ActiveRecord::Migration[5.2]
  def change
    add_column :causas, :demandante, :string
    add_column :causas, :abogados, :string
    add_column :causas, :cargo, :string
    add_column :causas, :sucursal, :string
  end
end
