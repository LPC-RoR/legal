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
          texto: "Definimos roles, tareas y responsabilidades junto a su canal de denuncias, " \
                 "e incorporamos las particularidades de su empresa al protocolo de trabajo conjunto."
        },
        {
          numero: 2,
          titulo: "Recepción de la carpeta de investigación",
          texto: "Nuestro servicio se inicia con la recepción de la carpeta de investigación " \
                 "resultante de la recepción de la denuncia, incluido el trámite de informar el " \
                 "inicio de la investigación a la Dirección del Trabajo."
        },
        {
          numero: 3,
          titulo: "Investigación realizada por un abogado especializado",
          texto: "Nuestro investigador asignado evalúa la denuncia, cita y toma declaraciones a " \
                 "los participantes. Finalmente redacta el informe conforme a los estándares del reglamento."
        },
        {
          numero: 4,
          titulo: "Depósito en la plataforma DT",
          texto: "Entregamos los archivos PDF requeridos para cada trámite y el informe listo " \
                 "para su depósito en la plataforma de la Dirección del Trabajo."
        },
        {
          numero: 5,
          titulo: "Pronunciamiento de la Dirección del Trabajo",
          texto: "Si la Dirección del Trabajo se pronuncia, le entregamos asesoría legal frente a " \
                 "sus eventuales observaciones y activamos la aplicación de las medidas correctivas " \
                 "y sanciones, si corresponde."
        },
        {
          numero: 6,
          titulo: "Aplicación de medidas correctivas y sanciones",
          texto: "Asesoría legal en la redacción de las medidas correctivas y sanciones, con " \
                 "generación y entrega a los participantes a través de nuestra plataforma tecnológica. "
        }
      ]
    end
  end
end