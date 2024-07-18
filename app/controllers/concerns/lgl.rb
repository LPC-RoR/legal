module Lgl
	extend ActiveSupport::Concern

    def sin_f_pgn(page_text)
      # Saca el número de página y el caracter de inicio de página.
      # No reemplazamos \s con espacios porque, \s arrastra con más que espacios
      page_text.gsub(/\n/, '__n__').gsub(/__n__\s+\d+\s*$/, "__n__" ).gsub(/\f/, '__n__').gsub(/__n__/, "\n")
    end

    def new_line_rgx
      rex1 = "^[a-z]{1}\s?[\)\:\.]{1}"
      rex2 = "^[1-9]{1,2}\.?[0-2]{1,2}\s*[\)\:\.]{1}\s+"
      rex3 = "^[IVXLC]+[\s\:\.\)]{1}"
      rex4 = /^POR\s*TANTO(\,|\s|\:)+/
      /#{rex1}|#{rex2}|#{rex3}|#{rex4}/i
    end

    def chk_br(line, final)
      chk_blank = (line != '' and final != '' and line != nil and final != nil)
      chk_blank and ['.', ':'].include?(final.strip[-1])
    end

    def read_pdf
	    if @objeto.archivo.present?
	    	# Carga el archivo
			path_pdf = File.join(Rails.root, 'public', @objeto.archivo.url)
			reader = PDF::Reader.new(path_pdf)

			# Borra antes de reprocesar
			if @objeto.lgl_parrafos.any?
				@objeto.lgl_parrafos.delete_all
			end

			# Unir las páginas en un sólo texto
			original = ''
			reader.pages.each do |page|
				original << "#{sin_f_pgn(page.text)}\n"
			end

			original = original.gsub(/\n\n/, '</br>').gsub(/\n/, ' ')

			# Procesamos línea a línea
			p_ord = 0
			txt_prrf = ''
			final = nil

			original.split("</br>").each do |raw_line|
				line = raw_line.strip
#				if line.match?(new_line_rgx)
					# Primera línea de la siguiente sección
					LglParrafo.create(lgl_documento_id: @objeto.id, orden: p_ord + 1, lgl_parrafo: "#{txt_prrf}\n")
					p_ord += 1
					txt_prrf = line
					final = line
#				else
					# No es primera línea de la siguiente seccion y no es un campo => Debe ser la continuación de un campo.
#					if chk_br(line, final)
#						LglParrafo.create(lgl_documento_id: @objeto.id, orden: p_ord + 1, lgl_parrafo: "#{txt_prrf}</br>")
#						p_ord += 1
#						txt_prrf = line
#						final = line
#					else
#						txt_prrf << " #{line}"
#					end
#					final = line unless (line == '' or line.blank?)
#				end
			end
		    LglParrafo.create(lgl_documento_id: @objeto.id, orden: p_ord + 1, lgl_parrafo: "#{txt_prrf}</br>")
	    end

    end
end