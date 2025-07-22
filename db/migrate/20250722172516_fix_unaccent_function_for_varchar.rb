class FixUnaccentFunctionForVarchar < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION public.unaccent(varchar)
      RETURNS text AS $$
        SELECT public.unaccent($1::text)
      $$ LANGUAGE sql IMMUTABLE STRICT;
    SQL
  end

  def down
    execute "DROP FUNCTION IF EXISTS public.unaccent(varchar)"
  end
end
