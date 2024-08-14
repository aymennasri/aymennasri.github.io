# Display function for whoscored data

display_table <- function(data, title) {
  data |> 
    arrange(desc(data$Apps)) |> 
    my_gt_theme() |> 
    tab_header(
      title = md(title),
      subtitle = md("*2023/2024 Premier League Season*")
    ) |> 
    tab_footnote(footnote = "Injured during AFCON.",
                 locations = cells_body(rows = 2, columns = 1),
    ) |> 
    tab_source_note(source_note = md("**Source:** WhoScored")) |> 
    tab_footnote("Missed many games due to a knee injury.", 
                 locations = cells_body(columns = 1, rows = 5))
}