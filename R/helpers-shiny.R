meses <- c("enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", 
                         "agosto", "septiembre", "octubre", "noviembre", "diciembre")

datec <- function(fecha = ymd(20200601)) {
  
  d <- day(fecha) %>% 
    as.numeric()
  
  m <- month(fecha) %>% 
    as.numeric()
  
  m <- meses[m]
  
  y <- year(fecha)
  
  paste0(d, " de ", m, " del ", y)
}

commac <- partial(comma, big.mark = ".", decimal.mark = ",")

percentc <- partial(percent, big.mark = ".", decimal.mark = ",", accuracy = 0.01)

covpal <- function(n = 16, begin = 0.05, end = 0.95) {
  
  viridis_pal(option = "B", begin = begin, end = end, direction = -1)(n)
  
}

RMD_to_HTML <- function(file) {
  
  HTML(
    markdown::markdownToHTML(
      text = knitr::knit(
        text = readLines(file, encoding = "UTF-8"),
        quiet = TRUE
      ),
      fragment.only = TRUE
    )  
  )
  
}

bs4CardCustom <- purrr::partial(
  bs4Card,
  status = "primary",
  solidHeader = TRUE, 
  collapsible = FALSE,
  closable = FALSE,
  elevation = 4,
  width = 12
  )

bs4CardHC <- purrr::partial(
  bs4Card,
  elevation = 1,
  closable = FALSE,
  width = 12,
  collapsible = FALSE
)

bs4CardHC2 <- function(...) {
  
  x <- bs4CardHC(addSpinner(...))
  x <- tagAppendAttributes(x, style = "height:99%")
  x$children[[1]] <- tagAppendAttributes(x$children[[1]], style = "height:99%")
  x
  
}

valueBoxSpark <- function(value, subtitle, icon = NULL, color = "light-blue", 
                          width = 4, href = NULL, spark = NULL, height_spark = "70px",minititle = NULL) {
  
  shinydashboard:::validateColor(color)
  
  if (!is.null(icon)) 
    shinydashboard:::tagAssert(icon, type = "i")
  
  boxContent <- div(
    class = paste0("small-box elevation-3 bg-", color),
    div(
      class = "inner",
      if(!is.null(minititle)) tags$h6(minititle),
      h1(value, style = "font-weight: 800"),
      # tags$span(style = paste0("height:", height_spark), hc_size(spark, height = "100vh")),
      tags$span(hc_size(spark, height = height_spark)),
      if (!is.null(subtitle)) tags$p(subtitle)
    ),
    if (!is.null(icon)) div(class = "icon-large", icon)
  )
  
  if (!is.null(href)) 
    boxContent <- a(href = href, boxContent)
  
  div(class = if (!is.null(width)) 
    paste0("col-sm-", width), boxContent)
}

hc_theme_sparkline2 <- function(...) {
  
  theme <- list(
    chart = list(
      backgroundColor = NULL,
      margins = c(0, 0, 0, 0),
      spacingTop = 0,
      spacingRight = 0,
      spacingBottom = 0,
      spacingLeft = 0,
      plotBorderWidth = 0,
      borderWidth = 0,
      style = list(
        overflow = "visible"
      ),
      skipClone = TRUE
    ),
    xAxis = list(
      visible = FALSE, 
      endOnTick = FALSE, 
      startOnTick = FALSE
    ),
    yAxis = list(
      visible = FALSE,
      endOnTick = FALSE, 
      startOnTick = FALSE
    ),
    tooltip = list(
      outside = FALSE,
      headerFormat = "",
      pointFormat = "{point.x}: <b>{point.y}</b>",
      shadow = FALSE,
      borderColor = "transparent",
      botderWidth = 0,
      backgroundColor = "transparent",
      style = list(textOutline = "5px white")
    ),
    plotOptions = list(
      series = list(
        marker = list(enabled = FALSE),
        lineWidth = 1,
        shadow = FALSE,
        fillOpacity = 0.25,
        color = "white"
      )
    )
  )
  
  theme <- structure(theme, class = "hc_theme")
  
  if (length(list(...)) > 0) {
    theme <- hc_theme_merge(
      theme,
      hc_theme(...)
    )
  }
  
  theme
}