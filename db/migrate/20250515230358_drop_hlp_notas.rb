class DropHlpNotas < ActiveRecord::Migration[8.0]
  def change
    drop_table :hlp_notas
  end
end
