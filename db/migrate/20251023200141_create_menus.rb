class CreateMenus < ActiveRecord::Migration[8.0]
  def change
    # db/migrate/xxxx_create_menus.rb
    create_table :menus do |t|
      t.string  :key,     null: false             # ej. "admin", "accounting", "vendor"
      t.boolean :enabled, null: false, default: false
      t.jsonb   :items,   null: false, default: [] # array de hashes {name:, path:, icon:, children:[]}
      t.timestamps
    end
    add_index :menus, :key, unique: true
  end
end
