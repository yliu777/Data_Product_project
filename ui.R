
library(shiny)


shinyUI(fluidPage(
    
    # Application title
    tabsetPanel(
        tabPanel("Home",
                 headerPanel("Central Limit Theorem Demonstration"),
                 
                 # Sidebar with controls to select the random distribution type
                 # and number of observations to generate
                 sidebarPanel(
                     radioButtons("dist", "Distribution type:",
                                  list("Normal" = "norm",
                                       "Uniform" = "unif",
                                       "Log-normal" = "lnorm",
                                       "Exponential" = "exp")),
                     br(),
                     
                     conditionalPanel(
                         condition = "input.dist == 'norm'",
                         numericInput("mean","Mean:",value=0),
                         numericInput("sd","Standard Deviation (SD):",value=1)
                     ),
                     
                     conditionalPanel(
                         condition = "input.dist == 'unif'",
                         sliderInput("range","Range:",min=0,max=1000,value=c(0,100))
                     ),
                     
                     
                     conditionalPanel(
                         condition = "input.dist == 'lnorm'",
                         numericInput("meanlog","Mean:",value=0),
                         numericInput("sdlog","Standard Deviation (SD):",value=1)
                     ),
                     
                     conditionalPanel(
                         condition = "input.dist == 'exp'",
                         numericInput("rate","Rate:",value=1)
                     ),
                     
                     br(),
                     
                     sliderInput("n", 
                                 "Number of samples:", 
                                 value = 500,
                                 min = 1, 
                                 max = 1000),
                     
                     sliderInput("size","Sample Size:",
                                 value = 1,
                                 min = 1,
                                 max=500),
                     
                     br(),
                     
                     checkboxInput("smean", "Show Sample Means", FALSE),
                     checkboxInput("normdist","Compare to Normal Distribution", FALSE)
                     
                     
                     
                 ),

                 mainPanel(
                     plotOutput("plot"),
                     br(),
                     h4(textOutput("statMean")),
                     h4(textOutput("statSD"))
                 )
        ),
        tabPanel("About",includeHTML("include.html"))
    )
))