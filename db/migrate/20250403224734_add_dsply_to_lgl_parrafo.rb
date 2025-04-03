class AddDsplyToLglParrafo < ActiveRecord::Migration[8.0]
  def change
    add_column :lgl_parrafos, :dsply, :boolean
  end
end
