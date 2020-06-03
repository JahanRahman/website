library(shiny)
library(stringr)
library(dplyr)
library(DT)
library(shinyWidgets)
library(shinyanimate)
library(data.table)
library(shinyjs)
library(shinyBS)


ui <-{
  fluidPage(tags$style('.container-fluid {
                             background-color: #FFFFF;
              }'),
  withAnim(),
  htmlOutput('propeller'),
  navbarPage(title = "", theme = "shiny.css", 
    tabPanel(
      tags$div(id="hometab", tags$h4(style = "font-family:Courier;font-size: 25px", "Home")),
             tags$div(id = "title", tags$p(style = "font-family:Courier New;font-size: 140px;position:relative; left: 150px; top: 140px", "Grow to Give.")),
             fluidRow(column(width = 12, tags$div(style = "position:relative; top:130px; left:580px", actionButton("shown", tags$b(style="font-family:Courier", "contribute NOW"))))),
             fluidRow(column(width = 12, tags$div(id = "subtitle", tags$p(style = "font-family:Courier New;font-size: 16px;position:relative; left: 165px; top:55px", "All AdSense profit from this site goes to initiatives combatting racial injustice.",  tags$b("You learn, you contribute."))))),
             ),
    
    navbarMenu(tags$div(id = "learnmenu",tags$h4(style = "font-family:Courier;font-size: 25px", "Learn")),
               "----",
               tabPanel(tags$h4(style = "font-family:Courier;font-size: 18px", "Society")),
               "----",
               tabPanel(tags$h4(style = "font-family:Courier;font-size: 18px", "Law")),
               "----",
               tabPanel(tags$h4(style = "font-family:Courier;font-size: 18px", "Health and Medicine")),
               "----"),
    navbarMenu(tags$div(id="donatemenu",tags$h4(style = "font-family:Courier;font-size: 25px", "Donate")),
               "----",
               tabPanel(tags$h4(style = "font-family:Courier;font-size: 18px", "In Memory of"),
                        tags$i(tags$h4(style = "font-family:Courier;font-size: 18px", "The names change but the color doesn't"))),
               "----",
               tabPanel(tags$h4(style = "font-family:Courier;font-size: 18px", "Organizations/Initiatives")),
               "----",
               tabPanel(tags$h4(style = "font-family:Courier;font-size: 18px", "Bail Funds")),
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
          title = tags$h3(style = "font-family:Courier; position:relative; left: 15px;font-size: 25px", "All ad revenue from this video goes towards supporting the causes listed. Hit close to play in the background. View on YouTube directly to maximize contribution. (source: Zoe Amira)"), 
          "shown", # <----set the observer to the right button
          size = "large",
          tags$div(id= "videoelement", style = "position:relative; left:150px;", htmlOutput('vidframe'))
          )
  
  )
}
  
  
server<- function(input, output, session){
  output$vidframe <- renderUI({
    test<-HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/bCgLa25fDHM?autoplay=1" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
    print(test)
    test
  })
  
  output$propeller <- renderUI({
    proptag<-HTML('<meta name="propeller" content="ca0b09f467b4d268dc540eb401e1429f">')
    print(proptag)
    proptag
  })
  #animations
  animatetitle <-startAnim(session, id = 'title', "fadeInUp")
  animatetitle <-startAnim(session, id = 'subtitle', "fadeInUp")
  animatetitle <-startAnim(session, id = 'subtitle2', "fadeInUp")
  
  animatehome <-startAnim(session, id = 'hometab', "fadeInDown")
  animatelearn <-startAnim(session, id = 'learnmenu', "fadeInDown")
  animatedonate <-startAnim(session, id = 'donatemenu', "fadeInDown")
  animatemore <-startAnim(session, id = 'moremenu', "fadeInDown")
  
  hoveranimatehome <- observe(addHoverAnim(session, 'hometab', 'pulse'))
  hoveranimatelearn <- observe(addHoverAnim(session, 'learnmenu', 'pulse'))
  hoveranimatedonate <- observe(addHoverAnim(session, 'donatemenu', 'pulse'))
  hoveranimatemore <- observe(addHoverAnim(session, 'moremenu', 'pulse'))
  
  
}

shinyApp(ui=ui, server=server)