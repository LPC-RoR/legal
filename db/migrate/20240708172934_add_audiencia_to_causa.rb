class AddAudienciaToCausa < ActiveRecord::Migration[7.1]
  def change
    add_column :causas, :audiencia, :string
  end
end
