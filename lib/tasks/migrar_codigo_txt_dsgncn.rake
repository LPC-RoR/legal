# lib/tasks/migrar_codigo_txt_dsgncn.rake
namespace :migrar do
  desc "Cambia codigo 'txt_dsgncn' → 'txt_invstgdr_dsgncn' en TxtEditables vía ActReferencia. Usa DRY_RUN=1."
  task codigo_txt_dsgncn: :environment do
    dry_run = ENV['DRY_RUN'].present?
    total   = 0
    updated = 0
    skipped = 0

    puts "=" * 60
    puts "MODO: #{dry_run ? 'SIMULACIÓN (dry_run)' : 'EJECUCIÓN REAL'}"
    puts "Cambiando codigo: txt_dsgncn → txt_invstgdr_dsgncn"
    puts "=" * 60

    # Buscar TxtEditables con codigo 'txt_dsgncn' que estén referenciados por ActReferencia
    TxtEditable.where(codigo: 'txt_dsgncn').find_each do |txt|
      total += 1

      # Verificar que tenga al menos una ActReferencia (opcional, para confirmar contexto)
      unless ActReferencia.exists?(ref_type: 'TxtEditable', ref_id: txt.id)
        skipped += 1
        puts "[SALTADO] TxtEditable ##{txt.id} → sin ActReferencia asociada"
        next
      end

      if dry_run
        puts "[DRY RUN] TxtEditable ##{txt.id} → codigo: #{txt.codigo} → txt_invstgdr_dsgncn"
        updated += 1
        next
      end

      begin
        txt.update!(codigo: 'txt_invstgdr_dsgncn')
        updated += 1
        puts "[OK] TxtEditable ##{txt.id} → codigo actualizado a txt_invstgdr_dsgncn"
      rescue => e
        puts "[ERROR] TxtEditable ##{txt.id}: #{e.message}"
      end
    end

    puts "=" * 60
    puts "RESUMEN"
    puts "  Evaluados:  #{total}"
    puts "  Actualizados: #{updated}"
    puts "  Saltados:   #{skipped}"
    puts "=" * 60
  end
end