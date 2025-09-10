#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(dplyr)
library(mongolite)
library(Hmisc)
source(file = "script/html_parse.R")



search_listOflist <- function(l,pattern){
  res <- lapply(l, function(ch) grep(pattern, ch))
  rez = sapply(res, function(x) length(x) > 0)
  rez
}

# connection_string = 'http://localhost:27018/'
connection_string = 'mongodb://mongo:27017/'
trips_collection = mongo(collection="Scales", db="IdeeScaleDb", url=connection_string)
trips_collection$count()




agg <- "
[
    {
        '$project': {
            '_id': 1, 
            'name': 1, 
            'short name': 1, 
            'categories': 1, 
            'subcategories': 1, 
            'publication': 1, 
            'pub_url': 1, 
            'population': 1, 
            'passation type': 1, 
            'passation format': 1, 
            'language': 1
        }
    }
]
"


agg <- gsub("'",'"', agg)
data_description <- trips_collection$aggregate(agg)



data_description %>% filter(`passation type`== "collective/individual")




trips_collection$find(
  '{
  "_id": {"$oid":"68358c28952e472fed23922e"}
}'
)




# Define server logic required to draw a histogram
function(input, output, session) {
  
  ## Filter Categories
  categories <- data_description %>% pull(categories) %>% unlist() %>% unique()
  updateSelectInput(session, 'select_cat', choices = categories)
  subcategories <- data_description %>% pull(subcategories) %>% unlist() %>% unique()
  updateSelectInput(session, 'select_subcat', choices = subcategories)
  
  # Filter passation format
  passation_format <- data_description %>% pull(`passation format`) %>% unlist() %>% unique()
  updateSelectInput(session, 'select_passation_format', choices = passation_format)
  
  # Filter passation type
  passation_type <- data_description %>% pull(`passation type`) %>% unlist() %>% unique()
  updateSelectInput(session, 'select_passation_type', choices = passation_type)
  
  
  ## data_frame production 
  ### Data frame filter
  data_filter <- reactive({
    data_filter <- data_description
    
    if (!is.null(input$select_cat)){
      data_filter <- data_description %>% filter(search_listOflist(categories, input$select_cat))
    }
    
    if (!is.null(input$select_subcat)){
      data_filter <- data_filter %>% filter(search_listOflist(subcategories, input$select_subcat))
    }
    
    if (!is.null(input$select_passation_format)){
      data_filter <- data_filter %>% filter(`passation format`== input$select_passation_format)
    }
    
    if (!is.null(input$select_passation_type)){
      data_filter <- data_filter %>% filter(`passation type`== input$select_passation_type)
    }
    
    data_filter
  })
  ### Dataframe render 
  output$mytable = DT::renderDataTable({
    data_filter() %>% select(name, "short name",categories,subcategories,population,`passation type`)
  }, selection = "single")
  
  observeEvent(input$mytable_cell_clicked$row,{
    row <- input$mytable_cell_clicked$row
    # print(row)
    # print(data_filter()[row,])
    updateTabItems(session, "inTabset", selected = "eval")
  })
  
  scale_id <- reactive({
    row <- input$mytable_cell_clicked$row
    id <- data_filter()$`_id`[row]
    # print(id)
    id
  })
  
  scale_data <- eventReactive(input$mytable_cell_clicked$row,{
    row <- input$mytable_cell_clicked$row
    id <- data_filter()$`_id`[row]
    print(id)
    
    request <- paste0('{"_id": {"$oid":"', id , '"}}')
    # request <- gsub("'",'"', request)
    cat(request,"\n")
    
    scale_data <- trips_collection$find(query= request)
    print(scale_data)
    scale_data
  })
  

  output$scale_tile <- renderText({
    paste0(
      "Evaluation de l'échelle : ", scale_data()$name
    )
  })

  output$scale_abrev <- renderText({scale_data()$`short name`})
  output$scale_publication <- renderText({scale_data()$publication})
  output$scale_pub_url <- renderText({scale_data()$pub_url})
  
  output$scale_pop <- renderText({scale_data()$population})
  output$scale_pass_type <- renderText({scale_data()$`passation type`})
  output$scale_pass_format <- renderText({scale_data()$`passation format`})
  
  output$scale_language <- renderText({scale_data()$language})
  
  
  # output$scale_validity <- renderPrint({str(scale_data()$validity, depth=4)})
  
  output$scale_validity <- renderText({test_rec(scale_data()$validity,rank = 2)})
  output$scale_fidelity <- renderText({test_rec(scale_data()$fidelity,rank = 2)})
}
