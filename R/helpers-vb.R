grafico_vb_confirmados <- function(){
  
  d <- serie_nro_casos()
  
  f <- d %>% select(dia) %>% pull() %>% last()  
  
  d <- d %>% 
    mutate(dia = datetime_to_timestamp(dia)) %>% 
    select(x = dia, y = nro_casos)
  
  lbl <- d %>% pull(y) %>% last() %>% commac()
  aux <- d %>% 
    tail(8) %>% 
    mutate(z = lag(y)) %>% 
    mutate(v = y-z) %>% 
    select(v) %>% 
    filter(!is.na(v)) %>% 
    pull()
  nuevos_casos <- last(aux) %>% commac()
  total_casos_ult_7_dias <- sum(aux) %>% commac()
  
  jsev <- JS("function(){ Shiny.onInputChange('vb_chart', 'confirmados') }")
  
  hc <- hchart(d, "area", color = PARS$color$sparkline) %>% 
    hc_xAxis(type = "datetime") %>% 
    hc_add_theme(hc_theme_sparkline2()) %>% 
    hc_tooltip(pointFormat = "{point.x:%A %e de %B}<br><b>{point.y}</b> confirmardos") %>% 
    hc_plotOptions(
      series = list(
        color = PARS$color$sparkline,
        fillColor = list(
          linearGradient = list(x1 = 0, y1 = 1, x2 = 0, y2 = 0),
          stops = list(
            list(0.0, PARS$color$primary),
            list(1.0, PARS$color$sparkline)
          )
        )
      )
    ) %>% 
    hc_plotOptions(series = list(point = list(events = list(mouseOver = jsev))))
  
  valueBoxSpark(
    value = lbl,
    subtitle = HTML(paste0(nuevos_casos, " casos nuevos", "<br>", total_casos_ult_7_dias, " útlimos 7 días")),
    spark = hc,
    minititle = paste0("Confirmados"),
    color = "blue"
  )
}

grafico_vb_examenes <- function(){
  
  d <- serie_nro_examenes_establecimiento()
  
  d <- d %>% 
    filter(Establecimiento=="Total informados ultimo dia") %>% 
    select(dia, nro_examenes)
  
  f <- d %>% select(dia) %>% pull() %>% last()  
  
  d <- d %>% 
    mutate(dia = datetime_to_timestamp(dia)) %>% 
    select(x = dia, y = nro_examenes)
  
  lbl <- d %>% mutate(y = cumsum(y))  %>% pull(y) %>% last() %>% commac()
  aux <- d %>% 
    tail(7) %>% 
    select(y) %>% 
    pull()
  nuevos_casos <- last(aux) %>% commac()
  total_casos_ult_7_dias <- sum(aux) %>% commac()   
  
  jsev <- JS("function(){ Shiny.onInputChange('vb_chart', 'examenes') }")
  
  hc <- d %>% 
    mutate(y = cumsum(y)) %>% 
    hchart("area", color = PARS$color$primary) %>% 
    hc_xAxis(type = "datetime") %>% 
    hc_add_theme(hc_theme_sparkline2()) %>% 
    hc_tooltip(pointFormat = "{point.x:%A %e de %B}<br>{point.y}") %>% 
    hc_plotOptions(
      series = list(
        fillColor = list(
          linearGradient = list(x1 = 0, y1 = 1, x2 = 0, y2 = 0),
          stops = list(
            list(0.0, PARS$color$sparkline),
            list(1.0, PARS$color$primary)
          )
        )
      )
    ) %>% 
    hc_plotOptions(series = list(point = list(events = list(mouseOver = jsev))))
  
  valueBoxSpark(
    value = lbl,
    subtitle = HTML(paste0(nuevos_casos, " exámenes nuevos","<br>", total_casos_ult_7_dias, " últimos 7 días")),
    spark = hc,
    minititle = paste0("Exámenes")
  )
}

