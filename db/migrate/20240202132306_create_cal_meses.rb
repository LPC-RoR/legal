class CreateCalMeses < ActiveRecord::Migration[5.2]
  def change
    create_table :cal_meses do |t|
      t.integer :cal_mes

      t.timestamps
    end
  end
end
