class DropLogoFile < ActiveRecord::Migration[8.0]
  def change
   drop_table :rcrs_logos
  end
end
