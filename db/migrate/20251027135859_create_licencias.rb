class CreateLicencias < ActiveRecord::Migration[8.0]
  def change
    create_table :licencias do |t|
      t.references :empresa, null: false, foreign_key: true
      t.string  :plan,        null: false   # 'demo' | 'anual'
      t.string  :status,      null: false   # 'active' | 'expired'
      t.integer :max_denuncias, default: 0
      t.datetime :started_at, null: false
      t.datetime :finished_at, null: false

      t.timestamps
    end
  end
end
