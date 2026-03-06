-- Tabla Usuario con checks y unicidad
CREATE TABLE Usuario (
                         id_usuario SERIAL PRIMARY KEY,
                         username VARCHAR(50) UNIQUE NOT NULL,
                         password_hash VARCHAR(255) NOT NULL,
                         email VARCHAR(100) UNIQUE NOT NULL,
                         nombre VARCHAR(100) NOT NULL,
                         telefono VARCHAR(20) CHECK (telefono ~ '^[0-9]{9,20}$'), -- Check para validar que solo contenga números de 9 a 20 dígitos
                         dni VARCHAR(20) UNIQUE CHECK (dni ~ '^[A-Z0-9]+$'), -- Check para validar formato DNI (solo letras y números)
                         rol_usuario VARCHAR(50),
                         activo BOOLEAN DEFAULT TRUE
);

-- Tabla Ubicacion
CREATE TABLE Ubicacion (
                           id_ubicacion SERIAL PRIMARY KEY,
                           nombre_lugar VARCHAR(100) NOT NULL,
                           direccion VARCHAR(200),
                           ciudad VARCHAR(100)
);

-- Tabla Evento con checks
CREATE TABLE Evento (
                        id_evento SERIAL PRIMARY KEY,
                        nombre_evento VARCHAR(100) NOT NULL,
                        descripcion TEXT,
                        id_ubicacion INT REFERENCES Ubicacion(id_ubicacion),
                        capacidad INT NOT NULL CHECK (capacidad > 0), -- Check para que la capacidad sea mayor que 0
                        estado BOOLEAN DEFAULT TRUE,
                        precio DECIMAL(10, 2) CHECK (precio >= 0), -- Check para que el precio no sea negativo
                        fecha_evento DATE NOT NULL CHECK (fecha_evento >= CURRENT_DATE) -- Check para que la fecha sea en el futuro
);

-- Tabla Registro con checks
CREATE TABLE Registro (
                          id_registro SERIAL PRIMARY KEY,
                          id_evento INT REFERENCES Evento(id_evento),
                          id_usuario INT REFERENCES Usuario(id_usuario),
                          fecha_registro DATE NOT NULL CHECK (fecha_registro <= CURRENT_DATE), -- Check para que la fecha de registro no sea en el futuro
                          hora_registro TIME NOT NULL
);

-- Tabla TipoEvento
CREATE TABLE TipoEvento (
                            id_tipo_evento SERIAL PRIMARY KEY,
                            descripcion VARCHAR(100) NOT NULL
);

-- Tabla Organizador con unicidad
CREATE TABLE Organizador (
                             id_organizador SERIAL PRIMARY KEY,
                             nombre_organizador VARCHAR(100) UNIQUE NOT NULL -- Unicidad en el nombre del organizador
);

-- Tabla Organiza
CREATE TABLE Organiza (
                          id_evento INT REFERENCES Evento(id_evento),
                          id_organizador INT REFERENCES Organizador(id_organizador),
                          PRIMARY KEY (id_evento, id_organizador)
);

-- Tabla Requiere con posible nuevo nombre (EventoTipo)
CREATE TABLE EventoTipo (
                            id_evento INT REFERENCES Evento(id_evento),
                            id_tipo_evento INT REFERENCES TipoEvento(id_tipo_evento),
                            PRIMARY KEY (id_evento, id_tipo_evento)
);

-- Tabla Comentarios con DATE
CREATE TABLE Comentarios (
                             id_comentario SERIAL PRIMARY KEY,
                             id_evento INT REFERENCES Evento(id_evento),
                             id_usuario INT REFERENCES Usuario(id_usuario),
                             comentario TEXT NOT NULL,
                             fecha_comentario DATE DEFAULT CURRENT_DATE -- Uso de DATE en lugar de TIMESTAMP
);

-- Nueva tabla Artista
CREATE TABLE Artista (
                         id_artista SERIAL PRIMARY KEY,
                         nombre_artista VARCHAR(100) NOT NULL,
                         bio TEXT,
                         genero VARCHAR(50)
);

-- Nueva tabla EventoArtista
CREATE TABLE EventoArtista (
                               id_evento INT REFERENCES Evento(id_evento),
                               id_artista INT REFERENCES Artista(id_artista),
                               PRIMARY KEY (id_evento, id_artista)
);


INSERT INTO Usuario (username, password_hash, email, nombre, telefono, dni, rol_usuario, activo)
VALUES
    ('juanperez', 'hashed_password_1', 'juan.perez@example.com', 'Juan Perez', '600123456', '12345678A', 'Usuario', TRUE),
    ('mariagomez', 'hashed_password_2', 'maria.gomez@example.com', 'Maria Gomez', '610234567', '87654321B', 'Usuario', TRUE),
    ('pedrosanchez', 'hashed_password_3', 'pedro.sanchez@example.com', 'Pedro Sanchez', '620345678', '45678901C', 'Admin', TRUE),
    ('anaruiz', 'hashed_password_4', 'ana.ruiz@example.com', 'Ana Ruiz', '630456789', '98765432D', 'Usuario', TRUE),
    ('luisgarcia', 'hashed_password_5', 'luis.garcia@example.com', 'Luis Garcia', '640567890', '23456789E', 'Usuario', TRUE),
    ('carlamartinez', 'hashed_password_6', 'carla.martinez@example.com', 'Carla Martinez', '650678901', '34567890F', 'Usuario', TRUE),
    ('manuellopez', 'hashed_password_7', 'manuel.lopez@example.com', 'Manuel Lopez', '660789012', '12389012G', 'Usuario', TRUE),
    ('josearodriguez', 'hashed_password_8', 'jose.rodriguez@example.com', 'Jose Rodriguez', '670890123', '09876543H', 'Admin', TRUE),
    ('albertosantos', 'hashed_password_9', 'alberto.santos@example.com', 'Alberto Santos', '680901234', '45671234J', 'Usuario', TRUE),
    ('pablodiaz', 'hashed_password_10', 'pablo.diaz@example.com', 'Pablo Diaz', '690123456', '23456712K', 'Usuario', TRUE),
    ('martagil', 'hashed_password_11', 'marta.gil@example.com', 'Marta Gil', '700234567', '87650123L', 'Usuario', TRUE),
    ('franciscomora', 'hashed_password_12', 'francisco.mora@example.com', 'Francisco Mora', '710345678', '87654312M', 'Admin', TRUE),
    ('laurafernandez', 'hashed_password_13', 'laura.fernandez@example.com', 'Laura Fernandez', '720456789', '43210987N', 'Usuario', TRUE),
    ('javiermartin', 'hashed_password_14', 'javier.martin@example.com', 'Javier Martin', '730567890', '98765432P', 'Usuario', TRUE),
    ('monicalopez', 'hashed_password_15', 'monica.lopez@example.com', 'Monica Lopez', '740678901', '34567123Q', 'Usuario', TRUE),
    ('santiagotorres', 'hashed_password_16', 'santiago.torres@example.com', 'Santiago Torres', '750789012', '89012345R', 'Usuario', TRUE),
    ('nataliasanchez', 'hashed_password_17', 'natalia.sanchez@example.com', 'Natalia Sanchez', '760890123', '12345678S', 'Admin', TRUE),
    ('andreamolina', 'hashed_password_18', 'andrea.molina@example.com', 'Andrea Molina', '770901234', '56789012T', 'Usuario', TRUE),
    ('ricardoruiz', 'hashed_password_19', 'ricardo.ruiz@example.com', 'Ricardo Ruiz', '780123456', '78901234U', 'Usuario', TRUE),
    ('cristinajimenez', 'hashed_password_20', 'cristina.jimenez@example.com', 'Cristina Jimenez', '790234567', '98712345V', 'Usuario', TRUE);


