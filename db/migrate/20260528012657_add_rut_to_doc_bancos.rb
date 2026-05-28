class AddRutToDocBancos < ActiveRecord::Migration[8.0]
  def change
    # Solo agrega si no existe
    unless column_exists?(:doc_bancos, :rut)
      add_column :doc_bancos, :rut, :string, null: false, default: ''
    end

    # Agrega índice único solo si no existe
    unless index_exists?(:doc_bancos, :rut)
      add_index :doc_bancos, :rut, unique: true
    end
  end
end
