-- Crear la base de datos
CREATE DATABASE BD_Victimas;

-- Usar la base de datos
USE BD_Victimas;

-- Crear la tabla Victimas
CREATE TABLE Victimas (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Sexo VARCHAR(255),
    Edad INT,
    Tipo_Persona VARCHAR(255),
    Calidad_Juridica VARCHAR(255)
);

-- Crear la tabla Ubicaciones
CREATE TABLE Ubicaciones (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Colonia_Hecho VARCHAR(255),
    Municipio_Ciudad_Hecho VARCHAR(255)
);

-- Crear la tabla Delitos

CREATE TABLE Delitos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_Hecho DATE,
    Delito VARCHAR(255),
    Categoria_Delito VARCHAR(255),
    Competencia VARCHAR(255),
    ID_Ubicacion INT,
    ID_Victima INT,
    FOREIGN KEY (ID_Ubicacion) REFERENCES Ubicaciones(ID),
    FOREIGN KEY (ID_Victima) REFERENCES Victimas(ID)
);

-- Problemática: Análisis de la incidencia delictiva y características demográficas en una ciudad

-- En una ciudad metropolitana, se observa un aumento en los índices delictivos durante los últimos años. Las autoridades locales están interesadas en entender mejor estos patrones para poder tomar medidas efectivas de prevención 
-- y seguridad ciudadana. La base de datos contiene información detallada de los incidentes reportados, incluyendo fechas de los hechos, tipos de delitos, edades de las víctimas y ubicaciones específicas donde ocurrieron los 
-- incidentes.

-- Objetivos del Proyecto:

--    Análisis Temporal: Identificar tendencias y patrones temporales en la incidencia delictiva a lo largo de los últimos cinco años. ¿Hay meses o días de la semana con mayor actividad delictiva?

--    Perfil Demográfico de las Víctimas: Analizar las características demográficas de las víctimas, como la edad y el sexo. ¿Existen grupos demográficos específicos que sean más vulnerables a ciertos tipos de delitos?

--    Tipología del Delito: Clasificar y analizar los diferentes tipos de delitos registrados en la base de datos. ¿Existen correlaciones entre el tipo de delito y la ubicación o la edad de las víctimas?

--    Impacto Geoespacial: Utilizar datos de ubicación para mapear y visualizar la distribución geográfica de los delitos. ¿Hay áreas específicas de la ciudad que presenten concentraciones más altas de delitos?

-- Beneficios Esperados:

--    Mejorar la asignación de recursos de seguridad pública.
--    Informar políticas de prevención del delito basadas en datos.
--    Incrementar la seguridad y la percepción de seguridad entre los residentes.

SELECT YEAR(Fecha_Hecho) AS Anio, MONTH(Fecha_Hecho) AS Mes, COUNT(*) AS Num_Delitos
FROM Delitos
WHERE Fecha_Hecho != '1900-01-01'
GROUP BY Anio, Mes
ORDER BY Anio DESC, Mes DESC;

-- Descripción: Esta consulta calcula el número de delitos registrados por año y mes, excluyendo aquellos delitos que tienen la fecha 01/01/1900. Agrupa los resultados por año y mes, 
-- mostrando las tendencias temporales de la actividad delictiva sin incluir registros con fechas irrelevantes o que no tenemos el dato real.

SELECT DAYNAME(Fecha_Hecho) AS Dia_Semana, COUNT(*) AS Num_Delitos
FROM Delitos
WHERE Fecha_Hecho != '1900-01-01'
GROUP BY Dia_Semana
ORDER BY Num_Delitos DESC;

-- Descripción: Esta consulta identifica el día de la semana con la mayor cantidad de delitos registrados, excluyendo los delitos con la fecha 01/01/1900. 
-- Agrupa los resultados por día de la semana y cuenta la cantidad de delitos para cada día, mostrando así los patrones de actividad delictiva por día de la semana.

