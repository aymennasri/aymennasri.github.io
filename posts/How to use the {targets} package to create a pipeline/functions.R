movies_features_plot <- function(data){
    data %>%
      filter(release_year = 2005) %>% 
      select(trailers, behind_the_scenes, commentaries, deleted_scenes) %>%
      summarise(trailers = sum(trailers), behind_the_scenes = sum(behind_the_scenes),
                commentaries = sum(commentaries), deleted_scenes = sum(deleted_scenes)) %>%
      pivot_longer(cols = everything(), names_to = 'Special Feature', values_to = 'Count') %>%
      plot_ly(labels = ~`Special Feature`, values = ~Count, type = 'pie') %>% 
      layout(paper_bgcolor = '#FFF1E5', 
             plot_bgcolor = '#FFF1E5', 
             xaxis = list(gridcolor = 'gray1'),
             yaxis = list(gridcolor = 'gray1'))
  }