INSERT INTO Artista (nombre_artista, bio, genero)
VALUES
    ('Luis Fonsi', 'Cantante y compositor puertorriqueño, famoso por su éxito "Despacito".', 'Pop Latino'),
    ('Rosalía', 'Artista española que ha revolucionado el flamenco con influencias del reggaetón y pop.', 'Flamenco Pop'),
    ('Shakira', 'Cantante colombiana conocida por su mezcla de pop y música latina. Ganadora de múltiples premios Grammy.', 'Pop Latino'),
    ('Daddy Yankee', 'Uno de los pioneros del reggaetón. Conocido por éxitos como "Gasolina".', 'Reggaetón'),
    ('J Balvin', 'Artista colombiano, destacado en el género del reggaetón y música urbana.', 'Reggaetón'),
    ('Alejandro Sanz', 'Cantautor español ganador de múltiples premios Grammy. Conocido por su estilo romántico y flamenco.', 'Pop Flamenco'),
    ('Bad Bunny', 'Rapero y cantante puertorriqueño, uno de los mayores exponentes del trap latino.', 'Trap Latino'),
    ('Camila Cabello', 'Cantante y compositora cubano-estadounidense. Exintegrante de Fifth Harmony.', 'Pop'),
    ('Enrique Iglesias', 'Cantante español conocido internacionalmente. Ha vendido más de 180 millones de discos.', 'Pop Latino'),
    ('Marc Anthony', 'Cantante estadounidense de origen puertorriqueño, conocido por sus baladas y salsa.', 'Salsa'),
    ('Ozuna', 'Cantante puertorriqueño destacado en el reggaetón y la música urbana.', 'Reggaetón'),
    ('Pablo Alborán', 'Cantautor español de pop romántico con múltiples éxitos en las listas de música.', 'Pop'),
    ('Maluma', 'Cantante colombiano, uno de los mayores exponentes del reggaetón y pop urbano.', 'Reggaetón'),
    ('Juanes', 'Cantante colombiano conocido por mezclar pop latino con rock y ritmos tradicionales.', 'Rock Latino'),
    ('Carlos Vives', 'Cantante colombiano que ha fusionado la música tradicional de su país con pop y rock.', 'Vallenato Pop'),
    ('Sebastián Yatra', 'Cantante y compositor colombiano conocido por su música pop con influencias de reggaetón.', 'Pop Latino'),
    ('Nathy Peluso', 'Cantante argentina que mezcla hip-hop, jazz y música latina en sus composiciones.', 'Hip-hop Latino'),
    ('Lola Indigo', 'Cantante española que combina pop y reggaetón, exconcursante de Operación Triunfo.', 'Pop Urbano'),
    ('Anuel AA', 'Cantante puertorriqueño, pionero del trap latino. Conocido por éxitos como "China".', 'Trap Latino'),
    ('Becky G', 'Cantante y actriz estadounidense, conocida por su música pop y reggaetón.', 'Reggaetón');


INSERT INTO Ubicacion (nombre_lugar, direccion, ciudad)
VALUES
    ('Auditorio Nacional', 'Calle Príncipe de Vergara, 146', 'Madrid'),
    ('Palacio de los Deportes', 'Avenida de Felipe II, s/n', 'Madrid'),
    ('Estadio Wanda Metropolitano', 'Avenida de Luis Aragonés, 4', 'Madrid'),
    ('WiZink Center', 'Calle Jorge Juan, 99', 'Madrid'),
    ('Teatro Colón', 'Calle Cerrito, 628', 'Buenos Aires'),
    ('Luna Park', 'Avenida Madero, 420', 'Buenos Aires'),
    ('Movistar Arena', 'Av. Humboldt, 450', 'Santiago'),
    ('Teatro Caupolicán', 'San Diego, 850', 'Santiago'),
    ('Estadio Nacional', 'Av. Grecia, 2001', 'Santiago'),
    ('Foro Sol', 'Viaducto Río de la Piedad y Río Churubusco, s/n', 'Ciudad de México'),
    ('Auditorio Telmex', 'Parres Arias, 1241', 'Guadalajara'),
    ('Estadio Azteca', 'Calzada de Tlalpan, 3465', 'Ciudad de México'),
    ('Teatro Metropolitan', 'Avenida Independencia, 90', 'Ciudad de México'),
    ('Palacio de Bellas Artes', 'Avenida Juárez, Centro Histórico', 'Ciudad de México'),
    ('Madison Square Garden', '4 Pennsylvania Plaza', 'New York'),
    ('Radio City Music Hall', '1260 6th Ave', 'New York'),
    ('O2 Arena', 'Peninsula Square', 'Londres'),
    ('Royal Albert Hall', 'Kensington Gore', 'Londres'),
    ('Arena Ciudad de México', 'Avenida de las Granjas, 800', 'Ciudad de México'),
    ('Parque Simón Bolívar', 'Avenida Calle 63 y Carrera 60', 'Bogotá');


INSERT INTO TipoEvento (descripcion)
VALUES
    ('Concierto'),
    ('Conferencia'),
    ('Festival'),
    ('Exposición de arte'),
    ('Teatro'),
    ('Deportes'),
    ('Seminario'),
    ('Feria comercial'),
    ('Evento benéfico'),
    ('Proyección de película');


INSERT INTO Organizador (nombre_organizador)
VALUES
    ('Live Nation Entertainment'),
    ('Ocesa'),
    ('AEG Presents'),
    ('DG Medios'),
    ('Stage Entertainment'),
    ('Rock Nation'),
    ('Proactiv Entertainment'),
    ('Eventos Mistral'),
    ('Global Productions'),
    ('Eventos XYZ');


