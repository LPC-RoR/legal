class UpdatePrtcpnts < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_testigos, :articulo_4_1, :boolean
    add_column :krn_testigos, :articulo_516, :boolean
    add_column :krn_testigos, :direccion_notificacion, :string

    remove_column :krn_denunciantes, :info_reglamento, :boolean
    remove_column :krn_denunciantes, :info_procedimiento, :boolean
    remove_column :krn_denunciantes, :info_derechos, :boolean
    remove_column :krn_denunciados, :info_reglamento, :boolean
    remove_column :krn_denunciados, :info_procedimiento, :boolean
    remove_column :krn_denunciados, :info_derechos, :boolean
    remove_column :krn_testigos, :info_reglamento, :boolean
    remove_column :krn_testigos, :info_procedimiento, :boolean
    remove_column :krn_testigos, :info_derechos, :boolean
  end
end
