class AddConfirmacionToLeads < ActiveRecord::Migration[8.0]
  def change
    # Doble opt-in
    add_column :leads, :email_confirmado, :boolean, default: false, null: false
    add_column :leads, :confirmacion_token, :string
    add_index  :leads, :confirmacion_token, unique: true

    # Forensis para los "Test Company"
    add_column :leads, :remote_ip, :string
    add_column :leads, :user_agent, :string
  end
end