INSERT INTO Evento (nombre_evento, descripcion, id_ubicacion, capacidad, estado, precio, fecha_evento)
VALUES
    ('Concierto de Luis Fonsi', 'Disfruta de los grandes éxitos de Luis Fonsi en vivo.', 1, 5000, TRUE, 50.00, '2024-11-10'),
    ('Festival de Música Urbana', 'Un festival que reúne a los mejores exponentes del reggaetón y trap.', 2, 10000, TRUE, 80.00, '2024-12-05'),
    ('Exposición de Arte Moderno', 'Una muestra de las obras más destacadas del arte contemporáneo.', 3, 2000, TRUE, 30.00, '2024-12-20'),
    ('Teatro Clásico: Romeo y Julieta', 'Representación de la obra clásica de Shakespeare.', 4, 1200, TRUE, 25.00, '2024-10-15'),
    ('Conferencia de Innovación Tecnológica', 'Un evento donde se debatirá el futuro de la tecnología.', 5, 1500, TRUE, 20.00, '2024-11-02'),
    ('Concierto de Rosalía', 'Vive una experiencia única con Rosalía en concierto.', 6, 8000, TRUE, 75.00, '2024-12-01'),
    ('Proyección de Película: El Padrino', 'Revivir el clásico del cine con una proyección especial.', 7, 1800, TRUE, 15.00, '2024-10-25'),
    ('Festival de Salsa con Marc Anthony', 'Un festival de salsa liderado por Marc Anthony y otros artistas.', 8, 10000, TRUE, 90.00, '2024-11-15'),
    ('Concierto de Shakira', 'Shakira vuelve a los escenarios con sus grandes éxitos.', 9, 5000, TRUE, 60.00, '2024-11-22'),
    ('Seminario de Liderazgo Empresarial', 'Un seminario dedicado a fortalecer el liderazgo en empresas.', 10, 2500, TRUE, 45.00, '2024-11-30'),
    ('Feria Comercial de Tecnología', 'Una feria con las últimas innovaciones tecnológicas.', 11, 3000, TRUE, 10.00, '2024-11-18'),
    ('Conferencia de Emprendimiento', 'Talleres y conferencias sobre cómo emprender con éxito.', 12, 2000, TRUE, 30.00, '2024-12-10'),
    ('Festival Gastronómico Internacional', 'Descubre los sabores del mundo en este festival gastronómico.', 13, 5000, TRUE, 50.00, '2024-12-22'),
    ('Teatro Moderno: Hamlet', 'Una nueva versión del clásico de Shakespeare.', 14, 1500, TRUE, 40.00, '2024-10-30'),
    ('Concierto de Bad Bunny', 'Bad Bunny presentará su último álbum en vivo.', 15, 15000, TRUE, 100.00, '2024-11-25'),
    ('Feria del Libro', 'Una feria dedicada a la literatura y autores contemporáneos.', 16, 8000, TRUE, 0.00, '2024-12-12'),
    ('Festival de Cine Latinoamericano', 'Proyecciones de las mejores películas del cine latino.', 17, 2500, TRUE, 20.00, '2024-11-28'),
    ('Evento Benéfico para la Educación', 'Un evento solidario con recaudación para la educación.', 18, 6000, TRUE, 0.00, '2024-12-05'),
    ('Concierto de J Balvin', 'Disfruta de los éxitos de J Balvin en vivo.', 19, 12000, TRUE, 80.00, '2024-11-10'),
    ('Concierto de Camila Cabello', 'Camila Cabello en su nueva gira mundial.', 20, 10000, TRUE, 70.00, '2024-12-03'),
    ('Festival de Rock con Juanes', 'Un festival que reúne lo mejor del rock latino con Juanes.', 1, 10000, TRUE, 90.00, '2024-12-15'),
    ('Conferencia sobre Cambio Climático', 'Un espacio para debatir soluciones al cambio climático.', 2, 5000, TRUE, 25.00, '2024-11-12'),
    ('Exposición de Fotografía', 'Muestra de las mejores fotografías contemporáneas.', 3, 2000, TRUE, 30.00, '2024-12-19'),
    ('Proyección de Película: Interestelar', 'Proyección especial del clásico de ciencia ficción.', 4, 1800, TRUE, 20.00, '2024-11-14'),
    ('Concierto de Maluma', 'Maluma llega con su gira de reggaetón y pop urbano.', 5, 15000, TRUE, 85.00, '2024-11-29'),
    ('Festival de Jazz', 'Un festival que reúne a los mejores músicos de jazz del mundo.', 6, 3000, TRUE, 60.00, '2024-11-08'),
    ('Seminario de Desarrollo Personal', 'Una oportunidad para crecer personal y profesionalmente.', 7, 1200, TRUE, 35.00, '2024-12-09'),
    ('Festival de Música Electrónica', 'Un evento para los amantes de la música electrónica.', 8, 8000, TRUE, 100.00, '2024-12-20'),
    ('Teatro: La Casa de Bernarda Alba', 'Representación de la obra clásica de Federico García Lorca.', 9, 2000, TRUE, 50.00, '2024-12-01'),
    ('Evento Benéfico para la Salud', 'Recaudación de fondos para la investigación en salud.', 10, 5000, TRUE, 0.00, '2024-11-18'),
    ('Festival Internacional de Ballet', 'Un evento que reúne a los mejores bailarines de ballet.', 11, 3000, TRUE, 70.00, '2024-12-14'),
    ('Conferencia de Inteligencia Artificial', 'Debate sobre el futuro de la IA en la sociedad.', 12, 1500, TRUE, 40.00, '2024-11-27'),
    ('Concierto de Pablo Alborán', 'El cantautor español Pablo Alborán en concierto.', 13, 8000, TRUE, 55.00, '2024-11-30'),
    ('Proyección de Película: Avatar', 'Proyección especial del éxito de James Cameron.', 14, 1200, TRUE, 18.00, '2024-12-15'),
    ('Concierto de Sebastián Yatra', 'Sebastián Yatra presenta su último álbum en vivo.', 15, 10000, TRUE, 65.00, '2024-12-09'),
    ('Seminario de Ciberseguridad', 'Un seminario sobre las mejores prácticas de seguridad digital.', 16, 3000, TRUE, 25.00, '2024-11-16'),
    ('Festival de Música Indie', 'Un festival para los amantes de la música independiente.', 17, 4000, TRUE, 40.00, '2024-12-03'),
    ('Concierto de Nathy Peluso', 'Nathy Peluso en concierto presentando su nuevo disco.', 18, 8000, TRUE, 55.00, '2024-12-21'),
    ('Concierto de Alejandro Sanz', 'Alejandro Sanz en su gira mundial.', 19, 15000, TRUE, 100.00, '2024-12-10'),
    ('Teatro Moderno: Don Juan Tenorio', 'Una nueva versión de la obra clásica.', 20, 2000, TRUE, 45.00, '2024-11-22');
