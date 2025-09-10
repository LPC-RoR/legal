class CreateTenants < ActiveRecord::Migration[8.0]
  def change
    create_table :tenants do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
