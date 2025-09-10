#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(shinydashboard)
library(DT)

includeCSS("template.css")


# Define UI for application that draws a histogram
dashboardPage(
  # includeCSS("template.css"),
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      id = "inTabset",
      menuItem("Recherche", tabName = "search", icon = icon("dashboard")),
      menuItem("Evaluation", tabName = "eval", icon = icon("th"))
    )
    
    
    
  ),
  dashboardBody(
    
    tabItems(
      # First tab content
      tabItem(tabName = "search",
              h2("Recherche d'échelle"),
              
              fluidRow(
                column(12, align="center",
                       selectizeInput(
                         inputId = "searchme", 
                         label = "Search Bar",
                         multiple = TRUE,
                         choices = paste0(LETTERS,sample(LETTERS, 26)),
                         options = list(
                           create = FALSE,
                           placeholder = "chercher une échelle",
                           onDropdownOpen = I("function($dropdown) {if (!this.lastQuery.length) {this.close(); this.settings.openOnFocus = false;}}"),
                           onType = I("function (str) {if (str === \"\") {this.close();}}"),
                           onItemAdd = I("function() {this.close();}")
                         )
                       )
                )
              ),
              
              fluidRow(
                box( title="Types d'échelle",width=4,
                     
                     selectInput("select_cat", label = h3("Catégorie"), 
                                 choices = c(), 
                                 selected = NULL, multiple = TRUE),
                     selectInput("select_subcat", label = h3("Sous-Type"), 
                                 choices = c(), 
                                 selected = NULL, multiple = TRUE),
                ),
                box( title="Format de passation",width=4,
                     
                     selectInput("select_passation_format", label = h3("Présentation"), 
                                 choices = c(), 
                                 selected = NULL, multiple = TRUE),
                     selectInput("select_medium", label = h3("Supports"), 
                                 choices = list("Papier" = 1, "Informatique" = 2, "La réponse D" = 3), 
                                 selected = 1),
                ),
                box( title="Type  de passation",width=4,
                     
                     selectInput("select_passation_type", label = h3("Type de Passation"), 
                                 choices = c(), 
                                 selected = NULL, multiple = TRUE),
                     selectInput("select_pass", label = h3("Type d'évaluation"), 
                                 choices = list("Auto-évaluation" = 1, "Evaluateur" = 2), 
                                 selected = 1),
                ),
                
                
              ),
              fluidRow(
                fluidRow(
                  column(11,
                         DT::dataTableOutput("mytable")
                  )
                  
                )
              )
              
      ),
      tabItem(tabName = "eval",
              h1(textOutput("scale_tile")),
              h2("Information"),
              fluidRow(
                column(4,
                       h4("Abreviation : "), textOutput("scale_abrev"),
                       h4("Publication : "), textOutput("scale_publication"),
                       h4("Lien : "), textOutput("scale_pub_url")
                       ),
                column(4,
                       h4("Population : "), textOutput("scale_pop"),
                       h4("Type de passation : "), textOutput("scale_pass_type"),
                       h4("Format de passation : "), textOutput("scale_pass_format")
                ),
                column(4,
                       h4("Langue : "), textOutput("scale_language"),
                       # h4("Publication : "), textOutput("scale_publication"),
                       # h4("Lien : "), textOutput("scale_pub_url")
                ),
                      
              ),
              h2("Détails psychométriques : "),
              fluidRow(
                # verbatimTextOutput("scale_validity")
                # htmlOutput("scale_validity")
                
                box(
                  title = h2("Validity"), width = 4, solidHeader = TRUE, status = "primary",
                  htmlOutput("scale_validity")
                  
                ), 
                # box(
                #   title = h2("Fidelity"), width = 4, solidHeader = TRUE, status = "primary",
                #   htmlOutput("scale_fidelity")
                #   
                # ), 
              )
                
              )
    ),
    
    
  )
)


