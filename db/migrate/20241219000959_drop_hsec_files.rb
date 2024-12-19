class DropHsecFiles < ActiveRecord::Migration[7.1]
  def change
    drop_table :h_links
    drop_table :h_temas
  end
end
