# Exploring presumptions about Liverpool's season
# Attacking issues
# Referees bias
# 12:30 matches causing problems


# Used Libraries

library(gt)
library(dplyr)
library(tidyr)
library(worldfootballR)
library(lubridate)
library(stringr)


table1 <- tibble(
  Player = c(
    "Mohamed Salah",
    "Darwin Núñez",
    "Diogo Jota",
    "Cody Gakpo",
    "Luis Díaz"
  ),
  Apps = c("28(4)", "22(14)", "14(7)", "17(18)", "32(5)"),
  Mins = c(2536, 2050, 1151, 1646, 2646),
  xG = c(22.17, 18.00, 6.54, 8.75, 13.04),
  Goals = c(18, 11, 10, 8, 8),
  xGDiff = c(-4.17, -7.00, 3.46, -0.75, -5.04),
  `xG/90` = c(0.79, 0.79, 0.51, 0.48, 0.44),
  Shots = c(114, 108, 41, 66, 94),
  `xG/Shots` = c(0.19, 0.17, 0.16, 0.13, 0.14),
  Rating = c(7.24, 6.89, 7.09, 6.87, 7.09)
)

table2 <- tibble(
  Player = c(
    "Luis Díaz",
    "Cody Gakpo",
    "Diogo Jota",
    "Mohamed Salah",
    "Darwin Núñez"
  ),
  Apps = c(32, 14, 14, 28, 22),
  Mins = c(2529, 1035, 1006, 2434, 1761),
  UnsuccessfulTouches = c(2.0, 1.6, 2.6, 2.5, 1.8),
  Dispossessed = c(2.1, 1.6, 0.9, 2.0, 1.1),
  Rating = c(7.18, 7.38, 7.41, 7.34, 7.19)
)

table3 <- tibble(
  Player = c(
    "Luis Díaz",
    "Cody Gakpo",
    "Diogo Jota",
    "Mohamed Salah",
    "Darwin Núñez"
  ),
  Apps = c(32, 14, 14, 28, 22),
  Mins = c(2529, 1035, 1006, 2434, 1761),
  Unsuccessful = c(2.1, 1.2, 1.4, 1.8, 0.9),
  Successful = c(2.1, 1.3, 1.0, 0.9, 0.4),
  TotalDribbles = c(4.2, 2.5, 2.4, 2.6, 1.3),
  Rating = c(7.18, 7.38, 7.41, 7.34, 7.19)
)

table4 <- tibble(
  Player = c(
    "Diogo Jota",
    "Cody Gakpo",
    "Mohamed Salah",
    "Darwin Núñez",
    "Luis Díaz"
  ),
  Apps = c(14, 14, 28, 22, 32),
  Mins = c(1006, 1035, 2434, 1761, 2529),
  Total = c(2.5, 2.9, 3.9, 4.1, 2.8),
  OffTarget = c(0.6, 1.1, 1.1, 1.5, 1.0),
  OnPost = c(0, 0, 0.1, 0.3, 0.1),
  OnTarget = c(1.2, 1.1, 1.9, 1.7, 0.9),
  Blocked = c(0.6, 0.6, 0.9, 0.8, 0.9),
  Rating = c(7.41, 7.38, 7.34, 7.19, 7.18)
)

.pal <- function(x) {
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

display_table <- function(data, title) {
  data |> 
    arrange(desc(Mins)) |> 
    gt() |> 
    tab_header(
      title = md(title),
      subtitle = md("*2023/2024 Premier League Season*")
    ) |> 
    opt_table_font(
      font = c(google_font("Karla"),
               default_fonts())
    ) |> 
    tab_options(
      heading.align = "left"
    ) |> 
    tab_footnote(footnote = "Injured during AFCON",
                 locations = cells_body(rows = 2, columns = 1),
    ) |> 
    tab_source_note(source_note = md("**Source:** WhoScored")) |> 
    tab_options(
      heading.align = "left",
      column_labels.background.color = "#F0F0F0",
      table.border.top.style = "hidden",
      table.border.bottom.style = "hidden",
      data_row.padding = px(10),
      footnotes.padding = px(0.2)
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
        )
      ),
      locations = cells_body()
    ) |> 
    tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_column_labels()
    )
}

# Display each table with the specified font and a title
display_table(table1, md("**xG Statistics**")) |> 
  data_color(columns = c(xGDiff, `xG/90`, xG, Goals),
             fn = .pal)

