# lib/tasks/migrar_check_realizados.rake
namespace :migrar do
  desc "Migra CheckRealizados (es_karin) a ActArchivo. Usa DRY_RUN=1 para simular."
  task check_realizados_a_act_archivos: :environment do
    dry_run = ENV['DRY_RUN'].present?
    total   = 0
    creados = 0
    errores = 0
    saltados = 0

    # Ajusta esto según tu lógica real de es_karin
    # scope = CheckRealizado.all.select { |cr| es_karin(cr) }
    scope = CheckRealizado.all.select { |cr| ClssCntxt.krn_source?(cr.ownr.class.table_name) }

    puts "=" * 60
    puts "MODO: #{dry_run ? 'SIMULACIÓN (dry_run)' : 'EJECUCIÓN REAL'}"
    puts "Registros a evaluar: #{scope.size}"
    puts "=" * 60

    scope.each do |check|
      total += 1

      if check.ownr.nil?
        saltados += 1
        puts "[SALTADO] CheckRealizado ##{check.id} → ownr es nil para #{check.ownr_type}##{check.ownr_id} | cdg: #{check.cdg}"
        next
      end

      # Preparar atributos
      attrs = {
        ownr:         check.ownr,
        act_archivo:  check.cdg,
        mdl:          'ClssPdfInvstgcns',
        fuente:       check.fuente,
        fecha_envio:  check.fecha_envio,
        crtn_mode:    'upload',
        # Si necesitas evitar validaciones de PDF, descomenta:
        # rlzd: true
      }

      if dry_run
        puts "[DRY RUN] Crearía ActArchivo para CheckRealizado ##{check.id}"
        puts "          atributos: #{attrs.except(:ownr).inspect}"
        if check.pdf.attached?
          puts "          PDF: #{check.pdf.filename} (#{check.pdf.byte_size} bytes)"
        else
          puts "          PDF: no adjunto"
        end
        creados += 1
        next
      end

      begin
        ActArchivo.transaction do
          act = ActArchivo.new(attrs)

          # Copiar PDF si existe (reutiliza el blob, no duplica storage)
          if check.pdf.attached?
            act.pdf.attach(check.pdf.blob)
          end

          if act.save
            creados += 1
            puts "[OK] CheckRealizado ##{check.id} → ActArchivo ##{act.id}"
            puts "     PDF copiado: #{check.pdf.attached? ? 'Sí' : 'No'}"
          else
            errores += 1
            puts "[ERROR] CheckRealizado ##{check.id} no se pudo guardar:"
            puts "        #{act.errors.full_messages.join(', ')}"
            raise ActiveRecord::Rollback
          end
        end
      rescue => e
        errores += 1
        puts "[EXCEPCIÓN] CheckRealizado ##{check.id}: #{e.message}"
        puts e.backtrace.first(3).join("\n")
      end
    end

    puts "=" * 60
    puts "RESUMEN:"
    puts "  Total evaluados: #{total}"
    puts "  Creados:         #{creados}"
    puts "  Saltados (dup):  #{saltados}"
    puts "  Errores:         #{errores}"
    puts "=" * 60
  end
end