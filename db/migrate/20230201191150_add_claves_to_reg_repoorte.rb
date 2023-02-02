class AddClavesToRegRepoorte < ActiveRecord::Migration[5.2]
  def change
    add_column :reg_reportes, :annio, :integer
    add_index :reg_reportes, :annio
    add_column :reg_reportes, :mes, :integer
    add_index :reg_reportes, :mes
  end
end
