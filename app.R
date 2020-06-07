library(shiny)
library(stringr)
library(dplyr)
library(DT)
library(shinyWidgets)
library(shinyanimate)
library(data.table)
library(shinyjs)
library(shinyBS)

#read_in <- fread("processed.txt", stringsAsFactors = F, header = TRUE, sep = "\t", quote = "")
load("processed.RData")

ui <-{
  fluidPage(
  title = "Grow to Give.",
  setBackgroundImage(src="background.png"),
  tags$head(includeHTML("ad-sense.html")), #google adsense
  withAnim(),
  theme = "shiny.css",
  tags$script(includeHTML("propeller.html")),
  navbarPage(id = "navbarpage", title = tags$h4(style = "font-family:Raleway-Regular, Fallback, sans-serif;font-size: 25px"),
    tabPanel(
      tags$div(id="hometab", tags$h4(style = "font-family:Raleway-Regular, Fallback, sans-serif; font-size: 25px; color: #000000", "Home")),
      br(),
      br(),
      br(),
      br(),
      br(),
             fluidRow(column(width = 12, tags$div(id = "title", tags$p(style = "font-family:Raleway-Regular, Fallback, sans-serif;font-size: 140px;color: #000000; text-align: center", "Grow to Give.")))),
             fluidRow(column(width = 12,tags$div(id = "subtitle", tags$p(style = "font-family:Raleway-Regular, Fallback, sans-serif;font-size: 17px; color: #000000; text-align: center", "All ad revenue from this site goes to initiatives combatting racial injustice.",  tags$b("You learn, you contribute."))))),
             fluidRow(column(width = 3, offset= 5, tags$div(id = 'videobutton', actionButton("shown", tags$b(style="font-family:Raleway-Regular, Fallback, sans-serif; font-size: 20px;", "contribute NOW"), style="color: #000000; background:rgb(0,0,0,0); border-color: #000000")))),

      ),
    tabPanel(tags$div(id = "learnmenu",tags$h4(style = "font-family:Raleway-Regular, Fallback, sans-serif;font-size: 25px; color: #000000", "Learn")),
             verbatimTextOutput("url"),
             fluidRow(column(width = 1, offset= 10, actionButton("confirm", tags$div(id = "confirmselection", style = "font-family: Raleway-Regular, Fallback, sans-serif; font-size: 18px", tags$b("View Selection")), style="color: #000000; background:rgb(0,0,0,0); border-color: #000000"))),
             tags$br(),
             tags$div(style = "background-color: rgb(210,210,0, 1)",DT::dataTableOutput("learningresources")),
             ),
    tabPanel(tags$div(id = "sharetab", tags$h4(style = "font-family:Raleway-Regular, Fallback, sans-serif;font-size: 25px; color: #000000", "Share"))),
    tabPanel(tags$div(id="visualizetab", tags$h4(style = "font-family:Raleway-Regular, Fallback, sans-serif;font-size: 25px; color: #000000", "Visualize"))
             
    ),
    tabPanel(tags$div(id="donatemenu", tags$h4(style = "font-family:Raleway-Regular, Fallback, sans-serif;font-size: 25px; color: #000000", "Donate"))
             
             
             ),
    
    
    navbarMenu(tags$div(id="moremenu", tags$h4(style = "font-family:Raleway-Regular, Fallback, sans-serif;font-size: 25px; color: #000000", "More")),
               "----",
               tabPanel(tags$h4(style = "font-family:Raleway-Regular, Fallback, sans-serif;font-size: 18px; color: #000000", "Sharing")),
               "----",
               tabPanel(tags$h4(style = "font-family:Raleway-Regular, Fallback, sans-serif;font-size: 18px; color: #000000", "Additional Resources")),
               "----",
               tabPanel(tags$h4(style = "font-family:Raleway-Regular, Fallback, sans-serif;font-size: 18px; color: #000000", "Proof of Donation"),
                        tags$h4(style = "font-family:Raleway-Regular, Fallback, sans-serif;font-size: 18px; color: #000000", "Proof of Donation will be posted here when enough ad revenue is generated to reach payout minimum.")
                        ),
               "----")),
  bsModal("modalExample", 
          title = tags$h3(style = "font-family:Raleway-Regular, Fallback, sans-serif", "All ad revenue from this video goes towards supporting the causes listed. Hit close to play in the background. View on YouTube directly to maximize contribution. (source: Zoe Amira)"), 
          "shown", 
          size = "Large",
          fluidRow(column(width = 5, tags$div(id= "videoelement", htmlOutput('vidframe'))))
          ),
  bsModal("selectoutput", 
          title = tags$h3(style = "font-family:Raleway-Regular, Fallback, sans-serif", "Selected Entry"), 
          'confirm',
          size = "large",
          fluidRow(column(width = 5, offset = 2, htmlOutput('selectedresource')))
  ),
  
  
  )
}
  
  
server<- function(input, output, session){
  output$vidframe <- renderUI({
    test<-HTML('<iframe width="400" height="315" src="https://www.youtube.com/embed/bCgLa25fDHM?autoplay=1" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
    test
  })
  

  output$learningresources <-DT::renderDataTable({read_in}, selection="single", options = list(dom = 'tp', lengthMenu = c(20, 50, 100), pageLength = 50))

  clicked <- eventReactive(input$learningresources_rows_selected,{
    read_in[input$learningresources_rows_selected]
  })
  
  #output$url <- renderText({paste0(clicked()[,2])})
    
  output$selectedresource <- renderUI({
    link <- paste0(clicked()[,2])
    output <- HTML(src= "http://booksc.xyz/ireader/64350046", style = "height = 400 width = 400")
    output
    })
  
  #animations
  animatetitle <-startAnim(session, id = 'title', "fadeInUp")
  animatesubtitle <-startAnim(session, id = 'subtitle', "fadeInUp")
  animatesubtitle2 <-startAnim(session, id = 'subtitle2', "fadeInUp")
  
  animatebutton <-startAnim(session, id = 'videobutton', "fadeInUp")
  
  animatehome <-startAnim(session, id = 'hometab', "fadeInDown")
  animateshare <-startAnim(session, id = 'sharetab', "fadeInDown")
  animatelearn <-startAnim(session, id = 'learnmenu', "fadeInDown")
  animatevisualize<-startAnim(session, id = 'visualizetab', "fadeInDown")
  animatedonate <-startAnim(session, id = 'donatemenu', "fadeInDown")
  animatemore <-startAnim(session, id = 'moremenu', "fadeInDown")
  
  hoveranimatehome <- observe(addHoverAnim(session, 'hometab', 'pulse'))
  hoveranimateshare <- observe(addHoverAnim(session, 'share', 'pulse'))
  hoveranimatelearn <- observe(addHoverAnim(session, 'learnmenu', 'pulse'))
  hoveranimatevisualize <- observe(addHoverAnim(session, 'visualizetab', 'pulse'))
  hoveranimatedonate <- observe(addHoverAnim(session, 'donatemenu', 'pulse'))
  hoveranimatemore <- observe(addHoverAnim(session, 'moremenu', 'pulse'))
  
  hoveranimatetitle <- observe(addHoverAnim(session, 'title', 'pulse'))
  
  hoveranimatebutton <- observe(addHoverAnim(session, 'videobutton', 'pulse'))
  hoveranimatebutton2 <- observe(addHoverAnim(session, 'confirmselection', 'pulse'))
}

shinyApp(ui=ui, server=server)
# 
# 
# tags$head((HTML('<meta name="propeller" content="ca0b09f467b4d268dc540eb401e1429f">')),
#           HTML('<script data-ad-client="ca-pub-1262606844131429" async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>')
# )