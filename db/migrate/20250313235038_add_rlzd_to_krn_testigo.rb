class AddRlzdToKrnTestigo < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_testigos, :rlzd, :boolean
  end
end
