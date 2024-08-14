theme_set(ggthemes::theme_solarized_2() %+% 
            theme(
              plot.background = element_rect(fill = "#FFF1E5"),
              panel.border = element_blank(),
              axis.line = element_line(colour = "#586e75",
                                       linetype = 1),
              axis.ticks = element_line(colour = "#586e75"),
              axis.text = element_text(colour = "#002b36")))

lightsvglite <- function(file, width, height) {
  on.exit(reset_theme_settings())
  theme_set(ggthemes::theme_solarized_2() %+% 
              theme(
                plot.background = element_rect(fill = "#FFF1E5"),
                panel.border = element_blank(),
                axis.line = element_line(colour = "#586e75",
                                         linetype = 1),
                axis.ticks = element_line(colour = "#586e75"),
                axis.text = element_text(colour = "#002b36")))
  ggsave(
    filename = file,
    width = width,
    height = height,
    dev = "svg",
    bg = "transparent"
  )
}