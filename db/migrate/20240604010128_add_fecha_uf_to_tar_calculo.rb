class AddFechaUfToTarCalculo < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_calculos, :fecha_uf, :datetime
  end
end
