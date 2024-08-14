my_gt_theme <- function(data){
  data |> 
    gt() |> 
    opt_table_font(
      font = c(google_font("Karla"),
               default_fonts()) 
    ) |> 
    tab_options(
      heading.align = "left",
      column_labels.background.color = "#F0F0F0",
      table.border.top.style = "hidden",
      table.border.bottom.style = "hidden",
      data_row.padding = px(10),
      footnotes.padding = px(1),
      table.background.color = "transparent"
    ) |> 
    cols_align(
      align = "center",
      columns = everything()
    ) |> 
    tab_style(
      style = list(
        cell_borders(
          sides = c("top", "bottom"),
          color = "#D3D3D3",
          weight = px(1)
        )),
      locations = cells_body()
    ) |> 
    tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_column_labels()
    )
}
