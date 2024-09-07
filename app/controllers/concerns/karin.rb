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
      'krn_dnncnt_diat_diep' => true
    }
  end

  def load_dnnc_hsh(denuncia, lst)
    @krn_dc = {}
    @krn_fl = {}
    lst.each do |dc|
      @krn_dc[dc.codigo] = KrnDenuncia.doc_cntrlds.get_archv(dc.codigo)
      @krn_fl[dc.codigo] = denuncia.rep_archivos.get_dc_archv(@krn_dc[dc.codigo])
    end
  end

  def load_dnncnt_hsh(denuncia, lst)
    @krn_dnncnt_dc = {}
    @krn_dnncnt_fl = {}

    denuncia.krn_denunciantes.each do |dnncnt|
      lst.each do |dc|
        @krn_dnncnt_dc[dnncnt.id] = {}
        @krn_dnncnt_dc[dnncnt.id][dc.codigo] = KrnDenunciante.doc_cntrlds.get_archv(dc.codigo)
        @krn_dnncnt_fl[dnncnt.id] = {}
        @krn_dnncnt_fl[dnncnt.id][dc.codigo] = dnncnt.rep_archivos.get_dc_archv(@krn_dnncnt_dc[dnncnt.id][dc.codigo])
      end
    end
  end

  def load_dnncd_hsh(denuncia, lst)
    @krn_dnncd_dc = {}
    @krn_dnncd_fl = {}

    denuncia.krn_denunciados.each do |dnncd|
      lst.each do |dc|
        @krn_dnncd_dc[dnncd.id] = {}
        @krn_dnncd_dc[dnncd.id][dc.codigo] = KrnDenunciado.doc_cntrlds.get_archv(dc.codigo)
        @krn_dnncd_fl[dnncd.id] = {}
        @krn_dnncd_fl[dnncd.id][dc.codigo] = dnncd.rep_archivos.get_dc_archv(@krn_dnncd_dc[dnncd.id][dc.codigo])
      end
    end
  end

  # --------------------------------------------------------------------------------------------- DENUNCIAS

  def krn_dnnc_dc_init(denuncia)
    @krn_cntrl = krn_cntrl(@objeto)

    @krn_dnnc_dc_lst = KrnDenuncia.doc_cntrlds
    load_dnnc_hsh(@objeto, @krn_dnnc_dc_lst)

    @krn_dnncnt_dc_lst = KrnDenunciante.doc_cntrlds
    load_dnncnt_hsh(@objeto, @krn_dnncnt_dc_lst)

    @krn_dnncd_dc_lst = KrnDenunciado.doc_cntrlds
    load_dnncd_hsh(@objeto, @krn_dnncd_dc_lst)

    @entdd_invstgdr = @objeto.entdd_invstgdr
  end

  # --------------------------------------------------------------------------------------------- DERIVACIÓN

  def drvcn_mtv
    {
      'riohs' => 'RIOHS con protocolo no ha entrado en vigencia.',
      'a41' => 'Aplica artículo 4 inciso primero del Código del trabajo.',
      'seg' => 'Seguimiento de denuncia de empresa externa.',
      'r_multi' => 'Recepción derivación de denuncia multi-empresa.',
      'e_optn' => 'Por determinación de la empresa'
    }
  end

  def qstns_txts
    {
      'riohs' => {
        qstn: 'RIOHS que incluye el procedimiento de investigación y sanción NO está vigente',
        answ: nil
      },
      'a41' => {
        qstn: 'Aplica artículo 4 inciso primero del Código del trabajo.',
        answ: nil
      },
      'i_optns' => {
        qstn: 'Informar al denunciante su opciones de derivación (investigación).',
        answ: 'Denunciante ya fue informado de sus opciones de investigación (derivación).'
      },
      'externa' => {
        qstn: 'Denunciante define opción derivación denuncia empresa externa',
        answ: nil
      },
      'd_optn' => {
        qstn: 'Denunciante define opción derivación denuncia empresa/multi',
        answ: 'Denunciante opto por investigación en '
      },
      'e_optn' => {
        qstn: 'Empresa define opción derivación denuncia empresa/multi',
        answ: 'Empresa opto por investigación en '
      },
      'seg' => {
        qstn: 'Recepción derivación de denuncia empresa externa',
        answ: nil
      },
      'r_multi' => {
        qstn: 'Recepción derivación de denuncia multi empresa',
        answ: nil
      },
    }
  end

end