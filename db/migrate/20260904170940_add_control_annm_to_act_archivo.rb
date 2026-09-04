class AddControlAnnmToActArchivo < ActiveRecord::Migration[8.0]
  def change
    add_column :act_archivos, :no_annm, :boolean
  end
end
