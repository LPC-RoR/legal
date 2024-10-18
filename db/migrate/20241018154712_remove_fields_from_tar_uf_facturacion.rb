class RemoveFieldsFromTarUfFacturacion < ActiveRecord::Migration[7.1]
  def change
    remove_column :tar_uf_facturaciones, :owner_class, :string
    remove_column :tar_uf_facturaciones, :owner_id, :integer
    remove_column :tar_uf_facturaciones, :pago, :string
  end
end
