module Tarifas
	extend ActiveSupport::Concern

	# ------------------------------------------------------------------- CALCULA



	# **************************** Métodos usados para la evaluación y el despliegue de pagos
	def chck_cuantia(tar_valor_cuantia, tipo)
		formula = tipo == 'real' ? tar_valor_cuantia.formula : tar_valor_cuantia.formula_honorarios
		valor = tipo == 'real' ? tar_valor_cuantia.valor : tar_valor_cuantia.valor_tarifa
		valor.blank? ? 'formula' : ( formula.blank? ? 'campo' : valor == calcula2(formula, tar_valor_cuantia.ownr, nil) ? 'ok' : 'fail' )
	end

	def chck_tarifa(tar_valor_cuantia)
		tarifa = vlr_tarifa(tar_valor_cuantia)
		tarifa == 0 ? chck_cuantia(tar_valor_cuantia, 'real') : chck_cuantia(tar_valor_cuantia, 'tarifa')
	end

	# -----------------------------------------------------------------------------------------------------------------
	# ----------------------------------------------------------------------------------------------------- Versión 2.0
	# ----------------------------------------------------------------------------------------------------- Cuantía

	# Versión 2.0
	# VALORES de tar_valor cuantia que sirven para despliegue sin necesidad de otras variables
	# tipo : { 'real', 'tarifa'}
	def vlr_cuantia(tar_valor_cuantia, tipo)
		formula = tipo == 'real' ? tar_valor_cuantia.formula : tar_valor_cuantia.formula_honorarios
		valor_r = tar_valor_cuantia.valor.nil? ? 0 : tar_valor_cuantia.valor
		valor_t = tar_valor_cuantia.valor_tarifa.nil? ? 0 : tar_valor_cuantia.valor_tarifa
		valor = tipo == 'real' ? valor_r : valor_t
		if /\$Remuneración/.match?(formula)
			demandante = tar_valor_cuantia.demandante
			rem = demandante.blank? ? 0 : demandante.remuneracion
			formula = formula.gsub('$Remuneración', rem.to_s)
		end
		valor.blank? ? ( formula.blank? ? 0 : calcula2(formula, tar_valor_cuantia.ownr, nil) ) : valor
	end

	# Versión 2.0
	def vlr_tarifa(tar_valor_cuantia)
		tarifa_t = tar_valor_cuantia.nil? ? 0 : vlr_cuantia(tar_valor_cuantia, 'tarifa')
		tarifa_r = tar_valor_cuantia.nil? ? 0 : vlr_cuantia(tar_valor_cuantia, 'real')
		tarifa_t == 0 ? tarifa_r : tarifa_t
	end

	# Versión 2.0
	def get_total_cuantia(ownr, tipo)
		ownr.nil? ? 0 : (tipo == 'real' ? ownr.tar_valor_cuantias.map {|vlr_cnt| vlr_cuantia(vlr_cnt, 'real')}.sum : ownr.tar_valor_cuantias.map {|vlr_cnt| vlr_tarifa(vlr_cnt)}.sum)
	end

	# ----------------------------------------------------------------------------------------------------- Pagos
	def get_tar_uf_facturacion_pago(ownr, pago)
		ownr.class.name == 'Causa' ? ownr.tar_uf_facturaciones.find_by(tar_pago_id: pago.id) : nil
	end

	# Versión 2.0
	def get_tar_calculo_pago(ownr, pago)
		ownr.class.name == 'Causa' ? ownr.tar_calculos.find_by(tar_pago_id: pago.id) : ownr.tar_calculo
	end

	# Versión 2.0
	def get_tar_facturacion_pago(ownr, pago)
		ownr.tar_facturaciones.find_by(tar_pago_id: pago.id)
	end

	# Version 2.0
	# Fecha de cálculo, se usa para la UF o para mostrarla
	# Se aplica a Tarifas con pago
	def get_fecha_calculo_pago(ownr, pago)
		objt = get_objt_calculo_pago(ownr, pago)
		fecha ||= objt.blank? ? Time.zone.today : objt.fecha_uf

		fecha
	end

	# Version 2.0
	# UF de cálculo tarifa; llamado desde despliegue de un pago
	# vlr_uf(fecha en controllers/concenrs/capitan
	# Sirve para Causa / Asesoría get_uf_calculo
	def get_uf_calculo_pago(ownr, pago)
		vlr_uf(get_fecha_calculo_pago(ownr, pago))
	end

	# Version 2.0
	# Vector [monto_uf, monto_pesos]
	def get_v_tarifa_pago(ownr, pago, objt, uf_calculo)
