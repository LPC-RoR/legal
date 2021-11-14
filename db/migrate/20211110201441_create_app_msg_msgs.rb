class CreateAppMsgMsgs < ActiveRecord::Migration[5.2]
  def change
    create_table :app_msg_msgs do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end
    add_index :app_msg_msgs, :parent_id
    add_index :app_msg_msgs, :child_id
  end
end