INSERT INTO Evento (nombre_evento, descripcion, id_ubicacion, capacidad, estado, precio, fecha_evento)
VALUES
    ('Festival de Música Clásica', 'Una noche dedicada a los grandes compositores de la música clásica.', 1, 3000, TRUE, 50.00, '2024-12-27'),
    ('Conferencia de Robótica', 'Descubre el futuro de la robótica en este evento único.', 2, 4000, TRUE, 30.00, '2024-11-21'),
    ('Exposición de Escultura Contemporánea', 'Esculturas de artistas emergentes en un entorno vanguardista.', 3, 1500, TRUE, 20.00, '2024-12-25'),
    ('Teatro Infantil: El Mago de Oz', 'Una representación teatral para toda la familia.', 4, 1000, TRUE, 10.00, '2024-11-14'),
    ('Festival de Música Alternativa', 'Las mejores bandas de música alternativa en un solo lugar.', 5, 8000, TRUE, 70.00, '2024-11-26'),
    ('Concierto de Enrique Iglesias', 'Enrique Iglesias en vivo con sus éxitos internacionales.', 6, 12000, TRUE, 85.00, '2024-12-13'),
    ('Feria de Empleo', 'Una feria dedicada a conectar empresas con talento emergente.', 7, 2000, TRUE, 0.00, '2024-11-09'),
    ('Festival de Hip Hop', 'El evento definitivo para los amantes del Hip Hop.', 8, 10000, TRUE, 60.00, '2024-12-11'),
    ('Concierto de Aitana', 'Aitana en concierto presentando su nuevo álbum.', 9, 8000, TRUE, 75.00, '2024-11-29'),
    ('Seminario de Marketing Digital', 'Conoce las últimas estrategias en marketing digital.', 10, 3500, TRUE, 40.00, '2024-11-19'),
    ('Festival de Música Tropical', 'Una fiesta con los mejores exponentes de la música tropical.', 11, 5000, TRUE, 55.00, '2024-12-03'),
    ('Concierto de Mon Laferte', 'Mon Laferte en concierto con sus baladas y éxitos latinos.', 12, 7000, TRUE, 65.00, '2024-12-14'),
    ('Feria del Automóvil', 'Descubre las últimas novedades en el mundo del automóvil.', 13, 10000, TRUE, 10.00, '2024-11-24'),
    ('Exposición de Arte Digital', 'Un recorrido por las obras más innovadoras del arte digital.', 14, 2000, TRUE, 25.00, '2024-12-04'),
    ('Concierto de Morat', 'La banda colombiana Morat en su gira por Europa.', 15, 15000, TRUE, 85.00, '2024-12-07'),
    ('Seminario de Desarrollo de Videojuegos', 'Aprende sobre las últimas tecnologías en videojuegos.', 16, 4000, TRUE, 35.00, '2024-11-23'),
    ('Festival de Cine Documental', 'Un evento para los amantes del cine documental.', 17, 2500, TRUE, 20.00, '2024-12-19'),
    ('Feria de Artesanía', 'Encuentra productos hechos a mano por artesanos locales.', 18, 5000, TRUE, 15.00, '2024-12-08'),
    ('Concierto de Daddy Yankee', 'Daddy Yankee en concierto en su gira de despedida.', 19, 18000, TRUE, 90.00, '2024-12-22'),
    ('Festival de Música Reggae', 'El mejor reggae en un evento único.', 20, 7000, TRUE, 50.00, '2024-11-30'),
    ('Teatro: El Fantasma de la Ópera', 'Una versión moderna del clásico de la literatura.', 1, 3000, TRUE, 45.00, '2024-12-18'),
    ('Concierto de C. Tangana', 'C. Tangana en concierto con su último disco.', 2, 15000, TRUE, 75.00, '2024-12-02'),
    ('Feria de Diseño Gráfico', 'Descubre las últimas tendencias en diseño gráfico.', 3, 2500, TRUE, 20.00, '2024-12-07'),
    ('Concierto de Anuel AA', 'Anuel AA presenta su nueva música en directo.', 4, 12000, TRUE, 80.00, '2024-12-10'),
    ('Festival de Música Electrónica', 'Disfruta de los mejores DJs de música electrónica.', 5, 15000, TRUE, 100.00, '2024-12-16'),
    ('Concierto de TINI', 'TINI en vivo presentando su nueva gira.', 6, 9000, TRUE, 70.00, '2024-11-25'),
    ('Feria de Innovación Tecnológica', 'Explora lo último en innovación y tecnología.', 7, 4000, TRUE, 25.00, '2024-12-13'),
    ('Teatro: Bodas de Sangre', 'Representación de la obra clásica de Federico García Lorca.', 8, 2000, TRUE, 30.00, '2024-12-17'),
    ('Concierto de Ozuna', 'Ozuna en concierto con su nuevo álbum.', 9, 12000, TRUE, 85.00, '2024-12-09'),
    ('Feria de Tecnología Educativa', 'Descubre las herramientas más innovadoras para la educación.', 10, 3500, TRUE, 20.00, '2024-11-28'),
    ('Festival de Música Pop', 'Un evento con las mejores bandas y solistas de música pop.', 11, 10000, TRUE, 75.00, '2024-11-23'),
    ('Seminario de Desarrollo Web', 'Aprende las últimas técnicas para crear aplicaciones web.', 12, 1500, TRUE, 30.00, '2024-12-04'),
    ('Concierto de Becky G', 'Becky G en su gira mundial presentando su nuevo álbum.', 13, 9000, TRUE, 65.00, '2024-12-19'),
    ('Feria de Cine y Animación', 'Un evento para los entusiastas del cine y la animación.', 14, 3000, TRUE, 25.00, '2024-12-21'),
    ('Concierto de Reik', 'Reik en concierto con su último disco.', 15, 12000, TRUE, 70.00, '2024-11-27'),
    ('Festival de Innovación y Emprendimiento', 'Un espacio para los emprendedores y la innovación.', 16, 5000, TRUE, 35.00, '2024-11-15'),
    ('Festival Internacional de Danza', 'Los mejores exponentes de la danza contemporánea.', 17, 2500, TRUE, 45.00, '2024-11-20'),
    ('Concierto de Carlos Vives', 'Carlos Vives en concierto con su mezcla única de vallenato y pop.', 18, 10000, TRUE, 75.00, '2024-11-17'),
    ('Concierto de Maná', 'Maná regresa a los escenarios con sus grandes éxitos.', 19, 18000, TRUE, 90.00, '2024-12-14'),
    ('Feria de Robótica y Automatización', 'Explora los avances más recientes en robótica y automatización.', 20, 4000, TRUE, 30.00, '2024-12-29');

-- Conciertos y festivales de música
INSERT INTO EventoArtista (id_evento, id_artista) VALUES
                                                      (1, 1), (1, 2), (2, 3),
                                                      (5, 4), (5, 5),
                                                      (6, 6), (6, 7),
                                                      (8, 8), (8, 9),
                                                      (9, 10),
                                                      (11, 11), (11, 12),
                                                      (12, 13),
                                                      (15, 14), (15, 15),
                                                      (19, 16), (19, 17),
                                                      (20, 18), (20, 19),
                                                      (22, 20),
                                                      (25, 1), (25, 2),
                                                      (27, 3), (27, 4),
                                                      (28, 5),
                                                      (30, 6), (30, 7),
                                                      (31, 8),
                                                      (33, 9), (33, 10),
                                                      (36, 11),
                                                      (39, 12), (39, 13),
                                                      (41, 14),
                                                      (43, 15),
                                                      (46, 16), (46, 17),
                                                      (48, 18), (48, 19),
                                                      (51, 20),
                                                      (53, 1), (53, 2),
                                                      (55, 3),
                                                      (58, 4), (58, 5),
                                                      (60, 6),
                                                      (63, 7), (63, 8),
                                                      (66, 9), (66, 10),
                                                      (68, 11),
                                                      (71, 12), (71, 13),
                                                      (73, 14),
                                                      (75, 15), (75, 16),
                                                      (78, 17), (78, 18),
                                                      (80, 19);

-- Exposiciones, seminarios y conferencias
INSERT INTO EventoArtista (id_evento, id_artista) VALUES
                                                      (3, 3),
                                                      (4, 5),
                                                      (7, 7),
                                                      (10, 9),
                                                      (13, 11),
                                                      (14, 14),
                                                      (16, 15),
                                                      (17, 17),
                                                      (18, 19),
                                                      (21, 1),
                                                      (23, 4),
                                                      (26, 6),
                                                      (29, 8),
                                                      (32, 10),
                                                      (34, 12),
                                                      (35, 13),
                                                      (37, 15),
                                                      (38, 17),
                                                      (40, 18),
                                                      (42, 2),
                                                      (44, 3),
                                                      (47, 5),
                                                      (49, 7),
                                                      (50, 9),
                                                      (52, 11),
                                                      (54, 13),
                                                      (56, 14),
                                                      (57, 16),
                                                      (59, 18),
                                                      (61, 19),
                                                      (62, 1),
                                                      (64, 3),
                                                      (65, 4),
                                                      (67, 6),
                                                      (69, 8),
                                                      (70, 10),
                                                      (72, 12),
                                                      (74, 13),
                                                      (76, 15),
                                                      (77, 17),
                                                      (79, 20);