display_table(table2, md("**Touches and Dispossessions**")) |> 
  data_color(columns = c(UnsuccessfulTouches, Dispossessed),
             palette = RColorBrewer::brewer.pal(9, 'YlOrRd')[7:9])

display_table(table3, md("**Dribbles**")) |> 
  data_color(columns = c(Successful, TotalDribbles),
             fn = .pal) |> 
  data_color(columns = c(Unsuccessful),
             palette = RColorBrewer::brewer.pal(9, 'YlOrRd')[7:9])

display_table(table4, md("**Shots Accuracy**")) |> 
  tab_footnote(footnote = "Per Game",
               locations = cells_title(groups = c("title"))) |> 
  data_color(columns = c(OffTarget, OnPost, Blocked),
             palette = RColorBrewer::brewer.pal(9, 'YlOrRd')[3:7]) |> 
  data_color(columns = c(OnTarget, Total),
             palette = .pal)

url <- "https://fbref.com/en/squads/822bd0ba/2023-2024/Liverpool-Stats"
data <- fb_team_match_log_stats(team_urls = url, stat_type = "shooting")

data_2024 <- data |> 
  select(Date, ForAgainst, Time, Comp, Round, Venue, Result, GF, GA, Opponent, `G-xG` = G_minus_xG_Expected) |> 
  filter(ForAgainst == "For") |> 
  select(-ForAgainst)

my_gt_theme <- function(data){
  data |> 
    gt() |> 
    opt_table_font(
      font = c(google_font("Karla"),
               default_fonts()) 
    ) |> 
    tab_options(
      heading.align = "left"
    ) |> 
    tab_options(
      heading.align = "left",
      column_labels.background.color = "#F0F0F0",
      table.border.top.style = "hidden",
      data_row.padding = px(10),
      footnotes.padding = px(0.2)
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
        )
      ),
      locations = cells_body()
    ) |> 
    tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_column_labels()
    )
}

data_2024 |> 
  filter(Comp == "Premier League", month(Date) == 12) |> 
  select(-Comp, -Time) |> 
  mutate(Round = str_remove_all(Round, "Matchweek")) |> 
  my_gt_theme() |> 
  tab_header(
    title = "Liverpool's December Games",
    subtitle = "2023/2024 Premier League Season"
  ) |> 
  tab_header(
    title = md("**Liverpool's December Games**"),
    subtitle = md("*2023/2024 Premier League Season*")
  ) |> 
  fmt_date(
    columns = Date,
    date_style = "day_month"
  ) |> 
  cols_align(
    align = "center",
    columns = everything()
  ) |> 
  cols_label(
    Date = "Date",
    Venue = "Venue",
    Opponent = "Opponent",
    Result = "Result",
    GF = "Goals",
    `G-xG` = "Goals - xG"
  ) |> 
  tab_source_note(md("**Source:** FBref")) |> 
  data_color(columns = c(`G-xG`),
             palette = RColorBrewer::brewer.pal(9, 'RdYlGn')[1:9]) |> 
  data_color(columns = Result,
             palette = RColorBrewer::brewer.pal(9, 'RdYlGn')[c(4, 9, 1)])


refs_all_time <- tibble(
  Referee = c("Anthony Taylor", "Michael Oliver", "Martin Atkinson", "Andre Marriner", "Kevin Friend",
              "Craig Pawson", "Paul Tierney", "Jonathan Moss", "Phil Dowd", "Lee Mason",
              "Stuart Attwell", "Howard Webb", "Chris Kavanagh", "Mark Clattenburg", "Neil Swarbrick",
              "Lee Probert", "Mike Jones", "Mike Dean", "Peter Walton", "Andy Madley"),
  Apps = c(58, 54, 52, 48, 32, 31, 28, 26, 24, 22, 19, 19, 18, 17, 14, 13, 12, 12, 11, 10),
  Fouls_pg = c(10.22, 10.31, 10.48, 9.71, 10.38, 9.77, 11.43, 10.12, 12.54, 10.77,
               8.74, 12.11, 10.39, 10.76, 9.29, 9.46, 10.58, 10.17, 10.82, 12.60),
  Fouls_Tackles = c(0.36, 0.55, 0.51, 0.46, 0.58, 0.62, 0.74, 0.56, 0.60, 0.58,
                    0.56, 0.52, 0.58, 0.50, 0.50, 0.37, 0.52, 0.76, 0.45, 0.75),
  Pen_pg = c(0.10, 0.11, 0.13, 0.04, 0.03, 0.06, 0.04, 0.15, 0.13, 0.09,
             0.21, 0.11, 0.06, 0.12, 0.07, 0.08, 0.25, 0.17, 0.00, 0.20),
  Y_pg = c(1.78, 1.41, 1.38, 1.54, 1.22, 1.23, 1.68, 0.81, 1.92, 1.23,
           0.84, 1.53, 1.17, 1.53, 1.43, 0.85, 1.08, 1.00, 1.36, 1.50),
  R_pg = c(0.05, 0.02, 0.10, 0.04, 0.06, 0.00, 0.07, 0.12, 0.04, 0.14,
           0.00, 0.00, 0.00, 0.06, 0.00, 0.00, 0.17, 0.00, 0.00, 0.00)
)


