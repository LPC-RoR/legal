class RemoveTarCalculoFldsFromTarCalculo < ActiveRecord::Migration[7.1]
  def change
    remove_index :tar_calculos, :clnt_id
    remove_column :tar_calculos, :clnt_id, :integer
    remove_index :tar_calculos, :ownr_clss
    remove_column :tar_calculos, :ownr_clss, :string

    remove_index :tar_facturaciones, :cliente_id
    remove_column :tar_facturaciones, :cliente_id, :integer
    remove_index :tar_facturaciones, :cliente_class
    remove_column :tar_facturaciones, :cliente_class, :string
    remove_index :tar_facturaciones, :owner_class
    remove_column :tar_facturaciones, :owner_class, :string
    remove_index :tar_facturaciones, :owner_id
    remove_column :tar_facturaciones, :owner_id, :integer

    remove_column :tar_facturaciones, :estado, :string
    remove_column :tar_facturaciones, :monto_uf, :decimal
    remove_column :tar_facturaciones, :pago_calculo, :decimal
  end
end