-- Asignación de organizadores a los eventos, entre 1 y 3 por evento
INSERT INTO Organiza (id_evento, id_organizador) VALUES
                                                     (1, 1), (1, 2), (1, 3),
                                                     (2, 4), (2, 5),
                                                     (3, 6), (3, 7), (3, 8),
                                                     (4, 9),
                                                     (5, 10), (5, 1),
                                                     (6, 2), (6, 3), (6, 4),
                                                     (7, 5),
                                                     (8, 6), (8, 7),
                                                     (9, 8), (9, 9),
                                                     (10, 10), (10, 1), (10, 2),
                                                     (11, 3),
                                                     (12, 4), (12, 5), (12, 6),
                                                     (13, 7),
                                                     (14, 8), (14, 9),
                                                     (15, 10), (15, 1),
                                                     (16, 2), (16, 3), (16, 4),
                                                     (17, 5),
                                                     (18, 6), (18, 7),
                                                     (19, 8), (19, 9),
                                                     (20, 10), (20, 1), (20, 2),
                                                     (21, 3),
                                                     (22, 4), (22, 5),
                                                     (23, 6), (23, 7), (23, 8),
                                                     (24, 9),
                                                     (25, 10), (25, 1),
                                                     (26, 2), (26, 3),
                                                     (27, 4), (27, 5), (27, 6),
                                                     (28, 7),
                                                     (29, 8), (29, 9),
                                                     (30, 10), (30, 1),
                                                     (31, 2), (31, 3),
                                                     (32, 4), (32, 5), (32, 6),
                                                     (33, 7),
                                                     (34, 8), (34, 9),
                                                     (35, 10), (35, 1),
                                                     (36, 2), (36, 3), (36, 4),
                                                     (37, 5),
                                                     (38, 6), (38, 7),
                                                     (39, 8), (39, 9),
                                                     (40, 10), (40, 1), (40, 2),
                                                     (41, 3),
                                                     (42, 4), (42, 5),
                                                     (43, 6), (43, 7), (43, 8),
                                                     (44, 9),
                                                     (45, 10), (45, 1),
                                                     (46, 2), (46, 3),
                                                     (47, 4), (47, 5), (47, 6),
                                                     (48, 7),
                                                     (49, 8), (49, 9),
                                                     (50, 10), (50, 1),
                                                     (51, 2), (51, 3),
                                                     (52, 4), (52, 5), (52, 6),
                                                     (53, 7),
                                                     (54, 8), (54, 9),
                                                     (55, 10), (55, 1),
                                                     (56, 2), (56, 3), (56, 4),
                                                     (57, 5),
                                                     (58, 6), (58, 7),
                                                     (59, 8), (59, 9),
                                                     (60, 10), (60, 1), (60, 2),
                                                     (61, 3),
                                                     (62, 4), (62, 5),
                                                     (63, 6), (63, 7), (63, 8),
                                                     (64, 9),
                                                     (65, 10), (65, 1),
                                                     (66, 2), (66, 3),
                                                     (67, 4), (67, 5), (67, 6),
                                                     (68, 7),
                                                     (69, 8), (69, 9),
                                                     (70, 10), (70, 1),
                                                     (71, 2), (71, 3),
                                                     (72, 4), (72, 5), (72, 6),
                                                     (73, 7),
                                                     (74, 8), (74, 9),
                                                     (75, 10), (75, 1),
                                                     (76, 2), (76, 3), (76, 4),
                                                     (77, 5),
                                                     (78, 6), (78, 7),
                                                     (79, 8), (79, 9),
                                                     (80, 10), (80, 1), (80, 2);

-- Asignación de tipos de eventos a los eventos, entre 1 y 2 por evento
INSERT INTO EventoTipo (id_evento, id_tipo_evento) VALUES
                                                       (1, 1), (1, 2),
                                                       (2, 3), (2, 4),
                                                       (3, 5), (3, 1),
                                                       (4, 2),
                                                       (5, 3), (5, 4),
                                                       (6, 1),
                                                       (7, 5), (7, 6),
                                                       (8, 2),
                                                       (9, 3), (9, 7),
                                                       (10, 8), (10, 1),
                                                       (11, 9),
                                                       (12, 10), (12, 2),
                                                       (13, 1), (13, 3),
                                                       (14, 4),
                                                       (15, 6), (15, 7),
                                                       (16, 8),
                                                       (17, 1), (17, 2),
                                                       (18, 3),
                                                       (19, 9), (19, 10),
                                                       (20, 1),
                                                       (21, 5), (21, 6),
                                                       (22, 3),
                                                       (23, 4), (23, 7),
                                                       (24, 2),
                                                       (25, 9), (25, 10),
                                                       (26, 1),
                                                       (27, 2), (27, 3),
                                                       (28, 4),
                                                       (29, 5), (29, 6),
                                                       (30, 7), (30, 8),
                                                       (31, 2),
                                                       (32, 1), (32, 9),
                                                       (33, 5),
                                                       (34, 3), (34, 7),
                                                       (35, 8),
                                                       (36, 9), (36, 1),
                                                       (37, 4),
                                                       (38, 2), (38, 5),
                                                       (39, 6), (39, 7),
                                                       (40, 10),
                                                       (41, 9), (41, 3),
                                                       (42, 8),
                                                       (43, 1), (43, 2),
                                                       (44, 6),
                                                       (45, 4), (45, 5),
                                                       (46, 10),
                                                       (47, 3), (47, 9),
                                                       (48, 2),
                                                       (49, 8), (49, 7),
                                                       (50, 1),
                                                       (51, 5), (51, 10),
                                                       (52, 9),
                                                       (53, 3), (53, 4),
                                                       (54, 6),
                                                       (55, 2), (55, 1),
                                                       (56, 8),
                                                       (57, 9), (57, 7),
                                                       (58, 10),
                                                       (59, 4), (59, 5),
                                                       (60, 1),
                                                       (61, 2), (61, 3),
                                                       (62, 6),
                                                       (63, 5), (63, 10),
                                                       (64, 9),
                                                       (65, 8), (65, 7),
                                                       (66, 2),
                                                       (67, 4), (67, 3),
                                                       (68, 5),
                                                       (69, 10), (69, 9),
                                                       (70, 1),
                                                       (71, 3), (71, 2),
                                                       (72, 7),
                                                       (73, 9), (73, 10),
                                                       (74, 4),
                                                       (75, 6), (75, 5),
                                                       (76, 2),
                                                       (77, 8), (77, 1),
                                                       (78, 3),
                                                       (79, 7), (79, 6),
                                                       (80, 4), (80, 10);

-- Usuario 1 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (1, 1, '2024-09-01', '10:00'),
    (2, 1, '2024-09-02', '11:00'),
    (3, 1, '2024-09-03', '12:00'),
    (4, 1, '2024-09-04', '13:00'),
    (5, 1, '2024-09-05', '14:00'),
    (6, 1, '2024-09-06', '15:00'),
    (7, 1, '2024-09-07', '16:00'),
    (8, 1, '2024-09-08', '17:00'),
    (9, 1, '2024-09-09', '18:00'),
    (10, 1, '2024-09-10', '19:00'),
    (11, 1, '2024-09-11', '20:00'),
    (12, 1, '2024-09-12', '21:00'),
    (13, 1, '2024-09-13', '10:30'),
    (14, 1, '2024-09-14', '11:30'),
    (15, 1, '2024-09-15', '12:30'),
    (16, 1, '2024-09-16', '13:30'),
    (17, 1, '2024-09-17', '14:30'),
    (18, 1, '2024-09-18', '15:30'),
    (19, 1, '2024-09-19', '16:30'),
    (20, 1, '2024-09-20', '17:30');

-- Usuario 2 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (2, 2, '2024-09-02', '11:00'),
    (3, 2, '2024-09-03', '12:00'),
    (4, 2, '2024-09-04', '13:00'),
    (5, 2, '2024-09-05', '14:00'),
    (6, 2, '2024-09-06', '15:00'),
    (7, 2, '2024-09-07', '16:00'),
    (8, 2, '2024-09-08', '17:00'),
    (9, 2, '2024-09-09', '18:00'),
    (10, 2, '2024-09-10', '19:00'),
    (11, 2, '2024-09-11', '20:00'),
    (12, 2, '2024-09-12', '21:00'),
    (13, 2, '2024-09-13', '10:30'),
    (14, 2, '2024-09-14', '11:30'),
    (15, 2, '2024-09-15', '12:30'),
    (16, 2, '2024-09-16', '13:30'),
    (17, 2, '2024-09-17', '14:30'),
    (18, 2, '2024-09-18', '15:30'),
    (19, 2, '2024-09-19', '16:30'),
    (20, 2, '2024-09-20', '17:30'),
    (21, 2, '2024-09-21', '18:30');

