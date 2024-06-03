class AddSolicitudToAntecedente < ActiveRecord::Migration[5.2]
  def change
    add_column :antecedentes, :solicitud, :text
    add_column :antecedentes, :hecho_id, :integer
    add_index :antecedentes, :hecho_id
  end
end
