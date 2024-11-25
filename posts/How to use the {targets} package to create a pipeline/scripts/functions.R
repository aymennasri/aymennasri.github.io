get_data <- function(file){
  read_csv(file) %>% 
    mutate(rental_days = as.numeric((return_date - rental_date) / 24)) %>%
    select(rental_days, everything(), -c(rental_date, return_date)) %>% 
    mutate(trailers = ifelse(grepl("Trailers", special_features), 1, 0),
           behind_the_scenes = ifelse(grepl("Behind the Scenes", special_features), 1, 0),
           commentaries = ifelse(grepl("Commentaries", special_features), 1, 0),
           deleted_scenes = ifelse(grepl("Deleted Scenes", special_features), 1, 0))
}

movies_features_plot <- function(data){
  data %>%
    select(trailers, behind_the_scenes, commentaries, deleted_scenes) %>%
    summarise(trailers = sum(trailers), behind_the_scenes = sum(behind_the_scenes),
              commentaries = sum(commentaries), deleted_scenes = sum(deleted_scenes)) %>%
    pivot_longer(cols = everything(), names_to = "Special Feature", values_to = "Count") %>%
    plot_ly(labels = ~`Special Feature`, values = ~Count, type = "pie") %>% 
    layout(paper_bgcolor = '#FFF1E5', 
           plot_bgcolor = '#FFF1E5', 
           xaxis = list(gridcolor = "gray1"),
           yaxis = list(gridcolor = "gray1"))
}
movies_ratings_plot <- function(data){
  data %>% 
    summarize(R = sum(R), NC_17 = sum(`NC-17`), PG = sum(PG), PG_13 = sum(`PG-13`),
              no_rating = nrow(data) - sum(R + NC_17 + PG + PG_13)) %>% 
    pivot_longer(cols = everything(), names_to = "Rating", values_to = "Count") %>%
    plot_ly(labels = ~Rating, values = ~Count, type = "pie") %>% 
    layout(paper_bgcolor = '#FFF1E5', plot_bgcolor = '#FFF1E5',
           xaxis = list(gridcolor = "gray1"),
           yaxis = list(gridcolor = "gray1"))
}
  
movies_release_years_plot <- function(data){
  data %>% 
    group_by(release_year) %>% 
    summarise(count = n()) %>% 
    ggplot(aes(factor(release_year),count)) +
    geom_col() +
    labs(x ="Test",
         y = "")
  }

data_summary <- function(data){
  data %>% 
    select(rental_days, amount, rental_rate, length, replacement_cost) %>% 
    datasummary_skim()
}
corr_table <- function(data){
  data %>% 
    datasummary_correlation(method = "spearman") %>% 
    style_tt(i = 4, j = 3, background = "green", color = "black", bold = TRUE) %>% 
    style_tt(i = 2, j = 2, background = "lightgreen", color = "black", bold = TRUE) %>% 
    style_tt(i = 8:10, j = 8, background = "#FF7F7F", color = "black", bold = TRUE) %>% 
    style_tt(i = 9:10, j = 9, background = "#FF7F7F", color = "black", bold = TRUE) %>% 
    style_tt(i = 10, j = 10, background = "#FF7F7F", color = "black", bold = TRUE)
}

lm_model <- function(data){
  set.seed(6) 
  split <- data %>%
    initial_split(prop = 0.75)
  train <- training(split)
  test <- testing(split)
  
  rental_days_train <- train$rental_days
  rental_days_test <- test$rental_days
  train$rental_days = NULL
  test$rental_days = NULL
  formula <- rental_days_train ~ .
  
  preProc <- preProcess(train, method = c("center", "scale"))
  
  train <- predict(preProc, train)
  test <- predict(preProc, test)
  # Training
  lm_model <- lm(formula, data = train)

  # Testing
  pred <- predict(lm_model, newdata = test)

  # Calculating MSE
  lm_rmse <- RMSE(rental_days_test, pred)
  lm_mse <- lm_rmse^2
  metrics <- list(
    rmse = lm_rmse,
    mse = lm_mse
  )
  
  return(lm_model)
}

