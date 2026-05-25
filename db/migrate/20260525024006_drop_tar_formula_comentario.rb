class DropTarFormulaComentario < ActiveRecord::Migration[8.0]
  def change
   drop_table :tar_comentarios
   drop_table :tar_formulas
  end
end
