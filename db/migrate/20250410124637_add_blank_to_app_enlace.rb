class AddBlankToAppEnlace < ActiveRecord::Migration[8.0]
  def change
    add_column :app_enlaces, :blank, :boolean
  end
end
