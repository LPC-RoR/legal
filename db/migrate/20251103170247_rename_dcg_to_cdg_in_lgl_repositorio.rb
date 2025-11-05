class RenameDcgToCdgInLglRepositorio < ActiveRecord::Migration[8.0]
  def change
    rename_column :lgl_repositorios, :dcg, :cdg
  end
end
