class CreateAppVersiones < ActiveRecord::Migration[5.2]
  def change
    create_table :app_versiones do |t|
      t.string :app_nombre
      t.string :app_sigla
      t.string :app_logo
      t.string :app_banner
      t.string :dog_email

      t.timestamps
    end
  end
end
