# ------------------------------------------------------------------------------
# 0. Cargar scripts previos
# ------------------------------------------------------------------------------

source("code/00_settings.R")
source("code/01_load_data.R")

# ------------------------------------------------------------------------------
# 1. Crear carpeta de salida
# ------------------------------------------------------------------------------

fig_path <- file.path("results/figures")
dir.create(fig_path, showWarnings = FALSE)

# ------------------------------------------------------------------------------
# 2. Variables
# ------------------------------------------------------------------------------

vars_age <- c(
  "edad_menor_5",
  "edad_5_14",
  "edad_15_64",
  "edad_65_mas"
)

# ------------------------------------------------------------------------------
# 3. Transformar a formato largo
# ------------------------------------------------------------------------------

serie_long <- serie %>%
  select(semana_epi, all_of(vars_age)) %>%
  pivot_longer(
    cols = all_of(vars_age),
    names_to = "grupo",
    values_to = "casos"
  )

# ------------------------------------------------------------------------------
# 4. Gráfico único (todas las edades)
# ------------------------------------------------------------------------------

p_all <- ggplot(serie_long, aes(x = semana_epi, y = casos, color = grupo)) +
  geom_line(linewidth = 0.7) +
  labs(
    title = "Series semanales por grupo etario",
    x = "Semana epidemiológica",
    y = "Casos",
    color = "Grupo"
  ) +
  theme_minimal()

# Guardar + mostrar
ggsave(
  filename = file.path(fig_path, "serie_todas_edades.png"),
  plot = p_all,
  width = 12,
  height = 6,
  dpi = 300
)

print(p_all)

# ------------------------------------------------------------------------------
# 5. Filtrar solo menores de 5 y mayores de 65
# ------------------------------------------------------------------------------
vars_extremos <- c("edad_menor_5", "edad_65_mas")

serie_extremos <- serie %>%
  select(semana_epi, all_of(vars_extremos)) %>%
  mutate(anio = lubridate::year(semana_epi)) %>%
  pivot_longer(
    cols = all_of(vars_extremos),
    names_to = "grupo",
    values_to = "casos"
  )

# ------------------------------------------------------------------------------
# 6. Calcular pendiente semana a semana (diferencia de casos) por grupo y año
# ------------------------------------------------------------------------------
serie_extremos <- serie_extremos %>%
  arrange(grupo, semana_epi) %>%
  group_by(grupo, anio) %>%
  mutate(pendiente = casos - lag(casos)) %>%
  ungroup()

# ------------------------------------------------------------------------------
# 7. Identificar eventos por grupo y año: peak, mayor pendiente +, mayor pendiente -
# ------------------------------------------------------------------------------
safe_which_max <- function(x) {
  if (all(is.na(x))) return(NA_integer_)
  which.max(x)
}

safe_which_min <- function(x) {
  if (all(is.na(x))) return(NA_integer_)
  which.min(x)
}

eventos <- serie_extremos %>%
  group_by(grupo, anio) %>%
  summarise(
    semana_epi_peak     = semana_epi[which.max(casos)],
    casos_peak          = max(casos, na.rm = TRUE),
    semana_epi_pend_pos = {
      i <- safe_which_max(pendiente)
      if (is.na(i)) as.Date(NA) else semana_epi[i]
    },
    casos_pend_pos      = {
      i <- safe_which_max(pendiente)
      if (is.na(i)) NA_real_ else casos[i]
    },
    semana_epi_pend_neg = {
      i <- safe_which_min(pendiente)
      if (is.na(i)) as.Date(NA) else semana_epi[i]
    },
    casos_pend_neg      = {
      i <- safe_which_min(pendiente)
      if (is.na(i)) NA_real_ else casos[i]
    },
    .groups = "drop"
  ) %>%
  pivot_longer(
    cols = starts_with("semana_epi_") | starts_with("casos_"),
    names_to = c(".value", "evento"),
    names_pattern = "(semana_epi|casos)_(.*)"
  ) %>%
  filter(!is.na(semana_epi)) %>%   # elimina eventos no calculables (ej: año 2009 con 1 semana)
  mutate(
    evento = recode(evento,
                    "peak"     = "Peak",
                    "pend_pos" = "Mayor pendiente +",
                    "pend_neg" = "Mayor pendiente -"
    )
  )

# ------------------------------------------------------------------------------
# 8. Generar y guardar un gráfico por año
# ------------------------------------------------------------------------------
anios <- sort(unique(serie_extremos$anio))

for (a in anios) {
  
  datos_anio  <- filter(serie_extremos, anio == a)
  eventos_anio <- filter(eventos, anio == a)
  
  p_anio <- ggplot(datos_anio, aes(x = semana_epi, y = casos, color = grupo)) +
    geom_line(linewidth = 0.7) +
    geom_point(
      data = eventos_anio,
      aes(x = semana_epi, y = casos, color = grupo, shape = evento),
      size = 3.5,
      stroke = 1.1
    ) +
    scale_shape_manual(values = c("Peak" = 16, "Mayor pendiente +" = 17, "Mayor pendiente -" = 15)) +
    labs(
      title = paste("Serie semanal -", a, "- Menores de 5 y Mayores de 65"),
      x = "Semana epidemiológica",
      y = "Casos",
      color = "Grupo",
      shape = "Evento"
    ) +
    theme_minimal()
  
  ggsave(
    filename = file.path(fig_path, paste0("serie_extremos_", a, ".png")),
    plot = p_anio,
    width = 12,
    height = 6,
    dpi = 300
  )
  
  print(p_anio)
}
