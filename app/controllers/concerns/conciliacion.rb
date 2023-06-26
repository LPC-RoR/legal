module ProcesaCarga
	extend ActiveSupport::Concern

	## USO APLICACIÓN
	# este método carga el archivo excel con citas FORMATO ÚNICO
	def carga_archivo_excel(carga)

		xlsx = Roo::Spreadsheet.open("#{Rails.root}/public/#{carga.archivo_carga.url}")

		# tomamos el AREA desde afuera para evitar errores.
		@area = carga.area

		@n_procesados = 0
		@n_carga      = 0
		@n_duplicados = 0

		@n_formatos   = 0
		@n_areas      = 0
		@n_publicadas = 0

		xlsx.each() do |hash|

			@year            = ''
			@author          = ''
			@doi             = ''
			@volume          = ''
			@pages           = ''
			@journal         = ''
			@titulo          = ''
			@doc_type        = ''
			@t_sha1          = ''
			@academic_degree = ''
			@unicidad        = ''

			# hash[0] Primera columna, aqui no la usamos
			# hash[1] year, lo usamos para verificar
			# hash[2] quote, esta es la CITA

			@year = hash[1]
			# sanitizamos tags html
			@cita = CGI.unescapeHTML(ActionView::Base.full_sanitizer.sanitize(hash[2])).strip

			# PRIMER FILTRO SACA AUTOR Y YEAR

			m=@cita.match(/(?<author>[ÁÉÍÓÚÀEÌÒÙÄËÏÖÜA-Z\-–\s,Ñ&\.]*)\s{0,1}\((?<year>[^\)]*)\)\n*\s*(?<resto>.*)$/)
			if m.blank?
				@doc_type = 'book'
			else
				@author = m[:author].strip
				@year = m[:year].strip
				@resto = m[:resto].strip
			end

			# SEGUNDO FILTRO SACAR DOI SI EXISTE
			if !!@resto.match(/doi.org/)
				@doi = @resto.split('http')[1].split('.org/')[1].strip
				@resto_2 = @resto.split('http')[0].strip
			elsif !!@resto.match(/\sdoi:/)
				@doi = @resto.split(' doi:')[1].strip
				@resto_2 = @resto.split(' doi:')[0].strip
			else
				@resto_2 = @resto
			end

			# TERCER FILTRO SACA VOLUMEN Y PAGINAS
			if !!@resto_2.match(/(?<resto3>.*) (?<volume>\d*\s{0,1}\({0,1}\d*\/{0,1}[-–]{0,1}\d*\){0,1}):(?<pages>\s{0,1}\d*[-–]{0,1}\d*).$/)
				m2 = @resto_2.match(/(?<resto3>.*) (?<volume>\d*\s{0,1}\({0,1}\d*\/{0,1}[-–]{0,1}\d*\){0,1}):(?<pages>\s{0,1}\d*[-–]{0,1}\d*).$/)
				@resto_3 = m2[:resto3].strip.delete_suffix('.')
				@volume = m2[:volume].strip
				@pages = m2[:pages].strip
				@doc_type = 'article'

				conectores = []
				conectores << '.' if @resto_3.split('.').length > 1
				conectores << '?' if @resto_3.split('?').length > 1
				conectores << '-' if @resto_3.split('-').length > 1
				conectores << ')' if @resto_3.split(')').length > 1
				conectores << ':' if @resto_3.split(':').length > 1

				conector = ''
				largo = 100
				if conectores.length == 0
					conector = ''
				elsif conectores.length == 1
					conector = conectores[0]
				else
					conectores.each do |conect|
						if conect.length < largo
							conector = conect
							largo = conect.length

						end
					end
				end

				unless conector.blank?
					@journal = @resto_3.split(conector).last.strip
					@titulo = @resto_3.delete_suffix(@resto_3.split(conector).last).delete_suffix('.').strip
				end
			elsif !!@resto_2.match(/Tesis/)
				@titulo = @resto_2.split('Tesis')[0].strip.delete_suffix('.').strip
				@doc_type = 'tesis'

				@resto_3 = @resto_2.split('Tesis')[1]
				if !!@resto_3.match(/Pp\./)
					@pages = @resto_3.split('Pp.')[1].strip
					@journal = @resto_3.split('Pp.')[0].delete_suffix('.').delete_suffix(':').strip
				else
					@journal = @resto_2.split('Tesis')[1].delete_suffix('.').strip
				end
			elsif !!@resto_2.match(/Memoria para optar al Título Profesional de/i)
				@resto_3 = @resto_2.split('Memoria para optar al Título Profesional de')[1].strip.delete_suffix('.')
				@titulo = @resto_2.split('Memoria para optar al Título Profesional de')[0].strip.delete_suffix('.')

				@total_pages = @resto_3.split('.').last
				@pages = @total_pages.split('pp').join('').split('Pp').join('').strip

				@doc_type = 'memoir'
				@academic_degree = @resto_3.delete_suffix(@pages).split(',')[0].strip
				@journal = @resto_3.delete_suffix(@total_pages).delete_prefix(@academic_degree).delete_prefix(', ').strip
			else
				@doc_type = 'book'
				unless @resto_2.blank?
					@titulo = @resto_2.split('.')[0].strip 
				end
			end

			# CONTROL DE UNICIDAD
			unicidad_doi = ''
			if @doi.present?
				duplicado = Publicacion.where(doi: @doi)
				if duplicado.blank?
					unicidad_doi = 'no encontrado'
				else
					unicidad_doi = duplicado.map {|dup| dup.d_quote}.include?(@cita) ? 'carga area' : 'duplicado'
				end
			else
				unicidad_doi = 'sin doi'
			end
			unicidad_titulo = ''

			if @titulo.present?
				@t_sha1 = Digest::SHA1.hexdigest(@titulo.downcase)
				duplicado = Publicacion.where(t_sha1: @t_sha1)
				if duplicado.blank?
					unicidad_titulo = 'no encontrado'
				else
					unicidad_titulo = duplicado.map {|dup| dup.d_quote}.include?(@cita) ? 'carga area' : 'duplicado'
				end
			else
				unicidad_titulo = 'sin_titulo'
			end

			if unicidad_titulo == 'carga area' or unicidad_doi == 'carga area'
				duplicados = Publicacion.where(doi: @doi) if unicidad_doi == 'carga area'
				duplicados = Publicacion.where(t_sha1: @t_sha1) if unicidad_titulo == 'carga area'
				@unicidad = 'carga area'

				duplicado = duplicados.find_by(d_quote: @cita)

				@area.papers << duplicado unless duplicado.areas.map {|aas| aas.area}.include?(@area.area)

				@n_areas += 1
			else
				@unicidad = unicidad_doi == 'duplicado' ? 'duplicado_doi' : (unicidad_titulo == 'duplicado' ? 'duplicado_title' : 'unico')

	# 			MARCAMOS COMO DUPLICADO LOS BOOKS, temporalmente
	#			@estado = (unicidad_titulo == 'duplicado' or unicidad_doi == 'duplicado') ? 'duplicado' : 'carga'
				if (unicidad_titulo == 'duplicado' or unicidad_doi == 'duplicado')
					@estado = 'duplicado'
					@n_duplicados += 1
				elsif @doc_type == 'book'
					@estado = 'formato'
					@n_formatos += 1
				else
					@estado = 'carga'
					@n_carga += 1
				end

				# origen: {'carga', 'ingreso'}
				@origen = 'carga'

				# Se crean TODAS LAS PUBLICACIONES, EL CONTROL DE DUPLICADOS SE HACE AFUERA
				pub = Publicacion.create(t_sha1: @t_sha1, origen: @origen, estado: @estado, doc_type: @doc_type, d_quote: @cita, author: @author, year: @year, doi: @doi, volume: @volume, pages: @pages, journal: @journal, title: @titulo, academic_degree: @academic_degree, unicidad: @unicidad)

				if pub.d_quote.strip == pub.m_quote.strip and pub.estado == 'carga'
					pub.estado = 'publicada'
					pub.save

					@n_publicadas += 1
					@n_carga -= 1
				end

			    if pub.estado == 'publicada'
			      procesa_cita_carga(pub)
			    end

				carga.publicaciones << pub
				@area.papers << pub
			end

			@n_procesados += 1

		end
		carga.estado = 'procesada'
		carga.n_procesados = @n_procesados
		carga.n_carga      = @n_carga
		carga.n_duplicados = @n_duplicados
		carga.n_publicadas = @n_publicadas
		carga.n_formatos   = @n_formatos
		carga.n_areas      = @n_areas
		carga.save
	end

	# este método procesa Autores, Investigadores y Revistas de una publicación
	def procesa_cita_carga(cita)

		# Procesa Area
		# Se suspende porque se hace conla carga

		# Procesa Autores
		authors = []
		if !!cita.author.match(/&+/)
			last_author = cita.author.split('&').last
			prev_authors = cita.author.split('&')[0].split(',')
		else
			last_author = nil
			prev_authors = [cita.author]
		end
		autores = cita.author.gsub(/&/, ',').split(',')
		autores.each_with_index  do |val, index|
			# Encontramos un caso donde sólo se usa el apellido
			case val.split(' ')
			when 0
			when 1
				author_with_format = val.strip
			when 2
				author_with_format = (index == 0 ? (val.split(' ')[1]+' '+val.split(' ')[0]) : val.strip)
			else
				val.strip
			end
			authors << author_with_format
		end

		authors.each do |aut|
			inv = Investigador.find_by(investigador: aut)
			if inv.blank?
				inv = Investigador.create(investigador: aut)
			end
			cita.investigadores << inv
		end

		# Procesa Revista
		# Se usa 'd_journal' porque en Publicacion sólo se usa revista_id
		rev = Revista.find_by(revista: cita.journal)
		if rev.blank?
			rev = Revista.create(revista: cita.journal)
		end
		rev.publicaciones << cita
	
	end

	# Limpia el autor de elementos que no deben estar en el campo
	def limpia_autor_ingreso(autor)
		# Limpia el autor sacando los catacteres que no están
		autor_limpio = ''
		autor.strip.split('').each do |c|
			if !!c.match(/[a-zA-ZáéíóúàèìòùäëïöüñÁÉÍÓÚÀÈÌÒÙÄËÏÖÜÑ\.;\-,&\s]/)
				autor_limpio += c
			end
		end
		autor_limpio = autor_limpio.strip

		autor_con_coma = autor_limpio.split(';').join(',').split(' and ').join(',').split('&').join(',')

		elementos = autor_con_coma.split(',').map {|cc| cc.split('.').join('').strip}

		autores = []
		# SACA LOS ELEMENTOS QUE SON CARACTERES O VACIOS
		elementos.each do |a|
			unless a.strip.split(' ').length < 2
				partes = a.strip.split(' ')
				if partes.last.length == 1
					partes.pop
					autores << partes.join(' ')
				else
					autores << a
				end
			end
		end

		last = autores.last
		autores.pop
		case autores.length
		when 0
			last.upcase
		when 1
			(autores[0]+' & '+last).upcase
		else
			(autores.join(', ')+' & '+last).upcase
		end
	end
	
end