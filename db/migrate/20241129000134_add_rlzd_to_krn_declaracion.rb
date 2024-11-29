class AddRlzdToKrnDeclaracion < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_declaraciones, :rlzd, :boolean
  end
end