#		objt = get_tar_calculo_pago(ownr, pago)
#		objt ||= get_tar_facturacion_pago(ownr, pago)
#		uf_calculo = get_uf_calculo_pago(ownr, pago)
		if objt.present?
			monto_pesos = objt.moneda == 'Pesos' ? objt.monto : (uf_calculo.blank? ? nil : objt.monto * uf_calculo)
			monto_uf    = ['UF', '', nil].include?(objt.moneda) ? objt.monto : (uf_calculo.blank? ? nil : objt.monto / uf_calculo)
		elsif (pago.valor.blank? and ownr.tar_valor_cuantias.empty?) or (uf_calculo.blank? and pago.requiere_uf)
			monto_pesos = nil
			monto_uf = nil
		else
    		monto = pago.valor.blank? ? (pago.formula_tarifa.blank? ? nil : calcula2(pago.formula_tarifa, ownr, pago)) : pago.valor
    		if monto.blank?
    			monto_pesos = nil
    			monto_uf = nil
    		else
		        monto_pesos = pago.moneda == 'Pesos' ? monto : ( uf_calculo.blank? ? nil : monto * uf_calculo )
		        monto_uf = pago.moneda == 'UF' ? monto : ( uf_calculo.blank? ? nil : monto / uf_calculo )
		    end
		end
    	[monto_uf, monto_pesos]
	end

	def get_objt_pago(ownr, pago)
		objt = get_tar_calculo_pago(ownr, pago)
		objt ||= get_tar_facturacion_pago(ownr, pago)
		objt
	end

	# Versión 2.0: secondary
	def get_objt_calculo_pago(ownr, pago)
		# Cambiado porque había un error en producción
		objt = ownr.class.name == 'Causa' ? get_tar_uf_facturacion_pago(ownr, pago) : ownr
		objt ||= get_objt_pago(ownr, pago)
		objt
	end

    # Versión 2.0
    def origen_fecha_calculo_pago(objt_clss)
		case objt_clss
			when 'TarUfFacturacion'
				'UF definida para este pago.'
			when 'TarCalculo'
				'UF de la fecha de cálculo.'
			when 'TarFacturacion'
				'UF de la fecha de aprobación.'
			else
				'UF del día de hoy.'
			end
    end

	# Version 2.0
	# es un Array que contiene los cálculos, pagos o nil (si no hay ninguno de los anteriores)
	def h_pgs(ownr)
		hsh = {}
		ownr.tar_tarifa_tar_pagos.ordr.each do |pago|
			hsh[pago.id] = {}
			tar_uf_facturacion 		= ownr.class.name == 'Causa' ? get_tar_uf_facturacion_pago(ownr, pago) : nil
			objt_calculo         	= get_objt_pago(ownr, pago)
			objt_origen						= ownr.class.name == 'Causa' ? (tar_uf_facturacion.blank? ? objt_calculo : tar_uf_facturacion) : ownr
			fecha_calculo        	= objt_origen.blank? ? Time.zone.today : (objt_origen.fecha_uf.blank? ? Time.zone.today : objt_origen.fecha_uf)
			uf_calculo				= vlr_uf(fecha_calculo)
			hsh[pago.id][:fecha_calculo] 		= fecha_calculo
			hsh[pago.id][:uf_calculo]    		= uf_calculo
			hsh[pago.id][:objt_calculo]    		= objt_calculo
			hsh[pago.id][:v_tarifa]      		= get_v_tarifa_pago(ownr, pago, objt_calculo, uf_calculo)
			hsh[pago.id][:tar_uf_facturacion]	= tar_uf_facturacion
			hsh[pago.id][:origen_fecha_uf]		= origen_fecha_calculo_pago(objt_origen.class.name)
			hsh[pago.id][:ownr_fctrcn]          = objt_calculo.class.name == 'TarCalculo' ? objt_calculo : ownr
		end
		hsh
	end

	# =================================================================================================================

	# Sirve para causa / asesoria
	def get_tar_calculo(ownr, pago)
		ownr.class.name == 'Causa' ? ownr.tar_calculos.find_by(tar_pago_id: pago.id) : ownr.tar_calculo
	end

	# Sirve para causa / asesoria
	def get_tar_facturacion(objeto, pago)
		objeto.class.name == 'Causa' ? objeto.tar_facturaciones.find_by(tar_pago_id: pago.id) : objeto.tar_facturacion
	end

	# este método debe aplicar a Causa y Asesoría
	def get_fecha_calculo(ownr, pago)
		fobj = ownr.class.name == 'Causa' ? ownr.tar_uf_facturacion(pago) : ownr
		f1 = fobj.blank? ? nil : fobj.fecha_uf

		tar_calculo = get_tar_calculo(ownr, pago)
		f2 = tar_calculo.blank? ? nil : tar_calculo.fecha_uf

		tar_facturacion = get_tar_facturacion(ownr, pago)
		f3 = tar_facturacion.blank? ? nil : tar_facturacion.fecha_uf

		f_uf = f1.present? ? f1 : ( f2.present? ? f2 : f3 )
		f_uf.blank? ? ( tar_facturacion.present? ? tar_facturacion.created_at : Time.zone.today ) : f_uf
	end

	# DEPRECATED
	def get_uf_calculo(ownr, pago)
		vlr_uf(get_fecha_calculo_pago(ownr, pago))
	end

	# Monto en pesos de TarCalculo o TarFacturación
	# Sirve para Causa / Asesoría : objeto = {tar_calculo, tar_facturacion}; owner = {causa, asesoria}
	def get_monto_calculo_pesos(objeto, owner, pago)
		uf = get_uf_calculo(owner, pago)
		objeto.moneda == 'Pesos' ? objeto.monto : (uf.blank? ? 0 : (objeto.monto * uf))
	end

	# Monto en UF de TarCalculo o TarFacturación
	# Sirve para Causa / Asesoría : objeto = {tar_calculo, tar_facturacion}; owner = {causa, asesoria}
	def get_monto_calculo_uf(objeto, owner, pago)
		uf = get_uf_calculo(owner, pago)
		['UF', '', nil].include?(objeto.moneda) ? objeto.monto : (uf.blank? ? 0 : objeto.monto / uf)
	end


	def origen_fecha_calculo(ownr, pago)
		orgn ||= ownr if (ownr.class.name == 'Causa' and ownr.tar_uf_facturacion(pago))
		orgn ||= ownr if (['Asesoria', 'Cargo'].include?(ownr.class.name) and ownr.fecha_uf? )
		orgn ||= get_tar_calculo(ownr, pago)
		orgn ||= get_tar_facturacion(ownr, pago)

		orgn.class.name
	end

    # Se usa en Aprobación
	def leyenda_origen_fecha_calculo(causa, pago)
		case origen_fecha_calculo(causa, pago)
		when 'TarUfFacturacion'
			'UF definida para este pago.'
		when 'TarCalculo'
			'UF de la fecha de cálculo.'
		when 'TarFacturacion'
			'UF de la fecha de aprobación.'
		when 'Today'
			'UF del día de hoy.'
		end
	end

end