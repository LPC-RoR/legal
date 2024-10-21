# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )

    # palabras terminadas en 'a', no agregue las otras vocales porque no hay problema

#    inflect.clear :all

#    inflect.plural /([^djlnrs])([A-Z]|_|$)/, '\1s\2'
#    inflect.plural /([djlnrs])([A-Z]|_|$)/, '\1es\2'
#    inflect.plural /(.*)z([A-Z]|_|$)$/i, '\1ces\2'

#    inflect.singular /([^djlnrs])s([A-Z]|_|$)/, '\1\2'
#    inflect.singular /([djlnrs])es([A-Z]|_|$)/, '\1\2'
#    inflect.singular /(.*)ces([A-Z]|_|$)$/i, '\1z\2'

    inflect.plural /([ti]a)$/i, '\1s'

    inflect.singular /([icvs]e)s$/i, '\1'

    # palabras terminadas en 'or' {'investigador', 'autor'} y en 'en' {origen}
    inflect.plural /(.[aeiou][drnsl])$/i, '\1es'
    inflect.singular /(.[aeiou][drnsl])es$/i, '\1'

    # raiz
    inflect.plural /(rai)z$/i, '\1ces'
    inflect.singular /(rai)ces$/i, '\1z'

    # Agregado porque la regla sigueinte no sirve para "base"    
    inflect.plural 'base', 'bases'
    inflect.plural 'Base', 'Bases'
    inflect.singular 'bases', 'base'
    inflect.singular 'Bases', 'Base'

    inflect.irregular 'nota', 'notas'
    inflect.irregular 'pauta', 'pautas'
    inflect.irregular 'pregunta', 'preguntas'
    inflect.irregular 'respuesta', 'respuestas'
    inflect.irregular 'lgl_cita', 'lgl_citas'
    inflect.irregular 'denuncia', 'denuncias'
    inflect.irregular 'dt_tramo_multa', 'dt_tramo_multas'
    inflect.irregular 'cuenta', 'cuentas'
end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end
