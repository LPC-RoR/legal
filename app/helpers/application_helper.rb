module ApplicationHelper

  def artcls_hsh
    {
      costos: {
        image_url: image_url('artcls/costos_1200.jpg'),
        title: 'Los costos del incumplimiento',
        description: 'Crear un canal de denuncias, diseñar e implementar medidas de resguardo, contar con -al menos- un investigador con las competencias necesarias, cumplir con las exigencias formales de una investigación, entre otros, son desafíos aún presentes tras un año de vigencia de la ley. Su implementación o perfeccionamiento en el tiempo, si bien tendrá estándares distintos en cada empresa, buscará siempre satisfacer una exigencia mínima: evitar los costos asociados al incumplimiento de la ley.'.truncate(160),
        type: 'article',
      },
      externalizacion: {
        image_url: image_url('artcls/extrnlzcn_1200.jpg'),
        title: 'Externalizacion de investigaciones',
        description: 'La externalización de investigaciones es la modalidad en la cual se delega a una empresa externa la realización de la investigación. Si bien, solo es posible utilizarla en los casos investigados por la propia empresa, puede ser una buena alternativa dadas sus ventajas financieras y operativas.'.truncate(160),
        type: 'article',
      }
    }
  end

end