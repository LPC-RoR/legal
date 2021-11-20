class AddGlosaToTarFacturacion < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturaciones, :glosa, :string
  end
end
