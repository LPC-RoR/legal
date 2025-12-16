class ClssTarifa < ApplicationRecord

  CMNTRS = {
    tar_pagos: {
    	monto_fijo: [
	    	{cdg: 'menos_180uf',	frml: 'cmntr',					si: ->(causa, pago) { causa.ttl_tarifa_uf(pago.codigo_formula) <= 180 }},
	    	{cdg: 'menos_12uf',		frml: 'cmntr',					si: ->(causa, pago) { causa.ttl_tarifa_uf(pago.codigo_formula) <= 180 && ( causa.ttl_tarifa_uf(pago.codigo_formula) * 0.1 < 12 ) }},
	    	{cdg: 'mas_12uf',			frml: 'cmntr',					si: ->(causa, pago) { causa.ttl_tarifa_uf(pago.codigo_formula) <= 180 && ( causa.ttl_tarifa_uf(pago.codigo_formula) * 0.1 >= 12 ) }},
	    	{cdg: 'mas_180uf',		frml: 'cmntr',					si: ->(causa, pago) { causa.ttl_tarifa_uf(pago.codigo_formula) > 180 }},
	    	{cdg: 'menos_27_5uf',	frml: 'cmntr',					si: ->(causa, pago) { causa.ttl_tarifa_uf(pago.codigo_formula) > 180 && ( causa.ttl_tarifa_uf(pago.codigo_formula) * 0.08 < 27.5 ) }},
	    	{cdg: 'mas_50uf',			frml: 'cmntr',					si: ->(causa, pago) { causa.ttl_tarifa_uf(pago.codigo_formula) > 180 && ( causa.ttl_tarifa_uf(pago.codigo_formula) * 0.08 > 50 ) }},
	    	{cdg: 'en_rango',			frml: 'cmntr',					si: ->(causa, pago) { causa.ttl_tarifa_uf(pago.codigo_formula) > 180 && ( causa.ttl_tarifa_uf(pago.codigo_formula) * 0.08 >= 27.5 && causa.ttl_tarifa_uf(pago.codigo_formula) * 0.08 <= 50 ) }},

	    	{cdg: 'cuantia', 			frml: 'ttl_tarifa',						si: ->(causa, pago) { true }},
	    	{cdg: 'cuantia_uf', 	frml: 'ttl_tarifa_uf',				si: ->(causa, pago) { pago.requiere_uf }},
	    	{cdg: '10_prcnt',			frml: 'ttl_tarifa_uf * 0.1',	si: ->(causa, pago) { causa.ttl_tarifa_uf(pago.codigo_formula) <= 180 }},
	    	{cdg: '8_prcnt',			frml: 'ttl_tarifa_uf * 0.08',	si: ->(causa, pago) { causa.ttl_tarifa_uf(pago.codigo_formula) > 180 }}
    	],
    	monto_variable: [
	    	{cdg: 'cuantia', 			frml: 'ttl_tarifa',				si: ->(causa, pago) { true }},
	    	{cdg: 'monto_pagado', frml: 'monto_pagado',			si: ->(causa, pago) { causa.monto_pagado.present? }},
	    	{cdg: 'ahorro', 			frml: 'ahorro',						si: ->(causa, pago) { causa.monto_pagado.present? }},
	    	{cdg: 'variable', 		frml: 'variable',					si: ->(causa, pago) { causa.monto_pagado.present? }},
	    	{cdg: 'fijo', 				frml: 'fijo',							si: ->(causa, pago) { causa.monto_pagado.present? }},
    	]
    }
  }.freeze

  def self.cmntrs
  	{
  		'menos_180uf'	=> 'Cuantía menor de UF 180: aplica el valor máximo entre el 10% de la cuantía y 12 UF.',
  		'menos_12uf'	=> 'El 10% de la cuantía es menor a UF 12, se aplica el mínimo de UF 12.',
  		'mas_12uf'		=> 'El 10% de la cuantía es mayor o igual al mínimo de UF 12, aplica el 10% de la cuantía.',
  		'mas_180uf'		=> 'Cuantía mayor de UF 180: aplica 8% de la cuantía, con un piso de UF 27,5 y un máximo de UF 50.',
  		'menos_27_5uf'	=> 'El 8% de la cuantía es menor a UF 27,5 : aplica mínimo de UF 27,5.',
  		'mas_50uf'		=> 'El 8% cuantía es mayor que UF 50 : aplica máximo de UF 50.',
  		'en_rango'		=> 'El 8% de la cuantía se encuentra en el rango [UF 27.5, UF 50] : aplica 8% cuantía.',

  		'cuantia'		=> 'Cuantía en pesos ( tarifa )',
  		'cuantia_uf'	=> 'Cuantía en UF ( tarifa )',
  		'10_prcnt'		=> '10% de la cuantía en UF',
  		'8_prcnt'		=> '8% de la cuantía en UF',

  		'monto_pagado'	=> 'Monto pagado al trabajador',
  		'ahorro'		=> 'Ahorro',
  		'variable'		=> 'Total variable',
  		'fijo'			=> 'Monto fijo'
  	}
  end

  def self.formato
  	{
  		'cuantia'		=> 'Pesos',
  		'cuantia_uf'	=> 'UF',
  		'10_prcnt'		=> 'UF',
  		'8_prcnt'		=> 'UF',
  		'monto_pagado'	=> 'Pesos',
  		'ahorro'		=> 'Pesos',
  		'variable'		=> 'Pesos',
  		'fijo'			=> 'Pesos'
  	}
  end

  def self.cmntrs_que_aplican(causa, pago)
    CMNTRS[:tar_pagos][pago.codigo_formula.to_sym].select { |r| r[:si].call(causa, pago) }
                                     .map { |r| [r[:cdg], r[:frml]] }
  end

end