class ChangeFieldTypeInTableName < ActiveRecord::Migration[8.0]
  def change
    change_column :krn_testigos, :email_ok, :string
  end
end