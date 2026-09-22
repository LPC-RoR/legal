# app/helpers/aplicacion/home_helper.rb
module Aplicacion
  module HomeHelper
    # Etapas del servicio mostradas en la sección "Cómo funciona".
    # Redacción alineada con la sección "El procedimiento completo" de /metodologia.
    def pasos
      [
        {
          numero: 1,
          titulo: "Taller de puesta en marcha",
          texto: "Antes de iniciar el servicio, realizamos un taller con las personas que participarán en la gestión de las denuncias, destinado a implementar el modelo de trabajo y coordinar la actuación de ambos equipos."
        },
        {
          numero: 2,
          titulo: "Recepción de la denuncia",
          texto: "Recibimos la denuncia, considerando la forma en que fue presentada, la suficiencia de sus antecedentes y cualquier aspecto que deba ser complementado. Asimismo, apoyamos la ejecución oportuna de las actuaciones que correspondan dentro de los primeros tres días, para dar correcto inicio al procedimiento."
        },
        {
          numero: 3,
          titulo: "Investigación a cargo de abogado especialista",
          texto: "Nuestro investigador asignado evalúa la denuncia, cita y toma declaraciones a " \
                 "los participantes. Finalmente redacta el informe conforme a los estándares del reglamento."
        },
        {
          numero: 4,
          titulo: "Expediente preparado para su presentación ante la DT",
          texto: "Entregamos el expediente completo, con toda la información requerida por la Dirección del Trabajo (informe de investigación y antecedentes correspondientes), organizado y preparado en el formato exigido para su carga en la plataforma de la DT."
        },
        {
          numero: 5,
          titulo: "Seguimiento y control de plazos",
          texto: "Mantenemos informada a la empresa sobre el estado de avance de la investigación y las etapas cumplidas, resguardando en todo momento la confidencialidad de su contenido. Asimismo, efectuamos un seguimiento permanente de los plazos y alertamos oportunamente sobre las actuaciones que corresponda realizar."
        },
        {
          numero: 6,
          titulo: "Pronunciamiento de la Dirección del Trabajo",
          texto: "Una vez recibido el pronunciamiento de la Dirección del Trabajo, analizamos su contenido e informamos a la empresa sus alcances y las actuaciones que corresponda adoptar para dar continuidad y cierre al procedimiento."
        }
      ]
    end

    def riesgos
      [
        {
          icono: 'bi-bank',
          titulo: 'Judicialización del caso',
          texto: 'Una investigación mal ejecutada expone a la empresa a reclamos ante los tribunales. Nuestro procedimiento está diseñado para entregar solidez y respaldo a la investigación ante una eventual revisión judicial.'
        },
        {
          icono: 'bi-person-check',
          titulo: 'Independencia e imparcialidad',
          texto: 'Contar con un investigador externo y especialista en la Ley 21.643 aporta independencia, objetividad y una mirada especializada al proceso, fortaleciendo la confianza de las partes y la solidez de la investigación.'
        },
        {
          icono: 'bi-speedometer2',
          titulo: 'Eficiencia y optimización de recursos',
          texto: 'Las investigaciones internas involucran costos que no siempre son visibles, especialmente el tiempo y los recursos de Recursos Humanos. Externalizar libera capacidad interna y la destina a funciones estratégicas del área.'
        }
      ]
    end

  end
end