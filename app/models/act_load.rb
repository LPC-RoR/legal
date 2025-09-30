# app/models/act_load.rb
# frozen_string_literal: true

class ActLoad
  attr_reader :obj, :cdgs, :actns, :archivos, :checks, :realizados, :registros

  delegate :class, :id, to: :obj

  #-----------------------------------------------------------
  # API pública
  #-----------------------------------------------------------

  # Devuelve el hash para un solo objeto (compatible con el formato viejo)
  def self.for(obj)
    new(obj).to_h
  end

  # Devuelve el hash completo para una Denuncia y toda su familia
  def self.for_tree(denuncia)
    ActiveRecord::Base.transaction do
      den = preload_tree(denuncia)

      # Agrupamos todos los act_archivos una sola vez
      archivo_cache = build_archivo_cache(den)

      # Construimos el hash grande
      {}.tap do |h|
        objects_to_visit(den).each do |o|
          h.merge!(new(o, archivo_cache).to_h)
        end
      end
    end
  end

  #-----------------------------------------------------------
  # Instancia
  #-----------------------------------------------------------

  # archivo_cache es opcional; si no viene se calcula internamente
  def initialize(obj, archivo_cache = nil)
    @obj      = obj
    key = "#{obj.class.name}_#{obj.id}"
    @archivos = archivo_cache&.[](key) ||        # ← leemos del cache
              obj.act_archivos.group_by(&:act_archivo)

    @cdgs  = ClssPrcdmnt.archivos_que_aplican(obj)
    @actns = ClssPrcdmnt.acciones_que_aplican(obj)

    @checks     = obj.check_realizados.pluck(:cdg)
    @realizados = obj.check_realizados
    @registros  = obj.pdf_registros
  end

  # Estructura que espera la vista
  def to_h
    act_id = "#{obj.class.name}_#{obj.id}"

    h = {
      cdgs:  cdgs,
      actns: actns,
      o_archvs: [],
      o_accns:  [],
      chcks:  obj.check_auditorias,
      rlzds:  realizados,
      rgstrs: registros
    }

    # Archivos / acciones obligatorias que faltan
    h[:o_archvs] = ClssPrcdmnt.archivos_obligatorios(obj) - archivos.keys - checks
    h[:o_accns]  = ClssPrcdmnt.acciones_obligatorias(obj)  - archivos.keys - checks

    # Archivos por código
    cdgs.each do |c|
      list = archivos[c] || []
      h[c] = ClssPrcdmnt.act_lst?(c) ? list : list.first
    end

    # Archivos por acción
    actns.each do |a|
      list = archivos[a] || []
      h[a] = ClssPrcdmnt.actn_multpl?(a) ? list : list.first
    end

    # Caso especial que ya se usaba en el controlador
    h['infrmcn']    = archivos['infrmcn']    || []
    h['crdncn_apt'] = archivos['crdncn_apt'] || []

    { act_id => h }
  end

  #-----------------------------------------------------------
  # privado
  #-----------------------------------------------------------
  private_class_method :new

  private

  def self.preload_tree(den)
    KrnDenuncia.includes(
      :act_archivos,
      krn_denunciantes: [:act_archivos,
                         :check_auditorias,
                         :check_realizados,
                         :pdf_registros,
                         { krn_testigos: [:act_archivos,
                                          :check_auditorias,
                                          :check_realizados,
                                          :pdf_registros] }],
      krn_denunciados:  [:act_archivos,
                         :check_auditorias,
                         :check_realizados,
                         :pdf_registros,
                         { krn_testigos: [:act_archivos,
                                          :check_auditorias,
                                          :check_realizados,
                                          :pdf_registros] }]
    ).find(den.id)
  end

  def self.build_archivo_cache(den)
    ids = objects_to_visit(den).map { |o| [o.class.name, o.id] }
    ActArchivo
      .where(ownr_type: ids.map(&:first), ownr_id: ids.map(&:last))
      .group_by { |a| ["#{a.ownr_type}_#{a.ownr_id}", a.act_archivo] }
  end

  def self.objects_to_visit(den)
    [den] +
      den.krn_denunciantes +
      den.krn_denunciados +
      den.krn_denunciantes.flat_map(&:krn_testigos) +
      den.krn_denunciados.flat_map(&:krn_testigos)
  end
end