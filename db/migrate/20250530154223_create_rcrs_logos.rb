class CreateRcrsLogos < ActiveRecord::Migration[8.0]
  def change
    create_table :rcrs_logos do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.string :logo

      t.timestamps
    end
    add_index :rcrs_logos, :ownr_type
    add_index :rcrs_logos, :ownr_id
  end
end
