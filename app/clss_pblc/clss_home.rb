class ClssHome < ApplicationRecord
	def self.titles
		{
			index: 			'Externalización de investigaciones Ley 21.643',
			metodologia: 	'Etapas y plazos del procedimiento de investigación | Laborsafe',
			laborsafe: 		'Plataforma tecnológica para investigaciones Ley 21.643 | Laborsafe',
			equipo: 		'Equipo legal: abogados especialistas en Ley 21.643 | Laborsafe',
			simulador: 		'Simulador de plazos del procedimiento Ley 21.643 | Laborsafe',
			registro: 		'Cuenta demo gratuita: evalúe Laborsafe por 10 días'
		}.freeze
	end

	 def self.cuerpo_principal
		[
		    {
		        cita: "Ley N° 21.643",
		        nombre: "Ley Karin",
		        entidad: "Ministerio del Trabajo y Previsión Social – Congreso Nacional de Chile",
		        fecha: "15 de enero de 2024 (vigencia: 1 de agosto de 2024)",
		        proposito: "Prevenir, investigar y sancionar el acoso laboral, sexual o de violencia en el trabajo.",
		        descripcion: "Modifica el Código del Trabajo y otros cuerpos legales en materia de prevención, investigación y sanción del acoso laboral, sexual o de violencia en el trabajo. Establece el principio de trato libre de violencia con perspectiva de género (art. 2° del Código del Trabajo), la obligación de contar con un protocolo de prevención, el derecho a la confidencialidad, el procedimiento de investigación interna y el derecho a hacer valer garantías (art. 154 bis). Es la norma núcleo del marco legal de la Ley Karin.",
		        url: "https://www.bcn.cl/leychile/navegar?idNorma=1200096"
		    },
		    {
		        cita: "DFL N° 1 (2002) – Código del Trabajo, arts. 2°, 67, 154 bis y 211-A a 211-E",
		        nombre: "Código del Trabajo – texto refundido",
		        entidad: "Ministerio del Trabajo y Previsión Social",
		        fecha: "Última versión consolidada",
		        proposito: "Incorporar al derecho laboral chileno las obligaciones y garantías derivadas de la Ley Karin.",
		        descripcion: "Recoge las modificaciones introducidas por la Ley 21.643: el nuevo art. 2° con principio de trato libre de violencia y definiciones de acoso sexual, laboral y violencia en el trabajo; la obligación de incluir la materia en el reglamento interno (art. 67 N° 12); el derecho a hacer valer garantías durante el procedimiento (art. 154 bis); y el nuevo Título IV del Libro II (arts. 211-A a 211-E) que regula la prevención, investigación y sanción.",
		        url: "https://www.bcn.cl/leychile/navegar?idNorma=207436"
		    },
		    {
		        cita: "Decreto N° 21, Ministerio del Trabajo y Previsión Social",
		        nombre: "Reglamento del procedimiento de investigación",
		        entidad: "Ministerio del Trabajo y Previsión Social",
		        fecha: "3 de julio de 2024",
		        proposito: "Fijar las directrices generales del procedimiento de investigación del acoso sexual, laboral o de violencia en el trabajo.",
		        descripcion: "Reglamento que desarrolla las etapas del procedimiento interno de investigación: recepción de la denuncia, medidas cautelares, acreditación de la comisión investigadora, citaciones, audición de las partes, informe final, comunicación de la decisión y mecanismos de recurso. Es la norma reglamentaria que complementa operativamente a la Ley 21.643.",
		        url: "https://www.bcn.cl/leychile/navegar?idNorma=1204689"
		    },
		    {
		        cita: "Circular N° 3.813, Superintendencia de Seguridad Social",
		        nombre: "Directrices mínimas del protocolo de prevención",
		        entidad: "Superintendencia de Seguridad Social (Suseso)",
		        fecha: "7 de junio de 2024",
		        proposito: "Establecer las directrices mínimas del protocolo de prevención del acoso sexual, laboral y la violencia en el trabajo.",
		        descripcion: "Instruye a empleadores y organismos administradores (mutualidades e ISL) sobre los contenidos mínimos del protocolo preventivo: definiciones, canales de denuncia, comisión investigadora, procedimiento de investigación y protección a la víctima. Publica además un modelo de protocolo tipo que las empresas pueden adoptar.",
		        url: "https://www.suseso.gob.cl/612/articles-732037_archivo_01.pdf"
		    },
		    {
		        cita: "Ordinario N° 362/19, Dirección del Trabajo",
		        nombre: "Sentido y alcance de la Ley 21.643",
		        entidad: "Dirección del Trabajo",
		        fecha: "7 de junio de 2024",
		        proposito: "Fijar el sentido y alcance de las disposiciones contenidas en la Ley 21.643.",
		        descripcion: "Dictamen interpretativo oficial del Servicio de Inspección del Trabajo que desarrolla derechos y obligaciones de empleadores y trabajadores, el procedimiento de investigación interna, el rol de la Inspección, la aplicación de sanciones y la coordinación entre los distintos niveles de prevención. Constituye el criterio administrativo vinculante para la fiscalización.",
		        url: "https://www.dt.gob.cl/legislacion/1624/articles-126267_recurso_pdf.pdf"
		    }
    	]
	end

	def self.docs_referencia
		[
	      {
	        cita: "Convenio N° 190 de la OIT y Recomendación N° 206",
	        nombre: "Convenio y Recomendación de la OIT",
	        entidad: "Organización Internacional del Trabajo (OIT)",
	        fecha: "Ratificado por Chile en 2023 (D.S. N° 122, 2023)",
	        proposito: "Eliminar la violencia y el acoso en el mundo del trabajo.",
	        descripcion: "Convenio internacional marco de la Ley Karin. Define violencia y acoso en el mundo del trabajo e impone a los Estados miembros adoptar marcos integrados de prevención y protección con perspectiva de género. Su ratificación obligó a Chile a actualizar su legislación interna, materializada en la Ley 21.643.",
	        url: "https://www.bcn.cl/leychile/navegar?idNorma=1196685"
	      },
	      {
	        cita: "Decreto Supremo N° 2 (2024), Ministerio del Trabajo y Previsión Social",
	        nombre: "Política Nacional de Seguridad y Salud en el Trabajo 2024-2028",
	        entidad: "Ministerio del Trabajo y Previsión Social",
	        fecha: "7 de mayo de 2024",
	        proposito: "Aprobar la Política Nacional de Seguridad y Salud en el Trabajo.",
	        descripcion: "Sus principios y lineamientos deben recogerse en el protocolo de prevención de acoso y violencia, de modo que la gestión de riesgos psicosociales se integre al sistema de gestión de seguridad y salud ocupacional de la empresa, en coordinación con la Suseso y los organismos administradores.",
	        url: "https://www.bcn.cl/leychile/navegar?idNorma=1203353"
	      }
		]
	end

	def self.leyes_modificadas
		[
	      {
	        cita: "Ley N° 18.575, art. 13",
	        nombre: "Bases Generales de la Administración del Estado",
	        entidad: "Congreso Nacional de Chile",
	        fecha: "Última versión consolidada",
	        proposito: "Extender las obligaciones de prevención del acoso y la violencia a la administración pública central.",
	        descripcion: "Modificada por la Ley 21.643, incorpora al art. 13 el principio de trato libre de violencia con perspectiva de género en el desempeño de los cargos públicos y las obligaciones de prevención, investigación y sanción del acoso y la violencia en la Administración del Estado.",
	        url: "https://www.bcn.cl/leychile/navegar?idNorma=29967"
	      },
	      {
	        cita: "DFL N° 29 (2004) – Estatuto Administrativo, Ley N° 18.834, arts. 90, 119 y 125",
	        nombre: "Estatuto Administrativo",
	        entidad: "Congreso Nacional de Chile",
	        fecha: "Última versión consolidada",
	        proposito: "Incorporar la prevención del acoso y la violencia al estatuto de los funcionarios públicos.",
	        descripcion: "Sus modificaciones introducidas por la Ley 21.643 reconocen el derecho a un trato libre de violencia, consagran la obligación de contar con protocolos de prevención en los servicios públicos y regulan la investigación y sanción del acoso sexual, laboral o de violencia en el trabajo para el personal a contrata y de planta.",
	        url: "https://www.bcn.cl/leychile/navegar?idNorma=30210"
	      },
	      {
	        cita: "Ley N° 18.883 – Estatuto Administrativo Municipal",
	        nombre: "Estatuto Administrativo Municipal",
	        entidad: "Congreso Nacional de Chile",
	        fecha: "Última versión consolidada",
	        proposito: "Aplicar el marco de prevención del acoso y la violencia al personal municipal.",
	        descripcion: "Incorporada por la Ley 21.643 al régimen de prevención, investigación y sanción, de modo que los municipios quedan sujetos a las mismas obligaciones de contar con protocolos de prevención, procedimientos de investigación interna y medidas de protección a las víctimas.",
	        url: "https://www.bcn.cl/leychile/navegar?idNorma=30256"
	      },
	      {
	        cita: "Ley N° 16.744 – accidentes del trabajo y enfermedades profesionales",
	        nombre: "Ley de accidentes del trabajo y enfermedades profesionales",
	        entidad: "Congreso Nacional de Chile",
	        fecha: "Última versión consolidada",
	        proposito: "Asegurar la atención de salud y el apoyo de los organismos administradores a las víctimas.",
	        descripcion: "Su relevancia en el marco de la Ley Karin radica en la obligación de los organismos administradores (mutualidades e ISL) de brindar atención psicológica temprana y gratuita a las víctimas, además de asistencia técnica en la implementación de protocolos y programas de prevención, conforme a las instrucciones de la Suseso.",
	        url: "https://www.bcn.cl/leychile/navegar?idNorma=28650"
	      }
	    ]
	end

	def self.otros_documentos
		[
	      {
	        cita: "Reporte Ley N° 21.643",
	        nombre: "Reporte del Poder Judicial",
	        entidad: "Secretaría de Género, Poder Judicial de Chile",
	        fecha: "2024",
	        proposito: "Difundir y explicar el contenido de la Ley Karin desde la perspectiva judicial.",
	        descripcion: "Documento divulgativo del Poder Judicial que resume el contenido de la ley, sus procedimientos y su impacto en la actuación de los tribunales laborales, útil como material de referencia y capacitación.",
	        url: "https://secretariadegenero.pjud.cl/images/documentos/AcademiaJudicial/Reporte-Ley-21643.pdf"
	      },
	      {
	        cita: "Nota Ciudadana – Ley Karin",
	        nombre: "Nota legislativa ciudadana",
	        entidad: "Subsecretaría de Previsión Social",
	        fecha: "2024",
	        proposito: "Informar a la ciudadanía en lenguaje claro sobre los derechos y obligaciones que crea la ley.",
	        descripcion: "Material divulgativo que explica en términos sencillos qué es la Ley Karin, a quiénes protege, cuáles son los derechos de las víctimas y las obligaciones de los empleadores, incluyendo el protocolo de prevención y el procedimiento de investigación.",
	        url: "https://previsionsocial.gob.cl/wp-content/uploads/2024/08/08-NOTA-CIUDADANA-ABRILAGOSTO-2024.pdf"
	      },
	      {
	        cita: "Modelo de protocolo de prevención Suseso",
	        nombre: "Manual y modelo de protocolo de prevención",
	        entidad: "Superintendencia de Seguridad Social / ACHS",
	        fecha: "2024",
	        proposito: "Entregar a los empleadores un modelo práctico y adaptable de protocolo de prevención.",
	        descripcion: "Documento modelo con la estructura completa del protocolo: definiciones, canales de denuncia, comisión investigadora, etapas del procedimiento, medidas de protección y plan de difusión, que las empresas pueden adoptar directamente o adaptar a su realidad.",
	        url: "https://www.achs.cl/docs/librariesprovider2/documents-ley-karin/manual-protocolo-prevencion-suseso.pdf"
	      }
	    ]
	end
end