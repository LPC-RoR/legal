class ChangeDocCartolasDocCuentaIdNull < ActiveRecord::Migration[8.0]
  def change
    change_column_null :doc_cartolas, :doc_cuenta_id, true
  end
end
