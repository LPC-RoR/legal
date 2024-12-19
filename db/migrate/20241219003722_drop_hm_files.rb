class DropHmFiles < ActiveRecord::Migration[7.1]
  def change
    drop_table :hm_links
    drop_table :hm_notas
    drop_table :hm_paginas
    drop_table :hm_parrafos
  end
end