-- Usuario 3 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (3, 3, '2024-09-03', '12:00'),
    (4, 3, '2024-09-04', '13:00'),
    (5, 3, '2024-09-05', '14:00'),
    (6, 3, '2024-09-06', '15:00'),
    (7, 3, '2024-09-07', '16:00'),
    (8, 3, '2024-09-08', '17:00'),
    (9, 3, '2024-09-09', '18:00'),
    (10, 3, '2024-09-10', '19:00'),
    (11, 3, '2024-09-11', '20:00'),
    (12, 3, '2024-09-12', '21:00'),
    (13, 3, '2024-09-13', '10:30'),
    (14, 3, '2024-09-14', '11:30'),
    (15, 3, '2024-09-15', '12:30'),
    (16, 3, '2024-09-16', '13:30'),
    (17, 3, '2024-09-17', '14:30'),
    (18, 3, '2024-09-18', '15:30'),
    (19, 3, '2024-09-19', '16:30'),
    (20, 3, '2024-09-20', '17:30'),
    (21, 3, '2024-09-21', '18:30'),
    (22, 3, '2024-09-22', '19:30');

-- Usuario 4 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (4, 4, '2024-09-04', '13:00'),
    (5, 4, '2024-09-05', '14:00'),
    (6, 4, '2024-09-06', '15:00'),
    (7, 4, '2024-09-07', '16:00'),
    (8, 4, '2024-09-08', '17:00'),
    (9, 4, '2024-09-09', '18:00'),
    (10, 4, '2024-09-10', '19:00'),
    (11, 4, '2024-09-11', '20:00'),
    (12, 4, '2024-09-12', '21:00'),
    (13, 4, '2024-09-13', '10:30'),
    (14, 4, '2024-09-14', '11:30'),
    (15, 4, '2024-09-15', '12:30'),
    (16, 4, '2024-09-16', '13:30'),
    (17, 4, '2024-09-17', '14:30'),
    (18, 4, '2024-09-18', '15:30'),
    (19, 4, '2024-09-19', '16:30'),
    (20, 4, '2024-09-20', '17:30'),
    (21, 4, '2024-09-21', '18:30'),
    (22, 4, '2024-09-22', '19:30'),
    (23, 4, '2024-09-23', '20:30');

-- Usuario 5 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (5, 5, '2024-09-05', '14:00'),
    (6, 5, '2024-09-06', '15:00'),
    (7, 5, '2024-09-07', '16:00'),
    (8, 5, '2024-09-08', '17:00'),
    (9, 5, '2024-09-09', '18:00'),
    (10, 5, '2024-09-10', '19:00'),
    (11, 5, '2024-09-11', '20:00'),
    (12, 5, '2024-09-12', '21:00'),
    (13, 5, '2024-09-13', '10:30'),
    (14, 5, '2024-09-14', '11:30'),
    (15, 5, '2024-09-15', '12:30'),
    (16, 5, '2024-09-16', '13:30'),
    (17, 5, '2024-09-17', '14:30'),
    (18, 5, '2024-09-18', '15:30'),
    (19, 5, '2024-09-19', '16:30'),
    (20, 5, '2024-09-20', '17:30'),
    (21, 5, '2024-09-21', '18:30'),
    (22, 5, '2024-09-22', '19:30'),
    (23, 5, '2024-09-23', '20:30'),
    (24, 5, '2024-09-24', '21:30');

-- Usuario 6 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (1, 6, '2024-09-05', '14:00'),
    (3, 6, '2024-09-06', '15:00'),
    (8, 6, '2024-09-07', '16:00'),
    (12, 6, '2024-09-08', '17:00'),
    (18, 6, '2024-09-09', '18:00'),
    (21, 6, '2024-09-10', '19:00'),
    (25, 6, '2024-09-11', '20:00'),
    (30, 6, '2024-09-12', '21:00'),
    (35, 6, '2024-09-13', '10:30'),
    (38, 6, '2024-09-14', '11:30'),
    (40, 6, '2024-09-15', '12:30'),
    (42, 6, '2024-09-16', '13:30'),
    (44, 6, '2024-09-17', '14:30'),
    (46, 6, '2024-09-18', '15:30'),
    (49, 6, '2024-09-19', '16:30'),
    (52, 6, '2024-09-20', '17:30'),
    (55, 6, '2024-09-21', '18:30'),
    (58, 6, '2024-09-22', '19:30'),
    (63, 6, '2024-09-23', '20:30'),
    (67, 6, '2024-09-24', '21:30');

-- Usuario 7 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (2, 7, '2024-09-05', '14:00'),
    (4, 7, '2024-09-06', '15:00'),
    (11, 7, '2024-09-07', '16:00'),
    (15, 7, '2024-09-08', '17:00'),
    (22, 7, '2024-09-09', '18:00'),
    (26, 7, '2024-09-10', '19:00'),
    (31, 7, '2024-09-11', '20:00'),
    (37, 7, '2024-09-12', '21:00'),
    (41, 7, '2024-09-13', '10:30'),
    (45, 7, '2024-09-14', '11:30'),
    (48, 7, '2024-09-15', '12:30'),
    (50, 7, '2024-09-16', '13:30'),
    (53, 7, '2024-09-17', '14:30'),
    (56, 7, '2024-09-18', '15:30'),
    (59, 7, '2024-09-19', '16:30'),
    (62, 7, '2024-09-20', '17:30'),
    (66, 7, '2024-09-21', '18:30'),
    (69, 7, '2024-09-22', '19:30'),
    (71, 7, '2024-09-23', '20:30'),
    (74, 7, '2024-09-24', '21:30');

-- Usuario 8 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (3, 8, '2024-09-05', '14:00'),
    (5, 8, '2024-09-06', '15:00'),
    (9, 8, '2024-09-07', '16:00'),
    (14, 8, '2024-09-08', '17:00'),
    (19, 8, '2024-09-09', '18:00'),
    (23, 8, '2024-09-10', '19:00'),
    (28, 8, '2024-09-11', '20:00'),
    (33, 8, '2024-09-12', '21:00'),
    (36, 8, '2024-09-13', '10:30'),
    (39, 8, '2024-09-14', '11:30'),
    (43, 8, '2024-09-15', '12:30'),
    (46, 8, '2024-09-16', '13:30'),
    (51, 8, '2024-09-17', '14:30'),
    (54, 8, '2024-09-18', '15:30'),
    (57, 8, '2024-09-19', '16:30'),
    (60, 8, '2024-09-20', '17:30'),
    (64, 8, '2024-09-21', '18:30'),
    (68, 8, '2024-09-22', '19:30'),
    (70, 8, '2024-09-23', '20:30'),
    (72, 8, '2024-09-24', '21:30');


-- Usuario 9 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (4, 9, '2024-09-05', '14:00'),
    (7, 9, '2024-09-06', '15:00'),
    (10, 9, '2024-09-07', '16:00'),
    (13, 9, '2024-09-08', '17:00'),
    (20, 9, '2024-09-09', '18:00'),
    (24, 9, '2024-09-10', '19:00'),
    (29, 9, '2024-09-11', '20:00'),
    (32, 9, '2024-09-12', '21:00'),
    (34, 9, '2024-09-13', '10:30'),
    (47, 9, '2024-09-14', '11:30'),
    (51, 9, '2024-09-15', '12:30'),
    (54, 9, '2024-09-16', '13:30'),
    (58, 9, '2024-09-17', '14:30'),
    (61, 9, '2024-09-18', '15:30'),
    (65, 9, '2024-09-19', '16:30'),
    (73, 9, '2024-09-20', '17:30'),
    (77, 9, '2024-09-21', '18:30'),
    (78, 9, '2024-09-22', '19:30'),
    (79, 9, '2024-09-23', '20:30'),
    (80, 9, '2024-09-24', '21:30');

