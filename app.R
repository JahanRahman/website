library(shiny)
library(stringr)
library(dplyr)
library(DT)
library(shinyWidgets)
library(shinyanimate)
library(data.table)
library(shinyjs)
library(shinyBS)

load("/Users/jahanrahman/Desktop/development/processed.RData")

ui <-{
  fluidPage(
  tags$head(includeHTML("ad-sense.html")), #google adsense
  tags$style('.container-fluid {
                             background-color: #FFFFF;
              }'),
  withAnim(),
  tags$script(includeHTML("propeller.html")),
  navbarPage(title = "", theme = "shiny.css", 
    tabPanel(
      tags$div(id="hometab", tags$h4(style = "font-family:Courier;font-size: 25px", "Home")),
             tags$div(id = "title", tags$p(style = "font-family:Courier New;font-size: 140px;position:relative; left: 150px; top: 140px", "Grow to Give.")),
             fluidRow(column(width = 4, tags$div(style = "position:relative; top:130px; left:580px", id = 'videobutton', actionButton("shown", tags$b(style="font-family:Courier", "contribute NOW"))))),
             fluidRow(column(width = 12, tags$div(id = "subtitle", tags$p(style = "font-family:Courier New;font-size: 16px;position:relative; left: 165px; top:55px", "All ad revenue from this site goes to initiatives combatting racial injustice.",  tags$b("You learn, you contribute."))))),
      HTML('<div id="426231421">
    <script type="text/javascript">
        try {
            window._mNHandle.queue.push(function (){
                window._mNDetails.loadTag("426231421", "970x90", "426231421");
            });
        }
        catch (error) {}
    </script>
</div>')
      ),
    tabPanel(tags$div(id = "learnmenu",tags$h4(style = "font-family:Courier;font-size: 25px", "Learn")),
             verbatimTextOutput("url"),
             fluidRow(column(width = 1, offset= 10, actionButton("confirm", tags$div(style = "font-family:Courier;font-size: 15px", tags$b("View Selection"))))),
             DT::dataTableOutput("learningresources"),
             ),
    navbarMenu(tags$div(id="donatemenu",tags$h4(style = "font-family:Courier;font-size: 25px", "Donate")),
               "----",
               tabPanel(tags$h4(style = "font-family:Courier;font-size: 18px", "Organizations/Initiatives"),
                        tags$i(tags$h4(style = "font-family:Courier;font-size: 18px", "The names change but the color doesn't"))),
               "----",
               tabPanel(tags$h4(style = "font-family:Courier;font-size: 18px", "Bail Funds")),
               "----",
               tabPanel(tags$h4(style = "font-family:Courier;font-size: 18px", "Rebuilding Funds")),
               "----"),
    navbarMenu(tags$div(id="moremenu", tags$h4(style = "font-family:Courier;font-size: 25px", "More")),
               "----",
               tabPanel(tags$h4(style = "font-family:Courier;font-size: 18px", "Additional Resources")),
               "----",
               tabPanel(tags$h4(style = "font-family:Courier;font-size: 18px", "Feedback")),
               "----",
               tabPanel(tags$h4(style = "font-family:Courier;font-size: 18px", "Proof of Donation"),
                        tags$h4(style = "font-family:Courier;font-size: 18px", "Proof of Donation will be posted here when enough ad revenue is generated to reach adservice payout minimums.")
                        ),
               "----")),
  bsModal("modalExample", 
          title = tags$h3(style = "font-family:Courier", "All ad revenue from this video goes towards supporting the causes listed. Hit close to play in the background. View on YouTube directly to maximize contribution. (source: Zoe Amira)"), 
          "shown", 
          size = "large",
          fluidRow(column(width = 5, offset = 2, tags$div(id= "videoelement", htmlOutput('vidframe'))))
          ),
  bsModal("selectoutput", 
          title = tags$h3(style = "font-family:Courier", "Selected Entry"), 
          'confirm',
          size = "large",
          fluidRow(column(width = 5, offset = 2, htmlOutput('selectedresource')))
  ),
  
  
  )
}
  
  
server<- function(input, output, session){
  output$vidframe <- renderUI({
    test<-HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/bCgLa25fDHM?autoplay=1" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>', allowFullscreen = TRUE)
    test
  })
  
  
  output$learningresources <-DT::renderDataTable({read_in}, selection="single", options = list(dom = 'tp'))

  clicked <- eventReactive(input$learningresources_rows_selected,{
    read_in[input$learningresources_rows_selected]
  })
  
  #output$url <- renderText({paste0(clicked()[,2])})
    
  output$selectedresource <- renderUI({
    link <- paste0(clicked()[,2])
    output <- HTML(link)
    output
    })
  
  #animations
  animatetitle <-startAnim(session, id = 'title', "fadeInUp")
  animatesubtitle <-startAnim(session, id = 'subtitle', "fadeInUp")
  animatesubtitle2 <-startAnim(session, id = 'subtitle2', "fadeInUp")
  
  animatebutton <-startAnim(session, id = 'videobutton', "fadeInUp")
  
  animatehome <-startAnim(session, id = 'hometab', "fadeInDown")
  animatelearn <-startAnim(session, id = 'learnmenu', "fadeInDown")
  animatedonate <-startAnim(session, id = 'donatemenu', "fadeInDown")
  animatemore <-startAnim(session, id = 'moremenu', "fadeInDown")
  
  hoveranimatehome <- observe(addHoverAnim(session, 'hometab', 'pulse'))
  hoveranimatelearn <- observe(addHoverAnim(session, 'learnmenu', 'pulse'))
  hoveranimatedonate <- observe(addHoverAnim(session, 'donatemenu', 'pulse'))
  hoveranimatemore <- observe(addHoverAnim(session, 'moremenu', 'pulse'))
  
  hoveranimatebutton <- observe(addHoverAnim(session, 'videobutton', 'pulse'))
  
}

shinyApp(ui=ui, server=server)
# 
# 
# tags$head((HTML('<meta name="propeller" content="ca0b09f467b4d268dc540eb401e1429f">')),
#           HTML('<script data-ad-client="ca-pub-1262606844131429" async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>')
# )