# lib/tasks/migrar_act_referencias_krn_a_txt.rake
namespace :migrar do
  desc "Reapunta ActReferencias de KrnTexto a TxtEditable. Usa DRY_RUN=1 para simular."
  task act_referencias_krn_a_txt: :environment do
    dry_run  = ENV['DRY_RUN'].present?
    total    = 0
    updated  = 0
    removed  = 0
    skipped  = 0
    saltados = 0
    errors   = 0

    puts "=" * 70
    puts "MODO: #{dry_run ? 'SIMULACIÓN (dry_run)' : 'EJECUCIÓN REAL'}"
    puts "Reapuntando ActReferencias: KrnTexto → TxtEditable"
    puts "=" * 70

    ActReferencia.where(ref_type: 'KrnTexto').find_each do |ref|
      total += 1

      # 1. Recuperar el KrnTexto original
      krn = KrnTexto.find_by(id: ref.ref_id)
      unless krn
        skipped += 1
        puts "[SALTADO] ActReferencia ##{ref.id} → KrnTexto ##{ref.ref_id} ya no existe"
        next
      end

      # 1. Ownr debe existir
      unless krn.ownr.present?
        saltados += 1
        puts "[SALTADO] KrnTexto ##{krn.id} → ownr ausente (#{krn.ownr_type}##{krn.ownr_id})"
        next
      end

      # 2. Ownr debe cumplir la condición de contexto
      unless ClssCntxt.krn_source?(krn.ownr.class.table_name)
        saltados += 1
        next
      end

      # 2. Buscar el TxtEditable equivalente (mismo origen + código)
      txt = TxtEditable.find_by(
        ownr_type: krn.ownr_type,
        ownr_id:   krn.ownr_id,
        codigo:    krn.codigo
      )

      unless txt
        errors += 1
        puts "[ERROR] ActReferencia ##{ref.id} → No hay TxtEditable para KrnTexto ##{krn.id} (#{krn.ownr_type}##{krn.ownr_id}, codigo: #{krn.codigo})"
        next
      end

      # 3. ¿Ya existe una referencia a ese mismo TxtEditable para este archivo?
      existing = ActReferencia.find_by(
        act_archivo_id: ref.act_archivo_id,
        ref_type:       'TxtEditable',
        ref_id:         txt.id
      )

      if existing
        if dry_run
          puts "[DRY RUN] ActReferencia ##{ref.id} → duplicado de ##{existing.id}. Se eliminaría."
          removed += 1
        else
          ref.destroy!
          removed += 1
          puts "[ELIMINADO] ActReferencia ##{ref.id} → duplicado de ##{existing.id} (TxtEditable ##{txt.id})"
        end
        next
      end

      # 4. Actualizar la referencia
      if dry_run
        puts "[DRY RUN] ActReferencia ##{ref.id} → KrnTexto ##{krn.id} → TxtEditable ##{txt.id}"
        updated += 1
        next
      end

      begin
        ref.update!(ref_type: 'TxtEditable', ref_id: txt.id)
        updated += 1
        puts "[OK] ActReferencia ##{ref.id} → ahora apunta a TxtEditable ##{txt.id} (era KrnTexto ##{krn.id})"
      rescue => e
        errors += 1
        puts "[ERROR] ActReferencia ##{ref.id}: #{e.class} - #{e.message}"
      end
    end

    puts "=" * 70
    puts "RESUMEN"
    puts "  Total evaluadas: #{total}"
    puts "  Actualizadas:    #{updated}"
    puts "  Eliminadas:     #{removed} (duplicados)"
    puts "  Saltadas:        #{skipped} (KrnTexto inexistente)"
    puts "  Errores:         #{errors}"
    puts "=" * 70
  end
end