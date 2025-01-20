class DropLotOfFiles < ActiveRecord::Migration[7.1]
  def change
    drop_table :app_administradores
    drop_table :age_act_perfiles
    drop_table :age_usu_perfiles
    drop_table :alcance_denuncias
    drop_table :app_control_documentos
    drop_table :dependencia_denunciantes
    drop_table :hlp_pasos
    drop_table :hlp_tutoriales
    drop_table :krn_motivo_derivaciones
    drop_table :sb_elementos
    drop_table :sb_listas
    drop_table :st_perfil_estados
    drop_table :st_perfil_modelos
  end
end
