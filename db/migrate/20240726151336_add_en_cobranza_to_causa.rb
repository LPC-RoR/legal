class AddEnCobranzaToCausa < ActiveRecord::Migration[7.1]
  def change
    add_column :causas, :en_cobranza, :boolean
  end
end
