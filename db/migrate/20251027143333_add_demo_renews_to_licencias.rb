class AddDemoRenewsToLicencias < ActiveRecord::Migration[8.0]
  def change
    add_column :licencias, :demo_renews, :integer, default: 0, null: false
  end
end
