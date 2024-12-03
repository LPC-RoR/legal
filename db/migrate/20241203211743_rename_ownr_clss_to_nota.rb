class RenameOwnrClssToNota < ActiveRecord::Migration[7.1]
  def change
    rename_column :notas, :ownr_clss, :ownr_type
  end
end
