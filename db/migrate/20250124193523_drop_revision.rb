class DropRevision < ActiveRecord::Migration[7.1]
  def change
    drop_table :app_mejoras
    drop_table :app_observaciones
    drop_table :app_repos
    drop_table :app_repositorios
    drop_table :causa_docs
    drop_table :causa_hechos
    drop_table :denunciados
    drop_table :hecho_docs
    drop_table :tar_bases
    drop_table :tar_convenios
    drop_table :tar_elementos
    drop_table :tar_horas
    drop_table :tar_liquidaciones
    drop_table :tar_variable_bases
    drop_table :tipo_denunciados
    drop_table :tipo_denuncias
  end
end
