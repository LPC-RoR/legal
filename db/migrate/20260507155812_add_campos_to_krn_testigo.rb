class AddCamposToKrnTestigo < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denunciantes, :telefono, :string
    add_column :krn_denunciados, :telefono, :string
    add_column :krn_testigos, :telefono, :string
    add_column :krn_testigos, :origen, :string
  end
end
