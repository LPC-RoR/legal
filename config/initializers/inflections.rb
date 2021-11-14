# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )

    # palabras terminadas en 'or' {'investigador', 'autor'} y en 'en' {origen}
    inflect.plural /(.[aeiou][drnsl])$/i, '\1es'
    inflect.singular /(.[aeiou][drnsl])es$/i, '\1'

    # palabras terminadas en 'a', no agregue las otras vocales porque no hay problema
    inflect.plural /([ti]a)$/i, '\1s'

    inflect.singular /([icv]e)s$/i, '\1'

    # raiz
    inflect.plural /(rai)z$/i, '\1ces'
    inflect.singular /(rai)ces$/i, '\1z'
end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end
