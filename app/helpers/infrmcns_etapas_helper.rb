module InfrmcnsEtapasHelper
  def etapa_nombre(key)
    {
      'etp_rcpcn'      => 'Recepción',
      'etp_invstgcn'   => 'Investigación',
      'etp_infrm'      => 'Informe',
      'etp_prnncmnt'   => 'Pronunciamiento',
      'etp_mdds_sncns' => 'Medidas/Sanciones',
      'etp_cerrada'    => 'Cerrada'
    }[key] || key
  end

  def stepper_classes(denuncia, etapa_key)
    is_current = (denuncia.etapa == etapa_key)
    idx_actual = KrnDenuncia::ETAPAS.index(denuncia.etapa)
    idx_target = KrnDenuncia::ETAPAS.index(etapa_key)
    is_next = (idx_target == idx_actual + 1)
    is_prev = (idx_target == idx_actual - 1)

    classes = []
    classes << 'active'        if is_current
    classes << 'enabled-next'  if is_next  && denuncia.puede_avanzar?
    classes << 'enabled-prev'  if is_prev  && current_usuario.admin?
    classes.join(' ')
  end
end