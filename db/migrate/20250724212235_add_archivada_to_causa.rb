class AddArchivadaToCausa < ActiveRecord::Migration[8.0]
  def change
    add_column :causas, :archivada, :boolean
  end
end
