class AddProcessingStatusToActArchivos < ActiveRecord::Migration[8.0]
  def change
    add_column :act_archivos, :processing_status, :string, default: 'pending'
    add_column :act_archivos, :processed_at, :datetime
    add_index :act_archivos, :processing_status
  end
end
