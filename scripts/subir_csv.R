###Librerias para la carga de datos 
install.packages("DBI") #Base de datos
install.packages("RPostgres") #Postgres driver
install.packages("dotenv") #Para cargar las variables de entorno

# Cargar las librerías
library(DBI)
library(RPostgres)
library(dotenv)

###
# Cargar las variables de entorno .env
dotenv::load_dot_env(file = "T:/_Franco/Repos/Test_Migrando/Test_migrando/tiger-cloud-test_migrando-credentials.env")

# Conexion a la base
con <- dbConnect(
  Postgres(),
  dbname = Sys.getenv("PGDATABASE"),
  host = Sys.getenv("PGHOST"),
  port = Sys.getenv("PGPORT"),
  user = Sys.getenv("PGUSER"),
  password = Sys.getenv("PGPASSWORD")
)

# Verificar la conexión
dbGetQuery(con, "SELECT NOW();")

# Cargar el archivo CSV
archivo_csv <- read.csv("T:/_Franco/Repos/Test_Migrando/Test_migrando/data/raw/imae_2004.csv")

# Subir el archivo CSV a la base de datos
dbWriteTable(
  con,
  name = "imae_2004",
  value = archivo_csv,
  append = TRUE,
  row.names = FALSE,
  overwrite = TRUE
)

###-------------GENERAR .SQL CON INSERTS DESDE .CSV---------------

archivo_csv <- read.csv("T:/_Franco/Repos/Test_Migrando/Test_migrando/data/raw/imae_2004.csv", sep = ";")
#nombre_columnas <- names(archivo_csv)
nombre_columnas <- c("tiempo","series_id","valor")
tabla_destino <- "observacion"

inserts <- apply(archivo_csv, 1, function(row) {
  # Asumiendo que 'tiempo' es la primera columna, 'series_id' la segunda y 'valor' la tercera.
  # Convertir el valor de 'tiempo' a caracter para asegurarnos de que se cite.
  tiempo_val <- paste0("'", as.character(row[1]), "'")
  series_id_val <- as.numeric(row[2]) # Asegura que sea numérico
  valor_val <- as.numeric(row[3])       # Asegura que sea numérico
  
  # Unir los valores formateados
  values <- paste(tiempo_val, series_id_val, valor_val, sep = ",")
  
  # Generar la consulta INSERT
  paste0("INSERT INTO ", tabla_destino, " VALUES (", values, ");")
})


# Guardar en archivo .sql para copiar/pegar
writeLines(inserts, "T:/_Franco/Repos/Test_Migrando/Test_migrando/data/raw/insert_imae_2004.sql")