grafico_vb_fallecidos <- function(){
  
  d <- serie_nro_fallecidos()
  
  f <- d %>% select(dia) %>% pull() %>% last()  
  
  d <- d %>% 
    mutate(dia = datetime_to_timestamp(dia)) %>% 
    select(x = dia, y = nro_fallecidos)
  
  lbl <- d %>% pull(y) %>% last() %>% commac()
  aux <- d %>% 
    tail(8) %>% 
    mutate(z = lag(y)) %>% 
    mutate(v = y-z) %>% 
    select(v) %>% 
    filter(!is.na(v)) %>% 
    pull()
  nuevos_casos <- last(aux) %>% commac()
  total_casos_ult_7_dias <- sum(aux) %>% commac()
  
  jsev <- JS("function(){ Shiny.onInputChange('vb_chart', 'fallecidos') }")
  
  hc <- hchart(d, "area", color = PARS$color$sparkline) %>% 
    hc_xAxis(type = "datetime") %>% 
    hc_add_theme(hc_theme_sparkline2()) %>% 
    hc_tooltip(pointFormat = "{point.x:%A %e de %B}<br>{point.y}") %>% 
    hc_plotOptions(
      series = list(
        color = PARS$color$sparkline,
        fillColor = list(
          linearGradient = list(x1 = 0, y1 = 1, x2 = 0, y2 = 0),
          stops = list(
            list(0.0, PARS$color$primary),
            list(1.0, PARS$color$sparkline)
          )
        )
      )
    ) %>% 
    hc_plotOptions(series = list(point = list(events = list(mouseOver = jsev))))
  
  valueBoxSpark(
    value = lbl,
    subtitle = HTML(paste0(nuevos_casos, " nuevos fallecidos", "<br>", total_casos_ult_7_dias, " últimos 7 días")),
    spark = hc,
    minititle = paste0("Fallecidos"),
    color = "blue"
  )
}

grafico_vb_uci <- function(){
  
  d <- serie_nro_pascientes_UCI()
  
  f <- d %>% select(dia) %>% mutate_all(date) %>% pull() %>% last()  
  
  d <- d %>%
    mutate(dia = ymd(dia)) %>% 
    mutate(dia = datetime_to_timestamp(dia)) %>% 
    select(x = dia, y = nro_pascientes_uci)
  
  lbl <- d %>% pull(y) %>% last() %>% commac()
  aux <- d %>% 
    tail(8) %>% 
    mutate(z = lag(y)) %>% 
    mutate(v = y-z) %>% 
    select(v) %>% 
    filter(!is.na(v)) %>% 
    pull()
  
  nuevos_casos <- last(aux) %>% commac()
  
  total_casos_ult_7_dias <- sum(aux) %>% commac()
  
  jsev <- JS("function(){ Shiny.onInputChange('vb_chart', 'uci') }")
  
  hc <- hchart(d, "area", color = PARS$color$primary) %>% 
    hc_xAxis(type = "datetime") %>% 
    hc_add_theme(hc_theme_sparkline2()) %>% 
    hc_tooltip(pointFormat = "{point.x:%A %e de %B}<br>{point.y}") %>% 
    hc_plotOptions(
      series = list(
        fillColor = list(
          linearGradient = list(x1 = 0, y1 = 1, x2 = 0, y2 = 0),
          stops = list(
            list(0.0, PARS$color$sparkline),
            list(1.0, PARS$color$primary)
          )
        )
      )
    ) %>% 
    hc_plotOptions(series = list(point = list(events = list(mouseOver = jsev))))
  
  
  text_vb <- ifelse(
    nuevos_casos > 0,
    paste0(nuevos_casos, " nuevos pacientes UCI", "<br>", total_casos_ult_7_dias, " últimos 7 días"),
    paste0(abs(as.numeric(nuevos_casos)), " pacientes menos en UCI", "<br>", total_casos_ult_7_dias, " últimos 7 días")
  )
  
  
  valueBoxSpark(
    value = lbl,
    subtitle = HTML(text_vb),
    spark = hc,
    minititle = paste0("Pacientes UCI")
  )
}

