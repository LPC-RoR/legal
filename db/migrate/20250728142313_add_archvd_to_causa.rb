class AddArchvdToCausa < ActiveRecord::Migration[8.0]
  def change
    add_column :causas, :archvd, :boolean
  end
end
