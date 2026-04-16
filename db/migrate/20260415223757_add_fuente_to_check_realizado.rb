class AddFuenteToCheckRealizado < ActiveRecord::Migration[8.0]
  def change
    add_column :check_realizados, :fuente, :string
  end
end