SELECT Categoria_Delito, AVG(Edad) AS Edad_Promedio
FROM Delitos D
INNER JOIN Victimas V ON D.ID = V.ID
WHERE D.Fecha_Hecho != '1900-01-01'
GROUP BY Categoria_Delito
ORDER BY Edad_Promedio DESC;

-- Descripción: Esta consulta calcula la edad promedio de las víctimas por tipo de delito registrado, excluyendo aquellos delitos que tienen la fecha 01/01/1900. 
-- Utiliza un INNER JOIN entre las tablas Delitos y Victimas para relacionar los delitos con sus víctimas y agrupa los resultados por tipo de delito, mostrando el promedio de edad de las víctimas en orden descendente.


SELECT Sexo, COUNT(*) AS Num_Victimas
FROM Victimas
GROUP BY Sexo;

-- Descripción: Esta consulta muestra la proporción de víctimas registradas en la base de datos según su sexo. 
-- Agrupa los resultados por sexo y cuenta el número de víctimas para cada categoría de sexo (Masculino, Femenino, etc.), sin aplicar un filtro específico de fecha ya que no involucra la tabla Delitos.


SELECT U.Municipio_Ciudad_Hecho, D.Categoria_Delito, COUNT(*) AS Num_Delitos
FROM Delitos D
INNER JOIN Ubicaciones U ON D.ID = U.ID
WHERE D.Fecha_Hecho != '1900-01-01'
GROUP BY U.Municipio_Ciudad_Hecho, D.Categoria_Delito
ORDER BY Num_Delitos DESC;

-- Descripción: Esta consulta muestra la cantidad de delitos registrados por tipo de delito y municipio donde ocurrieron, excluyendo aquellos delitos con la fecha 01/01/1900. 
-- Utiliza un INNER JOIN entre las tablas Delitos y Ubicaciones para relacionar los delitos con sus ubicaciones respectivas. 
-- Agrupa los resultados por municipio y tipo de delito, mostrando la cantidad de delitos en orden descendente.


SELECT U.Colonia_Hecho, U.Municipio_Ciudad_Hecho, COUNT(*) AS Num_Delitos
FROM Delitos D
INNER JOIN Ubicaciones U ON D.ID = U.ID
WHERE D.Fecha_Hecho != '1900-01-01'
GROUP BY U.Colonia_Hecho, U.Municipio_Ciudad_Hecho
ORDER BY Num_Delitos DESC;

-- Descripción: Esta consulta identifica las ubicaciones (colonias y municipios) con la mayor concentración de delitos registrados, excluyendo aquellos delitos con la fecha 01/01/1900. 
-- Utiliza un INNER JOIN entre las tablas Delitos y Ubicaciones para relacionar los delitos con sus ubicaciones. 
-- Agrupa los resultados por colonia y municipio, mostrando la cantidad de delitos en orden descendente.


SELECT U.Colonia_Hecho, U.Municipio_Ciudad_Hecho, COUNT(*) AS Num_Delitos
FROM Delitos D
INNER JOIN Ubicaciones U ON D.ID = U.ID
WHERE D.Fecha_Hecho != '1900-01-01'
AND U.Colonia_Hecho != "SIN DATO "
GROUP BY U.Colonia_Hecho, U.Municipio_Ciudad_Hecho
ORDER BY Num_Delitos DESC
LIMIT 10;

-- Descripción: Esta consulta identifica las 10 zonas (colonias y municipios) con la mayor frecuencia de delitos registrados, excluyendo aquellos delitos con la fecha 01/01/1900 y colonia "SIN DATO". 
-- Utiliza un INNER JOIN entre las tablas Delitos y Ubicaciones para relacionar los delitos con sus ubicaciones. 
-- Agrupa los resultados por colonia y municipio, mostrando la cantidad de delitos en orden descendente y limitando los resultados a 10 para destacar las zonas más críticas.


-- Esta ultima consulta nos servira para saber en que colonia de que ciudad o municipio tiene mayor indice de delitos reportados y de mayor gravedad, para asi poder asignar una mayor cantidad de recursos de seguridad.



-- asdasdasd