-- Usuario 10 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (1, 10, '2024-09-05', '14:00'),
    (2, 10, '2024-09-06', '15:00'),
    (8, 10, '2024-09-07', '16:00'),
    (17, 10, '2024-09-08', '17:00'),
    (25, 10, '2024-09-09', '18:00'),
    (27, 10, '2024-09-10', '19:00'),
    (30, 10, '2024-09-11', '20:00'),
    (33, 10, '2024-09-12', '21:00'),
    (35, 10, '2024-09-13', '10:30'),
    (44, 10, '2024-09-14', '11:30'),
    (45, 10, '2024-09-15', '12:30'),
    (49, 10, '2024-09-16', '13:30'),
    (52, 10, '2024-09-17', '14:30'),
    (55, 10, '2024-09-18', '15:30'),
    (62, 10, '2024-09-19', '16:30'),
    (63, 10, '2024-09-20', '17:30'),
    (66, 10, '2024-09-21', '18:30'),
    (71, 10, '2024-09-22', '19:30'),
    (75, 10, '2024-09-23', '20:30'),
    (76, 10, '2024-09-24', '21:30');

-- Usuario 11 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (6, 11, '2024-09-05', '14:00'),
    (12, 11, '2024-09-06', '15:00'),
    (16, 11, '2024-09-07', '16:00'),
    (18, 11, '2024-09-08', '17:00'),
    (19, 11, '2024-09-09', '18:00'),
    (22, 11, '2024-09-10', '19:00'),
    (23, 11, '2024-09-11', '20:00'),
    (28, 11, '2024-09-12', '21:00'),
    (34, 11, '2024-09-13', '10:30'),
    (36, 11, '2024-09-14', '11:30'),
    (39, 11, '2024-09-15', '12:30'),
    (42, 11, '2024-09-16', '13:30'),
    (46, 11, '2024-09-17', '14:30'),
    (48, 11, '2024-09-18', '15:30'),
    (50, 11, '2024-09-19', '16:30'),
    (59, 11, '2024-09-20', '17:30'),
    (61, 11, '2024-09-21', '18:30'),
    (64, 11, '2024-09-22', '19:30'),
    (67, 11, '2024-09-23', '20:30'),
    (70, 11, '2024-09-24', '21:30');


-- Usuario 9 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (4, 9, '2024-09-05', '14:00'),
    (7, 9, '2024-09-06', '15:00'),
    (10, 9, '2024-09-07', '16:00'),
    (13, 9, '2024-09-08', '17:00'),
    (20, 9, '2024-09-09', '18:00'),
    (24, 9, '2024-09-10', '19:00'),
    (29, 9, '2024-09-11', '20:00'),
    (32, 9, '2024-09-12', '21:00'),
    (34, 9, '2024-09-13', '10:30'),
    (47, 9, '2024-09-14', '11:30'),
    (51, 9, '2024-09-15', '12:30'),
    (54, 9, '2024-09-16', '13:30'),
    (58, 9, '2024-09-17', '14:30'),
    (61, 9, '2024-09-18', '15:30'),
    (65, 9, '2024-09-19', '16:30'),
    (73, 9, '2024-09-20', '17:30'),
    (77, 9, '2024-09-21', '18:30'),
    (78, 9, '2024-09-22', '19:30'),
    (79, 9, '2024-09-23', '20:30'),
    (80, 9, '2024-09-24', '21:30');

-- Usuario 10 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (1, 10, '2024-09-05', '14:00'),
    (2, 10, '2024-09-06', '15:00'),
    (8, 10, '2024-09-07', '16:00'),
    (17, 10, '2024-09-08', '17:00'),
    (25, 10, '2024-09-09', '18:00'),
    (27, 10, '2024-09-10', '19:00'),
    (30, 10, '2024-09-11', '20:00'),
    (33, 10, '2024-09-12', '21:00'),
    (35, 10, '2024-09-13', '10:30'),
    (44, 10, '2024-09-14', '11:30'),
    (45, 10, '2024-09-15', '12:30'),
    (49, 10, '2024-09-16', '13:30'),
    (52, 10, '2024-09-17', '14:30'),
    (55, 10, '2024-09-18', '15:30'),
    (62, 10, '2024-09-19', '16:30'),
    (63, 10, '2024-09-20', '17:30'),
    (66, 10, '2024-09-21', '18:30'),
    (71, 10, '2024-09-22', '19:30'),
    (75, 10, '2024-09-23', '20:30'),
    (76, 10, '2024-09-24', '21:30');

-- Usuario 11 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (6, 11, '2024-09-05', '14:00'),
    (12, 11, '2024-09-06', '15:00'),
    (16, 11, '2024-09-07', '16:00'),
    (18, 11, '2024-09-08', '17:00'),
    (19, 11, '2024-09-09', '18:00'),
    (22, 11, '2024-09-10', '19:00'),
    (23, 11, '2024-09-11', '20:00'),
    (28, 11, '2024-09-12', '21:00'),
    (34, 11, '2024-09-13', '10:30'),
    (36, 11, '2024-09-14', '11:30'),
    (39, 11, '2024-09-15', '12:30'),
    (42, 11, '2024-09-16', '13:30'),
    (46, 11, '2024-09-17', '14:30'),
    (48, 11, '2024-09-18', '15:30'),
    (50, 11, '2024-09-19', '16:30'),
    (59, 11, '2024-09-20', '17:30'),
    (61, 11, '2024-09-21', '18:30'),
    (64, 11, '2024-09-22', '19:30'),
    (67, 11, '2024-09-23', '20:30'),
    (70, 11, '2024-09-24', '21:30');


-- Usuario 12 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (3, 12, '2024-09-05', '14:00'),
    (5, 12, '2024-09-06', '15:00'),
    (9, 12, '2024-09-07', '16:00'),
    (14, 12, '2024-09-08', '17:00'),
    (15, 12, '2024-09-09', '18:00'),
    (21, 12, '2024-09-10', '19:00'),
    (26, 12, '2024-09-11', '20:00'),
    (31, 12, '2024-09-12', '21:00'),
    (37, 12, '2024-09-13', '10:30'),
    (40, 12, '2024-09-14', '11:30'),
    (41, 12, '2024-09-15', '12:30'),
    (43, 12, '2024-09-16', '13:30'),
    (49, 12, '2024-09-17', '14:30'),
    (53, 12, '2024-09-18', '15:30'),
    (56, 12, '2024-09-19', '16:30'),
    (60, 12, '2024-09-20', '17:30'),
    (68, 12, '2024-09-21', '18:30'),
    (72, 12, '2024-09-22', '19:30'),
    (74, 12, '2024-09-23', '20:30'),
    (80, 12, '2024-09-24', '21:30');

-- Usuario 13 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (2, 13, '2024-09-05', '14:00'),
    (4, 13, '2024-09-06', '15:00'),
    (11, 13, '2024-09-07', '16:00'),
    (13, 13, '2024-09-08', '17:00'),
    (17, 13, '2024-09-09', '18:00'),
    (24, 13, '2024-09-10', '19:00'),
    (28, 13, '2024-09-11', '20:00'),
    (30, 13, '2024-09-12', '21:00'),
    (34, 13, '2024-09-13', '10:30'),
    (38, 13, '2024-09-14', '11:30'),
    (45, 13, '2024-09-15', '12:30'),
    (50, 13, '2024-09-16', '13:30'),
    (52, 13, '2024-09-17', '14:30'),
    (55, 13, '2024-09-18', '15:30'),
    (62, 13, '2024-09-19', '16:30'),
    (69, 13, '2024-09-20', '17:30'),
    (71, 13, '2024-09-21', '18:30'),
    (74, 13, '2024-09-22', '19:30'),
    (75, 13, '2024-09-23', '20:30'),
    (78, 13, '2024-09-24', '21:30');

