pal <- function(x) {
  hex_neg = RColorBrewer::brewer.pal(9, 'YlOrRd')[9:7]
  hex_pos = RColorBrewer::brewer.pal(9, 'YlGn')[7:9]
  f_neg <- scales::col_numeric(
    palette = c(hex_neg),
    domain = c(pmin(x), 0)
  )
  f_pos <- scales::col_numeric(
    palette = c(hex_pos),
    domain = c(0, pmax(x))
  )
  ifelse(x < 0, f_neg(x), f_pos(x))
}