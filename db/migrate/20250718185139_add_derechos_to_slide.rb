class AddDerechosToSlide < ActiveRecord::Migration[8.0]
  def change
    add_column :slides, :derechos, :text
  end
end
