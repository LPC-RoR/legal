# lib/tasks/migrar_codigo_txt_dsgncn.rake
namespace :migrar do
  desc "Cambia codigo 'firma_mdds' → 'txt_firma_mdds' en TxtEditables. Usa DRY_RUN=1."
  task codigo_txt_dsgncn: :environment do
    dry_run = ENV['DRY_RUN'].present?
    total   = 0
    updated = 0
    skipped = 0

    puts "=" * 60
    puts "MODO: #{dry_run ? 'SIMULACIÓN (dry_run)' : 'EJECUCIÓN REAL'}"
    puts "Cambiando codigo: firma_mdds → txt_firma_mdds"
    puts "=" * 60

    # Buscar TxtEditables con codigo 'firma_mdds'
    TxtEditable.where(codigo: 'firma_mdds').find_each do |txt|
      total += 1

      if dry_run
        puts "[DRY RUN] TxtEditable ##{txt.id} → codigo: #{txt.codigo} → txt_firma_mdds"
        updated += 1
        next
      end

      begin
        txt.update!(codigo: 'txt_firma_mdds')
        updated += 1
        puts "[OK] TxtEditable ##{txt.id} → codigo actualizado a txt_firma_mdds"
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