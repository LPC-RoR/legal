class AddFieldsToAsesoria < ActiveRecord::Migration[7.1]
  def change
    add_column :asesorias, :pendiente, :boolean
  end
end
