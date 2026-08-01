# lib/tasks/migrar_krn_textos_a_txt_editables.rake
namespace :migrar do
  desc "Migra KrnTexto → TxtEditable para ownrs que cumplan ClssCntxt.krn_source?. Usa DRY_RUN=1 para simular."
  task krn_textos_a_txt_editables: :environment do
    dry_run   = ENV['DRY_RUN'].present?
    total     = 0
    creados   = 0
    saltados  = 0
    errores   = 0

    puts "=" * 70
    puts "MODO: #{dry_run ? 'SIMULACIÓN (dry_run)' : 'EJECUCIÓN REAL'}"
    puts "=" * 70

    KrnTexto.find_each do |krn|
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

      total += 1

      # Atributos base (campos de igual nombre + cntxt_clss)
      attrs = {
        ownr_type:  krn.ownr_type,
        ownr_id:    krn.ownr_id,
        codigo:     krn.codigo,
        titulo:     krn.titulo,
        cntxt_clss: 'ClssTxtInvstgcns',
        created_at: krn.created_at,
        updated_at: krn.updated_at
      }

      if dry_run
        preview = krn.contenido.to_plain_text.truncate(60).gsub(/\n/, ' ')
        puts "[DRY RUN] KrnTexto ##{krn.id} → TxtEditable"
        puts "          attrs: #{attrs.except(:ownr_type, :ownr_id).inspect}"
        puts "          contenido preview: #{preview.inspect}"
        creados += 1
        next
      end

      begin
        TxtEditable.transaction do
          txt = TxtEditable.new(attrs)

          # Copia el ActionText. Esto crea el registro en action_text_rich_texts
          # asociado al nuevo TxtEditable.
          txt.contenido = krn.contenido

          if txt.save
            creados += 1
            puts "[OK] KrnTexto ##{krn.id} → TxtEditable ##{txt.id} | codigo: #{txt.codigo}"
          else
            errores += 1
            puts "[ERROR] KrnTexto ##{krn.id}: #{txt.errors.full_messages.join('; ')}"
            raise ActiveRecord::Rollback
          end
        end
      rescue => e
        errores += 1
        puts "[EXCEPCIÓN] KrnTexto ##{krn.id}: #{e.class} - #{e.message}"
        puts e.backtrace.first(3).join("\n")
      end
    end

    puts "=" * 70
    puts "RESUMEN"
    puts "  Evaluados (cumplen krn_source?): #{total}"
    puts "  Creados:                        #{creados}"
    puts "  Saltados (dup/ausente/no aplica): #{saltados}"
    puts "  Errores:                        #{errores}"
    puts "=" * 70
  end
end