refs_2024 <- tibble(
  Referee = c("Anthony Taylor", "Chris Kavanagh", "Paul Tierney", "Andy Madley", "Michael Oliver",
              "Simon Hooper", "Stuart Attwell", "Craig Pawson", "Tim Robinson", "David Coote",
              "John Brooks", "Thomas Bramall"),
  Apps = c(5, 6, 5, 5, 4, 4, 2, 2, 1, 1, 1, 1),
  Fouls_pg = c(13.33, 11.50, 13.40, 14.00, 10.25, 13.00, 6.00, 10.00, 11.00, 20.00, 10.00, 11.00),
  Fouls_Tackles = c(0.80, 0.56, 0.73, 0.78, 0.49, 0.79, 0.40, 0.80, 0.50, 1.05, 0.83, 0.73),
  Pen_pg = c(0.00, 0.00, 0.00, 0.20, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00),
  Y_pg = c(2.33, 1.50, 1.40, 1.80, 1.50, 2.00, 0.00, 0.50, 3.00, 5.00, 2.00, 1.00),
  R_pg = c(0.17, 0.00, 0.00, 0.00, 0.00, 0.50, 0.00, 0.00, 0.00, 0.00, 1.00, 1.00)
)

refs_2024 |>
  head(6) |> 
  arrange(desc(Fouls_pg)) |> 
  my_gt_theme() |> 
  tab_header(
    title = md("**Referees Statistics against Liverpool**"),
    subtitle = md("*2023/2024 Premier League Season*")
  ) |> 
  cols_label(
    Fouls_pg = "Fouls",
    Fouls_Tackles = "Fouls Per Tackle",
    Pen_pg = "Penalties",
    Y_pg = "Yellow Cars",
    R_pg = "Red Cards"
  ) |> 
  tab_footnote(footnote = "Per Game stats",
               locations = cells_column_labels(c(3,5,6,7))) |> 
  tab_footnote(footnote = "Referees from Greater Manchester",
               locations = cells_body(columns = 1, rows = c(2, 3, 5))) |> 
  tab_style(
    style = list(cell_fill(color = "lightblue")),
    locations = cells_body(rows = 2:4)
  ) |> 
  data_color(columns = 3:7,
             rows = 2:4,
             palette = RColorBrewer::brewer.pal(9, 'RdYlGn')[8:1])
  
refs_all_time |> 
  arrange(desc(Apps)) |> 
  head(10) |> 
  my_gt_theme() |> 
  tab_header(
    title = md("**Referees Statistics against Liverpool**"),
    subtitle = md("*All-Time Stats*")
  ) |> 
  cols_label(
    Fouls_pg = "Fouls",
    Fouls_Tackles = "Fouls Per Tackle",
    Pen_pg = "Penalties",
    Y_pg = "Yellow Cars",
    R_pg = "Red Cards"
  ) |> 
  tab_footnote(footnote = "Per Game stats",
               locations = cells_column_labels(c(3, 5, 6, 7))) |> 
  tab_footnote(footnote = "Referees from Greater Manchester",
               locations = cells_body(columns = 1, rows = c(1, 7, 10))) |> 
  tab_style(
    style = list(cell_fill(color = "lightblue")),
    locations = cells_body(columns = 1:2,
                           rows = c(1, 7))
  ) |> 
  data_color(columns = c(3, 4, 6, 7),
             rows = 1:10,
             palette = RColorBrewer::brewer.pal(9, 'RdYlGn')[9:1]) |> 
  data_color(columns = 5,
             rows = 1:10,
             palette = RColorBrewer::brewer.pal(9, 'RdYlGn')[1:9]) |> 
  tab_source_note(md("**Source:** WhoScored"))

  