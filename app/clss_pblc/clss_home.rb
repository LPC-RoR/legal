class ClssHome < ApplicationRecord

	# Lo dejé e usar porque cambié a content_for en las vistas, pero puede volverse a usar si pongo la lógica en el controlador.
	def self.titles
		{
			index: 			'Externalización de investigaciones Ley 21.643',
			metodologia: 	'Etapas y plazos del procedimiento de investigación | Laborsafe',
			laborsafe: 		'Plataforma tecnológica para investigaciones Ley 21.643 | Laborsafe',
			equipo: 		'Equipo legal: abogados especialistas en Ley 21.643 | Laborsafe',
			simulador: 		'Simulador de plazos del procedimiento Ley 21.643 | Laborsafe',
#			registro: 		'Cuenta demo gratuita: evalúe Laborsafe por 10 días'
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
		    },
			{
			  cita: "Ordinario N° 1189, Superintendencia de Educación",
			  nombre: "Aplicación de la Ley Karin en establecimientos educacionales",
			  entidad: "Superintendencia de Educación",
			  fecha: "5 de agosto de 2024",
			  proposito: "Informar a las entidades sostenedoras sobre la aplicación de la Ley 21.643 en establecimientos educacionales.",
			  descripcion: "Contiene las consideraciones de la Superintendencia de Educación sobre la aplicación de la Ley Karin en el ámbito escolar. Distingue la relación laboral (regida por el RIOHS y el protocolo de prevención de la Ley Karin) de la relación educativa (regida por el Reglamento Interno de Convivencia Escolar), precisa que ambos protocolos no son incompatibles por perseguir finalidades distintas, y recomienda actualizar los reglamentos internos y coordinar los procedimientos de investigación para evitar decisiones contradictorias, excesiva carga administrativa y revictimización.",
			  url: "https://www.supereduc.cl/wp-content/uploads/2024/08/ORD-No-1189-INF-SOBRE-APLICACION-DE-LEY-21.643-EN-ESTA.-EDUC.-A_ENTIDADES-SOSTENEDORAS.pdf"
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
			  cita: "Infografía Superintendencia de Educación",
			  nombre: "Infografía: Aplicación de la Ley Karin en establecimientos educacionales",
			  entidad: "Superintendencia de Educación",
			  fecha: "2024",
			  proposito: "Orientar a entidades sostenedoras y comunidades educativas sobre las obligaciones de la Ley Karin en el ámbito escolar.",
			  descripcion: "Material divulgativo que resume las obligaciones de los sostenedores frente a la Ley Karin y su articulación con la normativa de convivencia escolar, incluyendo los protocolos de prevención, canales de denuncia y medidas de protección para docentes y asistentes de la educación.",
			  url: "https://www.supereduc.cl/wp-content/uploads/2024/09/infog_leykarin.pdf"
			},
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

	def self.datos_personales_vigente
	  [
	    {
	      cita: "Ley N° 19.628",
	      nombre: "Ley sobre protección de la vida privada (vigente)",
	      entidad: "Ministerio Secretaría General de la Presidencia – Congreso Nacional de Chile",
	      fecha: "Promulgada el 18 de agosto de 1999 (última modificación: Ley 21.504, 2022; vigente hasta el 30 de noviembre de 2026)",
	      proposito: "Regular la forma y condiciones del tratamiento y protección de los datos personales de las personas naturales.",
	      descripcion: "Es la norma vigente que rige el tratamiento de datos personales en Chile desde 1999. Establece que todo tratamiento requiere consentimiento del titular o autorización legal, consagra los derechos de acceso, rectificación, cancelación y bloqueo, prohíbe el tratamiento de datos sensibles salvo excepciones legales, y regula el deber de secreto y la responsabilidad por tratamiento indebido. Será íntegramente reformada por la Ley 21.719 a partir del 1 de diciembre de 2026, cuando pasará a llamarse «Ley sobre protección de los datos personales».",
	      url: "https://www.bcn.cl/leychile/navegar?idNorma=141599"
	    },
	    {
	      cita: "Ley N° 19.628 – versión actualizada en tramitación legislativa",
	      nombre: "Texto actualizado de la Ley 19.628 (PDF)",
	      entidad: "Pontificia Universidad Católica de Chile – Programa de Derecho, Ciencia y Tecnología",
	      fecha: "Actualización al 9 de mayo de 2023",
	      proposito: "Disponer del texto consolidado de la ley incorporando las modificaciones ya aprobadas por la Ley 21.719.",
	      descripcion: "Versión estructurada del texto legal que incorpora la reforma de la Ley 21.719 (derechos ampliados, principios, Agencia de Protección de Datos Personales), permitiendo contrastar el régimen vigente con el que regirá desde diciembre de 2026.",
	      url: "https://derechocienciaytecnologia.uc.cl/wp-content/uploads/2024/03/LEY-19.628-al-9-de-mayo-de-2023-Programa-de-Derecho-Ciencia-y-Tecnologia-UC-1.pdf"
	    },
	    {
	      cita: "Ley N° 20.285",
	      nombre: "Ley de acceso a la información pública",
	      entidad: "Congreso Nacional de Chile",
	      fecha: "Última versión consolidada",
	      proposito: "Regular el acceso a la información pública y la protección de datos personales en los órganos de la Administración del Estado.",
	      descripcion: "Complementa la Ley 19.628 en el ámbito público: regula las excepciones de acceso por protección de datos personales y encarga al Consejo para la Transparencia la resolución de reclamos cuando los órganos públicos deniegan el ejercicio de derechos de los titulares.",
	      url: "https://www.bcn.cl/leychile/navegar?idNorma=276485"
	    },
	    {
	      cita: "Ley N° 20.584, arts. 31 a 33",
	      nombre: "Ley de derechos y deberes de los pacientes",
	      entidad: "Ministerio de Salud – Congreso Nacional de Chile",
	      fecha: "Última versión consolidada",
	      proposito: "Proteger los datos sensibles de salud en el ámbito sanitario.",
	      descripcion: "Incorporó a la Ley 19.628 reglas especiales sobre el tratamiento y comunicación de datos de salud, exigiendo consentimiento informado y regulando el acceso del titular a su información clínica, relevante para la categoría de datos sensibles.",
	      url: "https://www.bcn.cl/leychile/navegar?idNorma=399286"
	    },
	    {
	      cita: "Guía de protección de datos personales para instituciones públicas",
	      nombre: "Guía del Consejo para la Transparencia",
	      entidad: "Consejo para la Transparencia",
	      fecha: "Mayo de 2024",
	      proposito: "Orientar a los órganos públicos en el tratamiento de datos personales conforme a la Ley 19.628 y la Ley 20.285.",
	      descripcion: "Documento práctico que desarrolla deberes de los responsables de bancos de datos, la figura del encargado o mandatario de tratamiento (art. 8 de la Ley 19.628), el tratamiento de datos sensibles y las recomendaciones para contrataciones que involucren datos personales.",
	      url: "https://www.consejotransparencia.cl/wp-content/uploads/instruccion/2024/05/Guia-proteccio%CC%81n-datos-personales-para-instituciones-pu%CC%81blicas.pdf"
	    }
	  ]
	end

	def self.datos_personales_ley_21719
	  [
	    {
	      cita: "Ley N° 21.719",
	      nombre: "Ley que regula la protección y el tratamiento de los datos personales y crea la Agencia de Protección de Datos Personales (promulgada)",
	      entidad: "Ministerio de Economía, Fomento y Turismo – Congreso Nacional de Chile",
	      fecha: "Publicada el 13 de diciembre de 2024 (entra en vigencia el 1 de diciembre de 2026)",
	      proposito: "Reformar la Ley 19.628 para proteger los datos personales conforme a los más altos estándares internacionales, alineando a Chile con el GDPR europeo.",
	      descripcion: "Transforma la Ley 19.628 en un estatuto de protección de datos personales: amplía los derechos del titular (acceso, rectificación, supresión, oposición, portabilidad y bloqueo, con plazo de respuesta de 30 días), establece principios rectores y deberes del responsable (transparencia, seguridad, protección desde el diseño y por defecto, registro de actividades de tratamiento, evaluaciones de impacto, notificación de brechas), regula las transferencias internacionales, tipifica infracciones leves, graves y gravísimas con multas de hasta 20.000 UTM (y hasta 4% de los ingresos anuales en reincidencia) y crea la Agencia de Protección de Datos Personales como autoridad fiscalizadora autónoma.",
	      url: "https://www.bcn.cl/leychile/navegar?idNorma=1209272"
	    },
	    {
	      cita: "Guía práctica de implementación",
	      nombre: "Guía Práctica para facilitar la implementación de la nueva Ley de Protección de Datos Personales en la Administración",
	      entidad: "Gobierno Digital – Ministerio Secretaría General de la Presidencia",
	      fecha: "2024 – 2026 (período previo a la entrada en vigencia)",
	      proposito: "Orientar a los órganos de la Administración del Estado en la implementación de la Ley 21.719 durante el período previo a su entrada en vigencia.",
	      descripcion: "Entrega recomendaciones prácticas, indica los pasos a seguir y pone a disposición formatos tipo de los documentos que deben elaborarse para dar cumplimiento a los nuevos estándares: registro de actividades de tratamiento, políticas de privacidad, gestión de derechos del titular y medidas de seguridad.",
	      url: "https://wikiguias.digital.gob.cl/datos-personales/guia-practica-implementacion-nueva-ley-datos-personales"
	    },
	    {
	      cita: "Actualización normativa y material docente",
	      nombre: "Ley 21.719 – Academia Judicial",
	      entidad: "Academia Judicial – Poder Judicial de Chile",
	      fecha: "2025",
	      proposito: "Difundir el nuevo sistema de protección de datos personales entre operadores jurisdiccionales.",
	      descripcion: "Recurso institucional que resume la reforma y pone a disposición el material docente «El nuevo sistema de protección de datos personales» y el texto completo de la ley, relevante para anticipar la actuación judicial del nuevo régimen.",
	      url: "https://academiajudicial.cl/recursos/actualizaciones-normativas/ley-21-719-que-regula-la-proteccion-y-el-tratamiento-de-los-datos-personales-y-crea-la-agencia-de-proteccion-de-datos-personales/"
	    },
	    {
	      cita: "Ley N° 19.223",
	      nombre: "Ley delitos informáticos",
	      entidad: "Congreso Nacional de Chile",
	      fecha: "Última versión consolidada",
	      proposito: "Tipificar penalmente la conducta del codelincuente que intercepta, altera o destruye datos personales almacenados en sistemas informáticos.",
	      descripcion: "Complementa el régimen sancionatorio: los arts. 161 A y 161 D castigan con penas de presidio menor el acceso ilícito y la alteración, destrucción o interceptación de datos personales, lo que adquiere mayor relevancia con el endurecimiento del régimen de protección.",
	      url: "https://www.bcn.cl/leychile/navegar?idNorma=30607"
	    },
	    {
	      cita: "Noticia: iniciativa de postergación (en tramitación)",
	      nombre: "Gobierno propone ampliar plazo para implementar nueva Ley de Protección de Datos",
	      entidad: "Ministerio de Economía, Fomento y Turismo",
	      fecha: "1 de septiembre de 2026 (proyecto de ley, aún no aprobado)",
	      proposito: "Postergar la entrada en vigencia de la Ley 21.719 del 1 de diciembre de 2026 al 1 de diciembre de 2027.",
	      descripcion: "Iniciativa ingresada al Senado para otorgar un año adicional de preparación institucional y regulatoria. Mientras el Congreso no la apruebe, la fecha legal de entrada en vigencia sigue siendo el 1 de diciembre de 2026. Se incluye como antecedente de seguimiento normativo.",
	      url: "https://www.economia.gob.cl/2026/09/01/gobierno-propone-ampliar-plazo-para-implementar-nueva-ley-de-proteccion-de-datos-y-institucionalidad.htm"
	    }
	  ]
	end

	def self.annm_normas_datos
	  [
	    {
	      cita: "Ley N° 19.628",
	      nombre: "Ley sobre protección de la vida privada",
	      entidad: "Congreso Nacional de Chile",
	      fecha: "Vigente hasta el 30 de noviembre de 2026",
	      proposito: "Regular el tratamiento y protección de los datos personales en registros o bancos de datos públicos y privados.",
	      descripcion: "Norma matriz de la protección de datos en Chile: exige autorización legal o consentimiento para tratar datos (art. 4°), impone el deber de secreto a quienes trabajan en el tratamiento (art. 7°), regula el mandato escrito con condiciones de uso de los datos (art. 8°), la finalidad y calidad de los datos (art. 9°), la prohibición de tratar datos sensibles salvo excepciones (art. 10°) y la debida diligencia del responsable (art. 11°). Constituye el estándar que justifica anonimizar documentos antes de su comunicación o publicación.",
	      url: "https://www.bcn.cl/leychile/navegar?idNorma=141599"
	    },
	    {
	      cita: "Ley N° 21.719",
	      nombre: "Ley sobre protección de los datos personales (promulgada; vigente desde el 1 de diciembre de 2026)",
	      entidad: "Congreso Nacional de Chile",
	      fecha: "Publicada el 13 de diciembre de 2024",
	      proposito: "Reformar la Ley 19.628 con un marco integral de protección de datos, con definiciones explícitas de anonimización y seudonimización.",
	      descripcion: "Incorpora por primera vez definiciones legales: la anonimización como «procedimiento irreversible en virtud del cual un dato personal no puede vincularse o asociarse a una persona determinada» —con la consecuencia jurídica clave de que el dato anonimizado deja de ser dato personal—, y la seudonimización como tratamiento que exige información adicional para reatribuir el dato. Regula además la evaluación de impacto (art. 15 ter), el deber de protección desde el diseño y por defecto (art. 14 quáter), la figura del delegado de protección de datos (art. 49), el régimen de infracciones leves, graves y gravísimas (art. 34) y la Agencia de Protección de Datos Personales (art. 30).",
	      url: "https://www.bcn.cl/leychile/navegar?idNorma=1209272"
	    },
	    {
	      cita: "Ley N° 20.285",
	      nombre: "Ley de acceso a la información pública",
	      entidad: "Congreso Nacional de Chile",
	      fecha: "Última modificación: Ley 21.755, 11 de julio de 2025",
	      proposito: "Regular la publicidad de los actos y documentos de la Administración del Estado y sus excepciones.",
	      descripcion: "Obliga a publicar y entregar documentos de organismos públicos salvo las excepciones legales (art. 5° y art. 21), incluida la protección de datos personales; en la práctica, los órganos deben entregar versiones anonimizadas tachando los datos personales o sensibles protegidos por la Ley 19.628. Su procedimiento de amparo y el reclamo ante el Consejo para la Transparencia hacen de esta ley uno de los ámbitos donde la anonimización de documentos se aplica cotidianamente.",
	      url: "https://www.bcn.cl/leychile/navegar?idNorma=276363"
	    },
	    {
	      cita: "Ley N° 20.584, arts. 12° a 13°",
	      nombre: "Ley de derechos y deberes de las personas en atención de salud",
	      entidad: "Ministerio de Salud",
	      fecha: "Última modificación: Ley 21.805, 16 de febrero de 2026",
	      proposito: "Asegurar la reserva de la información contenida en la ficha clínica y de los datos médicos, genéticos y sensibles.",
	      descripcion: "Impone a prestadores públicos y privados adoptar las providencias necesarias para asegurar la reserva de la identidad del titular y de los datos sensibles contenidos en las fichas clínicas a las que se acceda (art. 12° inciso final), y regula las restricciones al acceso del propio titular (art. 23°). Es la norma sectorial clave cuando una empresa administra documentos de salud de trabajadores o usuarios y debe difundirlos de forma anonimizada (por ejemplo, en investigaciones, auditorías o estadísticas internas).",
	      url: "https://www.bcn.cl/leychile/navegar?idNorma=1039348"
	    }
	  ]
	end

	def self.annm_normas_especificas
	  [
	    {
	      cita: "Auto Acordado N° 164-2024",
	      nombre: "Sobre acceso a carpetas electrónicas judiciales y buscador de jurisprudencia del Poder Judicial",
	      entidad: "Corte Suprema de Chile",
	      fecha: "16 de agosto de 2024 (reemplaza al Acta N° 44-2022)",
	      proposito: "Regular la publicidad de las sentencias y carpetas electrónicas resguardando los datos personales y sensibles.",
	      descripcion: "Es la regulación más desarrollada sobre anonimización en Chile. Define la anonimización como la «supresión y reemplazo de datos personales y sensibles que se encuentren contenidos en el texto del fallo, con el fin de resguardar la identidad de las personas titulares de los mismos» (art. 6°). Establece restricciones de acceso al Buscador de Jurisprudencia (art. 3°), ordena publicar anonimizadas las sentencias dictadas en causas que tramiten bajo reserva por protección de datos personales y sensibles (art. 7°), y dispone que este tratamiento no afecta las carpetas electrónicas íntegramente disponibles en la Oficina Judicial Virtual (art. 8°). El Comité Editorial puede ampliar los supuestos de anonimización a otras causas o materias.",
	      url: "https://www.bcn.cl/leychile/navegar?idNorma=1205835"
	    },
	    {
	      cita: "Acta N° 44-2022 y Auto Acordado «Sobre criterios de publicidad de sentencias y carpetas electrónicas»",
	      nombre: "Criterios de publicidad de sentencias y carpetas electrónicas",
	      entidad: "Corte Suprema de Chile",
	      fecha: "15 de febrero de 2022; vigente desde el 1 de julio de 2022 (derogado por el Auto Acordado 164-2024)",
	      proposito: "Primera regulación sistemática de la anonimización total y parcial de sentencias publicadas en el buscador de jurisprudencia.",
	      descripcion: "Instauró la publicación íntegra y sin límite de tiempo de las sentencias con protección de datos (arts. 1° y 2°), distinguiendo la anonimización total (supresión de datos de todas las personas naturales, incluido el caratulado) de la parcial (respecto de menores de edad y víctimas), fijó presupuestos de anonimización previa a la publicación (art. 4°: cambio de nombre o sexo, refugiados, familia, reserva total) y posterior —cumplida la condena— (art. 5°), y creó la anonimización a solicitud de la persona interesada ante la Comisión de Transparencia de la Corte Suprema (art. 6°). Su doctrina fue recogida y actualizada por el Auto Acordado 164-2024.",
	      url: "https://www.pjud.cl/prensa-y-comunicaciones/getRulingNew/11808"
	    },
	    {
	      cita: "Ley N° 21.643 y Decreto N° 21 (2024)",
	      nombre: "Ley Karin y su reglamento de investigación",
	      entidad: "Ministerio del Trabajo y Previsión Social",
	      fecha: "Vigente desde el 1 de agosto de 2024",
	      proposito: "Garantizar la reserva y confidencialidad de las investigaciones de acoso laboral, sexual o de violencia en el trabajo.",
	      descripcion: "La ley exige que la investigación se lleve por escrito y en estricta reserva, remitiéndose con sus conclusiones a la Inspección del Trabajo; el reglamento (Decreto 21) impone al investigador guardar estricta reserva de la información a la que tenga acceso por la investigación y extiende el deber de reserva de los datos privados de las personas trabajadoras (art. 154 ter del Código del Trabajo). En la práctica, el expediente que se deposita ante la Dirección del Trabajo se elabora anonimizado, resguardando la identidad de denunciante, denunciados y testigos — estándar que las plataformas de gestión aplican por diseño.",
	      url: "https://www.bcn.cl/leychile/navegar?idNorma=1204689"
	    }
	  ]
	end

	def self.annm_fallos_corte_suprema
	  [
	    {
	      cita: "Corte Suprema, 6 de enero de 2025, causa rol 18.566-2024",
	      nombre: "Recurso de protección — escaneo de iris de menores de edad (Worldcoin SpA)",
	      entidad: "Corte Suprema de Chile (primera causa; vinculada con la causa rol 35.760-2024 de 7 de enero de 2025)",
	      fecha: "6 y 7 de enero de 2025",
	      proposito: "Proteger los datos personales y sensibles de menores de edad frente a tratamientos tecnológicos masivos.",
	      descripcion: "Ambas sentencias revocan fallos de Cortes de Apelaciones y acogen los recursos de protección contra la recopilación, almacenamiento y tratamiento de datos biométricos de menores mediante el escaneo de sus iris, declarando la infracción de la Ley 19.628 y de las garantías constitucionales (art. 19 N°s 1 y 4 CPR). Relevante para la anonimización: la Corte Suprema consolida que los datos biométricos y los datos de menores exigen protección reforzada, criterio que impone anonimizar o suprimir este tipo de datos antes de cualquier difusión de documentos.",
	      url: "https://academiajudicial.cl/wp-content/uploads/2026/05/El-Nuevo-Sistema-de-Proteccion-de-los-Datos-Personales-1.pdf"
	    },
	    {
	      cita: "Corte Suprema, rol 25.625-2019",
	      nombre: "Doctrina del derecho al olvido en Chile",
	      entidad: "Corte Suprema de Chile",
	      fecha: "2019",
	      proposito: "Reconocer y delimitar el derecho a que cierta información personal deje de ser accesible, aun en ausencia de ley expresa.",
	      descripcion: "Fijó criterios para resolver el conflicto entre privacidad y libertad de información en internet: relevancia pública del dato, tiempo transcurrido, exactitud de la información y daño personal. Es la base jurisprudencial que sustenta la anonimización o desindexación de documentos judiciales y empresariales que exponen datos personales sin contrapeso de interés público.",
	      url: "https://academiajudicial.cl/wp-content/uploads/2026/05/El-Nuevo-Sistema-de-Proteccion-de-los-Datos-Personales-1.pdf"
	    },
	    {
	      cita: "Corte Suprema, 13 de mayo de 2025, recurso de protección contra Destácame SpA",
	      nombre: "Tratamiento de datos personales y scoring laboral",
	      entidad: "Corte Suprema de Chile",
	      fecha: "13 de mayo de 2025",
	      proposito: "Controlar la licitud del tratamiento de datos personales por parte de plataformas privadas que perfilan personas.",
	      descripcion: "Citado como jurisprudencia reciente de autodeterminación informativa en el material docente de la Academia Judicial sobre la nueva ley de datos personales. Incide directamente en la gestión empresarial de documentos: las empresas que administren expedientes o evaluaciones de personas deben asegurar que cualquier difusión o cesión sea compatible con la finalidad original y con los derechos de los titulares, anonimizando la información cuando corresponda.",
	      url: "https://academiajudicial.cl/wp-content/uploads/2026/05/El-Nuevo-Sistema-de-Proteccion-de-los-Datos-Personales-1.pdf"
	    },
	    {
	      cita: "Corte Suprema, rol 6.172-2026",
	      nombre: "Eliminación de publicaciones en redes sociales que afectaban honra y datos personales",
	      entidad: "Corte Suprema de Chile (confirma C.A. Punta Arenas, rol 682-2025)",
	      fecha: "2026",
	      proposito: "Ordenar retirar contenido difundido en redes sociales que expone datos personales y vulnera la honra de una funcionaria.",
	      descripcion: "Confirma el acogimiento del recurso de protección y mantiene la orden de eliminar las publicaciones que exponían la imagen, identidad y datos asociados al desempeño profesional de la recurrente, estimando que las redes sociales no son vía legítima de autotutela. Confirma que la difusión no autorizada de datos personales en soportes digitales es accionable vía recurso de protección, estándar aplicable a la gestión de documentos con datos de trabajadores.",
	      url: "https://actualidadjuridica.doe.cl/corte-suprema-confirma-orden-de-eliminar-publicaciones-en-redes-sociales-que-afectaban-la-honra-y-datos-personales-de-una-funcionaria/"
	    }
	  ]
	end

	def self.annm_docs_complementarios
	  [
	    {
	      cita: "Material docente «El nuevo sistema de protección de los datos personales»",
	      nombre: "Actualización normativa Ley 21.719",
	      entidad: "Academia Judicial – Poder Judicial de Chile",
	      fecha: "2026",
	      proposito: "Difundir el nuevo régimen de protección de datos y su jurisprudencia entre operadores jurisdiccionales.",
	      descripcion: "Documento académico oficial que recopila la doctrina constitucional y legal de protección de datos en Chile, con cita y análisis de los fallos de la Corte Suprema de enero de 2025 (causas Worldcoin), del rol 25.625-2019 (derecho al olvido) y del caso Destácame SpA, además de una comparativa del nuevo régimen chileno con el estándar europeo.",
	      url: "https://academiajudicial.cl/wp-content/uploads/2026/05/El-Nuevo-Sistema-de-Proteccion-de-los-Datos-Personales-1.pdf"
	    },
	    {
	      cita: "Guía de protección de datos personales para instituciones públicas",
	      nombre: "Guía práctica del Consejo para la Transparencia",
	      entidad: "Consejo para la Transparencia",
	      fecha: "Mayo de 2024",
	      proposito: "Orientar la entrega de documentos públicos resguardando los datos personales que contienen.",
	      descripcion: "Desarrolla cómo los órganos públicos deben manejar el secreto estadístico y proteger datos personales al entregar información, tasando o anonimizando los datos que no correspondan hacer públicos. Referencia práctica también útil para empresas que difunden documentos con datos de terceros.",
	      url: "https://www.consejotransparencia.cl/wp-content/uploads/instruccion/2024/05/Guia-proteccio%CC%81n-datos-personales-para-instituciones-pu%CC%81blicas.pdf"
	    },
	    {
	      cita: "Manual de Procedimientos Ley N° 20.285",
	      nombre: "Manual interno de acceso a la información pública",
	      entidad: "Dirección del Trabajo",
	      fecha: "Vigente",
	      proposito: "Regular el procedimiento de atención de solicitudes de acceso a la información, incluida la protección y tacha de datos personales.",
	      descripcion: "Ejemplo de manual institucional que ilustra cómo un organismo público opera la entrega de documentos protegiendo datos personales de terceros, útil como referencia de buenas prácticas para empresas que deben difundir documentos administrativos.",
	      url: "https://www.dt.gob.cl/portal/1626/articles-117137_galeria_38.pdf"
	    }
	  ]
	end

end