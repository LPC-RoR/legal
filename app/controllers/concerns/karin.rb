module Karin
  extend ActiveSupport::Concern

  # --------------------------------------------------------------------------------------------- GENERAL

  #Control de despliegue de Archivos

  def krn_cntrl(denuncia)
    {
      'krn_denuncia' => denuncia.tipo_declaracion != 'Verbal',
      'krn_acta' => denuncia.tipo_declaracion == 'Verbal',
      'krn_certificado' => denuncia.dnnte_derivacion != true,
      'krn_notificacion' => denuncia.invstgdr_dt?,
      'krn_dnncnt_diat_diep' => true,
      'krn_corregida' => (denuncia.dnnc_errr?),
      'krn_dnncnt_dclracn' => true,
      'krn_dnncd_dclracn' => true,
      'krn_antcdnt_objcn' => true,
      'krn_dnncd_antcdnts' => true,
      'krn_dnncnt_antcdnts' => true,
      'krn_tstg_dclrcn' => true,
      'krn_tstg_antcdnt' => true,
      'krn_informe' => true,
      'krn_crtfcd_infrm' => true,
      'krn_pronunciamiento' => true,
      'krn_impugnacion' => true
    }
  end

  def load_dc_fl_hsh(denuncia)

    @dc_fl_hsh = {}
    ['KrnDenuncia', 'KrnDenunciante','KrnDenunciado'].each do |mdl|
      @dc_fl_hsh[mdl] = {}
      @dc_fl_hsh['KrnTestigo'] = {}

      if mdl == 'KrnDenuncia'
        @dc_lst[mdl].each do |dc|
          @dc_fl_hsh[mdl][dc.codigo] = {}
          @dc_fl_hsh[mdl][dc.codigo][:dc] = KrnDenuncia.doc_cntrlds.get_archv(dc.codigo)
          if dc.multiple == true
            @dc_fl_hsh[mdl][dc.codigo][:fl] = denuncia.rep_archivos.where(rep_doc_controlado_id: dc.id).updtd_ordr
          else
            @dc_fl_hsh[mdl][dc.codigo][:fl] = denuncia.rep_archivos.get_dc_archv( @dc_fl_hsh[mdl][dc.codigo][:dc] )
          end
        end
      else
        denuncia.send(mdl.tableize).each do |rcrd|
          @dc_fl_hsh[mdl][rcrd.id] = {}
          @dc_lst[mdl].each do |dc|
            @dc_fl_hsh[mdl][rcrd.id][dc.codigo] = {}
            @dc_fl_hsh[mdl][rcrd.id][dc.codigo][:dc] = mdl.constantize.doc_cntrlds.get_archv(dc.codigo)
            if dc.multiple == true
              @dc_fl_hsh[mdl][rcrd.id][dc.codigo][:fl] = rcrd.rep_archivos.where(rep_doc_controlado_id: dc.id).updtd_ordr
            else
              @dc_fl_hsh[mdl][rcrd.id][dc.codigo][:fl] = rcrd.rep_archivos.get_dc_archv( @dc_fl_hsh[mdl][rcrd.id][dc.codigo][:dc] )
            end
          end

          rcrd.krn_testigos.each do |tstg|
            @dc_fl_hsh['KrnTestigo'][tstg.id] = {}
            @dc_lst['KrnTestigo'].each do |dc|
              @dc_fl_hsh['KrnTestigo'][tstg.id][dc.codigo] = {}
              @dc_fl_hsh['KrnTestigo'][tstg.id][dc.codigo][:dc] = KrnTestigo.doc_cntrlds.get_archv(dc.codigo)
              if dc.multiple == true
                @dc_fl_hsh['KrnTestigo'][tstg.id][dc.codigo][:fl] = tstg.rep_archivos.where(rep_doc_controlado_id: dc.id).updtd_ordr
              else
                @dc_fl_hsh['KrnTestigo'][tstg.id][dc.codigo][:fl] = tstg.rep_archivos.get_dc_archv( @dc_fl_hsh['KrnTestigo'][tstg.id][dc.codigo][:dc] )
              end

            end
          end

        end
      end
    end

  end

  # --------------------------------------------------------------------------------------------- DENUNCIAS

  def krn_dnnc_dc_init(denuncia)
    @krn_cntrl = krn_cntrl(@objeto)

    @dc_lst = {}
    @dc_lst['KrnDenuncia'] = KrnDenuncia.doc_cntrlds
    @dc_lst['KrnDenunciante'] = KrnDenunciante.doc_cntrlds
    @dc_lst['KrnDenunciado'] = KrnDenunciado.doc_cntrlds
    @dc_lst['KrnTestigo'] = KrnTestigo.doc_cntrlds

    load_dc_fl_hsh(denuncia)

  end

  # --------------------------------------------------------------------------------------------- DERIVACIÓN

  def drvcn_mtv
    {
      'riohs' => 'RIOHS con protocolo no ha entrado en vigencia.',
      'a41' => 'Aplica artículo 4 inciso primero del Código del trabajo.',
      'seg' => 'Seguimiento de denuncia de empresa externa.',
      'r_multi' => 'Recepción derivación de denuncia multi-empresa.',
      'd_optn' => 'Por determinación del denunciante',
      'e_optn' => 'Por determinación de la empresa'
    }
  end


end