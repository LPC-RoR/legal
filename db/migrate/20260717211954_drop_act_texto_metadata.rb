class DropActTextoMetadata < ActiveRecord::Migration[8.0]
  def change
    drop_table :act_textos
    drop_table :act_metadatas
  end
end