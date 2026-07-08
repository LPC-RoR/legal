class AddCntxtClssToTxtEditable < ActiveRecord::Migration[8.0]
  def change
    add_column :txt_editables, :cntxt_clss, :string
    add_index :txt_editables, :cntxt_clss
  end
end
