# app/lib/krn_prcdmnt/definicion.rb
module KrnPrcdmnt
  class Definicion < Base
    # Ejemplo de procedimiento "Krn" 
    etapa :etp_rcpcn do

      plazo ->(d) { d.plazo(:etp_rcpcn) }

      # Todos los casos pasan por esta tarea
      tarea 'tsk_ingrs',
            si: ->(d) { d.tsk_ingrs? },
            entonces: ->(d) { d.update!(krn_validada: true) }
            
      # Empresa externa recibe dnnc de principal tsk_drvcn_art4_1
      tarea 'tsk_rdrccn_dnnc',
            si: ->(d) { d.tsk_rdrccn_dnnc? },
            entonces: ->(d) { d.update!(krn_validada: true) }

      tarea 'tsk_mails_crdncn',
            si: ->(d) { d.tsk_mails_crdncn? },
            entonces: ->(d) { d.update!(krn_validada: true) }

      # Empresa externa recibe dnnc de principal tsk_drvcn_art4_1
      tarea 'tsk_dnncnt_info_oblgtr',
            si: ->(d) { d.tsk_dnncnt_info_oblgtr? },
            entonces: ->(d) { d.update!(krn_validada: true) }
      tarea 'tsk_dnncnt_optn_drvcn',
            si: ->(d) { d.tsk_dnncnt_optn_drvcn? },
            entonces: ->(d) { d.update!(krn_validada: true) }
      tarea 'tsk_cmprbnt_rcpcn',
            si: ->(d) { d.tsk_cmprbnt_rcpcn? },
            entonces: ->(d) { d.update!(krn_validada: true) }
      tarea 'tsk_vrfccn_dts_incmbnts',
            si: ->(d) { d.tsk_vrfccn_dts_incmbnts? },
            entonces: ->(d) { d.update!(krn_validada: true) }
      tarea 'tsk_notificar_dnnc',
            si: ->(d) { d.tsk_notificar_dnnc? },
            entonces: ->(d) { d.update!(krn_validada: true) }
      # Empresa externa recibe dnnc de principal tsk_drvcn_art4_1
      tarea 'tsk_mdds_rsgrd',
            si: ->(d) { d.tsk_mdds_rsgrd? },
            entonces: ->(d) { d.update!(krn_validada: true) }
      tarea 'tsk_evidencia_apt',
            si: ->(d) { d.tsk_evidencia_apt? },
            entonces: ->(d) { d.update!(krn_validada: true) }
      # Para alguno de los denunciantes denunciados aplica el artículo 4:1
      tarea 'tsk_emprs_optn_drvcn',
            si: ->(d) { d.tsk_emprs_optn_drvcn? },
            entonces: ->(d) { d.update!(krn_validada: true) }
      tarea 'tsk_cierre_rcpcn',
            si: ->(d) { d.tsk_cierre_rcpcn? },
            entonces: ->(d) { d.update!(krn_validada: true) }
    end

    etapa :etp_invstgcn do
      plazo ->(d) { d.plazo(:etp_invstgcn) }
      tarea 'tsk_asigna_invstgdr',
            si:    ->(d) { d.tsk_asigna_invstgdr? },
            entonces: ->(d) { d.pedir_analisis_krn! }
      tarea 'tsk_analisis_dnnc',
            si:    ->(d) { d.tsk_analisis_dnnc? },
            entonces: ->(d) { d.pedir_analisis_krn! }
      tarea 'tsk_dclrcns',
            si:    ->(d) { d.tsk_dclrcns? },
            entonces: ->(d) { d.pedir_analisis_krn! }
      tarea 'tsk_redaccion_infrm',
            si:    ->(d) { d.tsk_redaccion_infrm? },
            entonces: ->(d) { d.pedir_analisis_krn! }
      tarea 'tsk_cierre_invstgcn',
            si:    ->(d) { d.tsk_cierre_invstgcn? },
            entonces: ->(d) { d.pedir_analisis_krn! }
    end

    etapa :etp_infrm do
      plazo ->(d) { d.plazo(:etp_infrm) }
      tarea 'tsk_infrm',
            si:    ->(d) { d.tsk_infrm? },
            entonces: ->(d) { d.pedir_analisis_krn! }
    end
    etapa :etp_prnncmnt do
      plazo ->(d) { d.plazo(:etp_prnncmnt) }
      tarea 'tsk_prnncmnt',
            si:    ->(d) { d.tsk_prnncmnt? },
            entonces: ->(d) { d.emitir_resolucion_krn! }
    end
    etapa :etp_mdds_sncns do
      plazo ->(d) { d.plazo(:etp_mdds_sncns) }
      tarea 'tsk_mdds_sncns',
            si:    ->(d) { d.tsk_mdds_sncns? },
            entonces: ->(d) { d.emitir_resolucion_krn! }
    end

    etapa :etp_prcdmnt_cerrado do
      plazo ->(d) { nil }
      tarea 'tsk_prcdmnt_trmnd',
            si:    ->(d) { d.tsk_prcdmnt_trmnd? },
            entonces: ->(d) { d.emitir_resolucion_krn! }
    end
  end
end