# git-sin-morir

---

## Descripción

En este README.md se presenta una serie de funcionalidades que pueden incorporarse para hacer más atractivo y autoexplicativa la presentación de nuestros repositorios. Concretamente se incluyen ejemplos y la utilización de:

* Títulos y subtítulos
* Separador de secciones (---)
* **Negrita**
* *Cursiva*
* ~~Texto tachado~~
* Badges (insignias)
* Estructura (text)
* Código
* Tablas
* Listas
* Citas
* Notas al pie
* Hipervínculos
* Fórmulas
* Imágenes

--- 

## Badges

### Badges dinámicas

![GitHub last commit](https://img.shields.io/github/last-commit/ismaelbrarod/git-sin-morir)
![GitHub Repo stars](https://img.shields.io/github/stars/ismaelbrarod/git-sin-morir)

### Badges estáticas

![R](https://img.shields.io/badge/language-R-blue)

---

## Estructura

```text
.
├── data/
├── scripts/
├── results/
├── figures/
├── README.md
└── .gitignore
```
---

## Código

### Código en línea

La variable `total_respiratorias` representa el total de consultas respiratorias.

### Código en bloque

```r
library(tidyverse)

urgencias <- read_csv(
  "data/urgencias.csv"
)

resumen <- urgencias |>
  group_by(semana) |>
  summarise(
    total = sum(total_respiratorias)
  )

head(resumen)
```

---

## Tablas

| Indicador | Valor  |
| --------- | ------ |
| Año       | 2025   |
| Semanas   | 52     |
| Registros | 120000 |
| Variables | 25     |

---

## Listas

### Lista ordenada

1. Importar datos.
2. Limpiar registros.
3. Generar indicadores.
4. Crear visualizaciones.

### Lista no ordenada

* Vigilancia.
* Monitoreo.
* Análisis exploratorio.

  * Series temporales.
  * Estacionalidad.
  * Detección de brotes.
 
### Lista de tareas

* [x] Crear repositorio.
* [x] Configurar Git.
* [ ] Automatizar reportes.
* [ ] Implementar aplicación Shiny.

---

## Citas

> Los datos deben interpretarse considerando la oportunidad y completitud de la notificación.

---

## Hipervínculos

* Sitio de GitHub: https://github.com
* Documentación de R: https://cran.r-project.org
* Tidyverse: https://www.tidyverse.org

También puedes crear enlaces con texto:

[Visitar GitHub](https://github.com)

---

## Nota al pie

Este análisis utiliza datos agregados semanalmente.[^1]

[^1]: Ejemplo de nota al pie compatible con GitHub Flavored Markdown.

---

## Fórmulas

### Fórmula en línea

La incidencia se calcula como $I = \frac{C}{P}\times 100000$ habitantes.

### Fórmula en bloque

La incidencia se calcula como:

$$
I = \frac{C}{P}\times 100000
$$

---

## Imágenes

### Imágenes locales

![Logo del proyecto](images/logo.png)

### Imágenes online

![Logo de GitHub](https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png)

---
