class CreateCalAnnios < ActiveRecord::Migration[5.2]
  def change
    create_table :cal_annios do |t|
      t.integer :cal_annio

      t.timestamps
    end
    add_index :cal_annios, :cal_annio
  end
end
