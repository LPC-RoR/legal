module Rut
  extend ActiveSupport::Concern

  def rut_format?(rut)
    !!( rut.strip =~ /^[\d]{1,2}\.?[\d]{3}\.?[\d]{3}\-?[\dkK]{1}/ )
  end

  def vrfy_dgt(rut)
    chr_dgt = rut.strip[-1]
    chr_dgt.downcase == 'k' ? 10 : chr_dgt.to_i
  end

  def vrfy_rut(rut)
    fctrs = [2, 3, 4, 5, 6, 7, 2, 3]
#    arr = rut.split('-')[0].gsub('.', '').reverse.split('')
    arr = !!(rut.strip =~ /\-/) ? rut.split('-')[0].gsub('.', '').reverse.split('') : rut.strip.split('').reverse.drop(1)
    rst = arr.each_with_index.map {|c, i| c.to_i * fctrs[i]}.sum % 11
    rst == 0 ? 0 : 11 - rst
  end

  def verified_rut?(rut)
    vrfy_rut(rut) == vrfy_dgt(rut)
  end

  def valid_rut?(rut)
    rut_format?(rut) ? verified_rut?(rut) : false
  end

  def rut_format(rut)
    rut.gsub(/[\.\-]/, '')
  end

end