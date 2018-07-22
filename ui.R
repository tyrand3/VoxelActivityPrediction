# Define server logic required to summarize and view the selected dataset
shinyServer(
  pageWithSidebar(
    headerPanel("My APP"),
    
    sidebarPanel(
    selectInput("Distribution","",
                choices = c("-")),
    
    
    sliderInput("sampleSize","Please Select Bandwith: ",
                min=1,max =35,value = 35, step=1),
    
    sliderInput("sampleSize2","Please Select z plane: ",
                min=1,max =16,value = 16, step=1),

  
    conditionalPanel(condition = "input.Distribution == 'Normal' ",
                    textInput("Mean", "Please Select Z plane", 16))

    ),
    
    mainPanel(
    plotOutput("myPlot")
    )
  )
)
