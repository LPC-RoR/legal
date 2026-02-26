class AddEmailOkToAppContacto < ActiveRecord::Migration[8.0]
  def change
    add_column :app_contactos, :email_ok, :string
  end
end
