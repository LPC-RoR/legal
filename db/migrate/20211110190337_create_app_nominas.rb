class CreateAppNominas < ActiveRecord::Migration[5.2]
  def change
    create_table :app_nominas do |t|
      t.string :nombre
      t.string :email
      t.string :tipo

      t.timestamps
    end
    add_index :app_nominas, :email
  end
end
