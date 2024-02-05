class AddCalAnnioIdToCalMes < ActiveRecord::Migration[5.2]
  def change
    add_column :cal_meses, :cal_annio_id, :integer
    add_index :cal_meses, :cal_annio_id
  end
end
