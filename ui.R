# Define server logic required to summarize and view the selected dataset
shinyServer(
  pageWithSidebar(
    headerPanel("Voxel Activity Prediction"),
    
    sidebarPanel(
    selectInput("Distribution","",
                choices = c("-")),
    
    
    sliderInput("bandwith","Please Select Bandwith: ",
                min=1,max =35,value = 35, step=1),
    
    sliderInput("zplane","Please Select z plane: ",
                min=1,max =16,value = 16, step=1),

  
    conditionalPanel(condition = "input.Distribution == 'Normal' ",
                    textInput("Mean", "", 0))

    ),
    
    mainPanel(
    plotOutput("myPlot")
    )
  )
)
