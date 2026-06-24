# ==============================================================================
# 01_load_data.R
# Carga de datos procesados (CSV + RData)
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. Cargar scripts previos
# ------------------------------------------------------------------------------

source("code/00_settings.R")

# ------------------------------------------------------------------------------
# 1. Cargar CSV
# ------------------------------------------------------------------------------

serie_csv <- read_csv("data/raw/serie_semanal.csv")

# ------------------------------------------------------------------------------
# 2. Cargar RData
# ------------------------------------------------------------------------------

load("data/raw/serie_semanal.RData")

# ------------------------------------------------------------------------------
# 3. Generar una base por cada tipo de conteo y guardarlas como CSV
# ------------------------------------------------------------------------------
dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)

tipos_conteo <- c(
  "casos_total",
  "edad_menor_5",
  "edad_5_14",
  "edad_15_64",
  "edad_65_mas"
)

for (tipo in tipos_conteo) {
  
  base_tipo <- serie %>%
    select(semana_epi, all_of(tipo))
  
  write_csv(
    base_tipo,
    file.path("data/processed", paste0(tipo, ".csv"))
  )
}

# ------------------------------------------------------------------------------
# 4. Guardar serie completa como serie_final.csv en data/output
# ------------------------------------------------------------------------------
dir.create("data/output", showWarnings = FALSE, recursive = TRUE)

write_csv(
  serie,
  file.path("data/output", "serie_final.csv")
)