grafico_vb_recuperados <- function(){
  
  d <- serie_recuperados()
  
  f <- d %>% select(dia) %>% mutate_all(date) %>% pull() %>% last()  
  
  d <- d %>%
    mutate(dia = ymd(dia)) %>% 
    mutate(dia = datetime_to_timestamp(dia)) %>% 
    select(x = dia, y = casos_recuperados)
  
  lbl <- d %>% pull(y) %>% last() %>% commac()
  
  aux <- d %>% 
    tail(8) %>% 
    mutate(z = lag(y)) %>% 
    mutate(v = y-z) %>% 
    select(v) %>% 
    filter(!is.na(v)) %>% 
    pull()
  
  nuevos_casos <- last(aux) %>% commac()
  
  total_casos_ult_7_dias <- sum(aux) %>% commac()
  
  hc <- hchart(d, "area", color = PARS$color$primary) %>% 
    hc_xAxis(type = "datetime") %>% 
    hc_add_theme(hc_theme_sparkline2()) %>% 
    hc_tooltip(pointFormat = "{point.x:%A %e de %B}<br>{point.y}") %>% 
    hc_plotOptions(
      series = list(
        fillColor = list(
          linearGradient = list(x1 = 0, y1 = 1, x2 = 0, y2 = 0),
          stops = list(
            list(0.0, "transparent"),
            list(1.0, PARS$color$sparkline)
          )
        )
      )
    )
  
  valueBoxSpark(
    value = lbl,
    subtitle = HTML(paste0(nuevos_casos, " nuevos recuperado", "<br>", total_casos_ult_7_dias, " últimos 7 días")),
    spark = hc,
    minititle = paste0("Recuperados")
  )
}

grafico_vb_letalidad <- function(){
  
  d <- serie_letalidad()
  
  f <- d %>% select(dia) %>% mutate_all(date) %>% pull() %>% last()  
  
  d <- d %>%
    mutate(dia = ymd(dia)) %>% 
    mutate(dia = datetime_to_timestamp(dia)) %>% 
    select(x = dia, y = porc)
  
  lbl <- d %>% pull(y) %>% last() %>% percentc()
  
  aux <- d %>% 
    tail(7) %>% 
    select(y) %>% 
    pull()
  
  jsev <- JS("function(){ Shiny.onInputChange('vb_chart', 'letalidad') }")
  
  hc <- d %>% 
    mutate(y = y*100) %>% 
    hchart("", color = PARS$color$primary) %>% 
    hc_xAxis(type = "datetime") %>% 
    hc_add_theme(hc_theme_sparkline2()) %>% 
    hc_tooltip(
      valueDecimals = 2,
      valueSuffix = " %",
      pointFormat = "{point.x:%A %e de %B}<br>{point.y}") %>% 
    hc_plotOptions(
      series = list(
        fillColor = list(
          linearGradient = list(x1 = 0, y1 = 1, x2 = 0, y2 = 0),
          stops = list(
            list(0.0, "transparent"),
            list(1.0, PARS$color$sparkline)
          )
        )
      )
    ) %>% 
    hc_plotOptions(series = list(point = list(events = list(mouseOver = jsev))))

  valueBoxSpark(
    value = lbl,
    subtitle = HTML(paste0(round(100 * (d %>% pull(y) %>% last())), " de cada 100 personas<br>contagiadas fallece")),
    spark = hc,
    minititle = paste0("Letalidad")
  )
}

grafico_vb_ventiladores<- function(){
  
  d <- serie_ventiladores() %>% 
    mutate(dia = datetime_to_timestamp(dia)) %>% 
    select(x = dia, y = porc)
  
  lbl <- d %>% pull(y) %>% last() %>% percentc()
  
  jsev <- JS("function(){ Shiny.onInputChange('vb_chart', 'ventiladores') }")
  
  hc <- d %>% 
    mutate(y = y*100) %>% 
    hchart("", color = PARS$color$primary) %>% 
    hc_xAxis(type = "datetime") %>% 
    hc_add_theme(hc_theme_sparkline2()) %>% 
    hc_tooltip(
      valueDecimals = 2,
      valueSuffix = " %",
      pointFormat = "{point.x:%A %e de %B}<br>{point.y}") %>% 
    hc_plotOptions(
      series = list(
        fillColor = list(
          linearGradient = list(x1 = 0, y1 = 1, x2 = 0, y2 = 0),
          stops = list(
            list(0.0, "transparent"),
            list(1.0, PARS$color$sparkline)
          )
        )
      )
    ) %>% 
    hc_plotOptions(series = list(point = list(events = list(mouseOver = jsev))))
  
  valueBoxSpark(
    value = lbl,
    subtitle = HTML(paste0(round(100 * (d %>% pull(y) %>% last())), " ventiladores disponibles<br> por cada 100")),
    spark = hc,
    minititle = paste0("Ventiladores")
  )

}