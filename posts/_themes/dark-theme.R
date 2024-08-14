theme_dark <- function() {
  ggthemes::theme_solarized_2(light = F) %+%
    theme(
      text = element_text(colour = "white"),
      axis.text = element_text(colour = "white"),
      axis.title = element_text(colour = "white"),
      legend.text = element_text(colour = "white"),
      legend.title = element_text(colour = "white"),
      strip.text = element_text(colour = "white"),
      rect = element_rect(colour = "#272b30", fill = "#272b30"),
      plot.background = element_rect(fill = "#222222", colour = NA),
      axis.line = element_line(colour = "white"),
      axis.ticks = element_line(colour = "white"),
      plot.title = element_text(colour = "white"),
      plot.subtitle = element_text(colour = "white"),
      plot.caption = element_text(colour = "white")
    )
}

darksvglite <- function(file, width, height) {
  on.exit(reset_theme_settings())
  theme_set(theme_dark())
  ggsave(
    filename = file,
    width = width,
    height = height,
    dev = "svg",
    bg = "transparent"
  )
}