-- Usuario 14 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (1, 14, '2024-09-05', '14:00'),
    (8, 14, '2024-09-06', '15:00'),
    (12, 14, '2024-09-07', '16:00'),
    (18, 14, '2024-09-08', '17:00'),
    (19, 14, '2024-09-09', '18:00'),
    (22, 14, '2024-09-10', '19:00'),
    (26, 14, '2024-09-11', '20:00'),
    (29, 14, '2024-09-12', '21:00'),
    (32, 14, '2024-09-13', '10:30'),
    (39, 14, '2024-09-14', '11:30'),
    (44, 14, '2024-09-15', '12:30'),
    (47, 14, '2024-09-16', '13:30'),
    (54, 14, '2024-09-17', '14:30'),
    (58, 14, '2024-09-18', '15:30'),
    (60, 14, '2024-09-19', '16:30'),
    (63, 14, '2024-09-20', '17:30'),
    (64, 14, '2024-09-21', '18:30'),
    (66, 14, '2024-09-22', '19:30'),
    (72, 14, '2024-09-23', '20:30'),
    (77, 14, '2024-09-24', '21:00');



-- Usuario 15 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (2, 15, '2024-09-05', '14:00'),
    (5, 15, '2024-09-06', '15:00'),
    (10, 15, '2024-09-07', '16:00'),
    (15, 15, '2024-09-08', '17:00'),
    (23, 15, '2024-09-09', '18:00'),
    (26, 15, '2024-09-10', '19:00'),
    (31, 15, '2024-09-11', '20:00'),
    (36, 15, '2024-09-12', '21:00'),
    (38, 15, '2024-09-13', '10:30'),
    (41, 15, '2024-09-14', '11:30'),
    (49, 15, '2024-09-15', '12:30'),
    (51, 15, '2024-09-16', '13:30'),
    (53, 15, '2024-09-17', '14:30'),
    (55, 15, '2024-09-18', '15:30'),
    (61, 15, '2024-09-19', '16:30'),
    (67, 15, '2024-09-20', '17:30'),
    (71, 15, '2024-09-21', '18:30'),
    (74, 15, '2024-09-22', '19:30'),
    (76, 15, '2024-09-23', '20:30'),
    (78, 15, '2024-09-24', '21:30');

-- Usuario 16 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (3, 16, '2024-09-05', '14:00'),
    (8, 16, '2024-09-06', '15:00'),
    (12, 16, '2024-09-07', '16:00'),
    (14, 16, '2024-09-08', '17:00'),
    (18, 16, '2024-09-09', '18:00'),
    (20, 16, '2024-09-10', '19:00'),
    (22, 16, '2024-09-11', '20:00'),
    (24, 16, '2024-09-12', '21:00'),
    (29, 16, '2024-09-13', '10:30'),
    (32, 16, '2024-09-14', '11:30'),
    (37, 16, '2024-09-15', '12:30'),
    (42, 16, '2024-09-16', '13:30'),
    (45, 16, '2024-09-17', '14:30'),
    (48, 16, '2024-09-18', '15:30'),
    (50, 16, '2024-09-19', '16:30'),
    (58, 16, '2024-09-20', '17:30'),
    (62, 16, '2024-09-21', '18:30'),
    (64, 16, '2024-09-22', '19:30'),
    (66, 16, '2024-09-23', '20:30'),
    (79, 16, '2024-09-24', '21:30');

-- Usuario 17 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (1, 17, '2024-09-05', '14:00'),
    (6, 17, '2024-09-06', '15:00'),
    (7, 17, '2024-09-07', '16:00'),
    (9, 17, '2024-09-08', '17:00'),
    (13, 17, '2024-09-09', '18:00'),
    (16, 17, '2024-09-10', '19:00'),
    (19, 17, '2024-09-11', '20:00'),
    (21, 17, '2024-09-12', '21:00'),
    (27, 17, '2024-09-13', '10:30'),
    (30, 17, '2024-09-14', '11:30'),
    (34, 17, '2024-09-15', '12:30'),
    (39, 17, '2024-09-16', '13:30'),
    (40, 17, '2024-09-17', '14:30'),
    (46, 17, '2024-09-18', '15:30'),
    (52, 17, '2024-09-19', '16:30'),
    (54, 17, '2024-09-20', '17:30'),
    (60, 17, '2024-09-21', '18:30'),
    (65, 17, '2024-09-22', '19:30'),
    (73, 17, '2024-09-23', '20:30'),
    (80, 17, '2024-09-24', '21:30');

-- Usuario 18 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (4, 18, '2024-09-05', '14:00'),
    (11, 18, '2024-09-06', '15:00'),
    (17, 18, '2024-09-07', '16:00'),
    (20, 18, '2024-09-08', '17:00'),
    (25, 18, '2024-09-09', '18:00'),
    (28, 18, '2024-09-10', '19:00'),
    (33, 18, '2024-09-11', '20:00'),
    (35, 18, '2024-09-12', '21:00'),
    (43, 18, '2024-09-13', '10:30'),
    (44, 18, '2024-09-14', '11:30'),
    (47, 18, '2024-09-15', '12:30'),
    (49, 18, '2024-09-16', '13:30'),
    (56, 18, '2024-09-17', '14:30'),
    (57, 18, '2024-09-18', '15:30'),
    (63, 18, '2024-09-19', '16:30'),
    (69, 18, '2024-09-20', '17:30'),
    (70, 18, '2024-09-21', '18:30'),
    (72, 18, '2024-09-22', '19:30'),
    (77, 18, '2024-09-23', '20:30'),
    (79, 18, '2024-09-24', '21:30');

-- Usuario 19 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (1, 19, '2024-09-05', '14:00'),
    (8, 19, '2024-09-06', '15:00'),
    (11, 19, '2024-09-07', '16:00'),
    (13, 19, '2024-09-08', '17:00'),
    (15, 19, '2024-09-09', '18:00'),
    (18, 19, '2024-09-10', '19:00'),
    (22, 19, '2024-09-11', '20:00'),
    (24, 19, '2024-09-12', '21:00'),
    (29, 19, '2024-09-13', '10:30'),
    (34, 19, '2024-09-14', '11:30'),
    (39, 19, '2024-09-15', '12:30'),
    (46, 19, '2024-09-16', '13:30'),
    (51, 19, '2024-09-17', '14:30'),
    (53, 19, '2024-09-18', '15:30'),
    (60, 19, '2024-09-19', '16:30'),
    (64, 19, '2024-09-20', '17:30'),
    (68, 19, '2024-09-21', '18:30'),
    (74, 19, '2024-09-22', '19:30'),
    (75, 19, '2024-09-23', '20:30'),
    (80, 19, '2024-09-24', '21:30');

-- Usuario 20 asistiendo a 20 eventos
INSERT INTO Registro (id_evento, id_usuario, fecha_registro, hora_registro)
VALUES
    (3, 20, '2024-09-05', '14:00'),
    (7, 20, '2024-09-06', '15:00'),
    (9, 20, '2024-09-07', '16:00'),
    (12, 20, '2024-09-08', '17:00'),
    (14, 20, '2024-09-09', '18:00'),
    (19, 20, '2024-09-10', '19:00'),
    (21, 20, '2024-09-11', '20:00'),
    (23, 20, '2024-09-12', '21:00'),
    (30, 20, '2024-09-13', '10:30'),
    (36, 20, '2024-09-14', '11:30'),
    (41, 20, '2024-09-15', '12:30'),
    (45, 20, '2024-09-16', '13:30'),
    (52, 20, '2024-09-17', '14:30'),
    (55, 20, '2024-09-18', '15:30'),
    (58, 20, '2024-09-19', '16:30'),
    (62, 20, '2024-09-20', '17:30'),
    (65, 20, '2024-09-21', '18:30'),
    (71, 20, '2024-09-22', '19:30'),
    (73, 20, '2024-09-23', '20:30'),
    (78, 20, '2024-09-24', '21:30');

