class EnableUnaccentExtension < ActiveRecord::Migration[8.0]
  def change
    # Intenta crear la extensión pero continúa si falla
    execute <<-SQL
      DO $$
      BEGIN
        CREATE EXTENSION IF NOT EXISTS unaccent;
      EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE 'No se pudo crear la extensión unaccent: permisos insuficientes';
      END
      $$;
    SQL
  end
end
