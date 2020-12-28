library(shiny)

# Define UI for the fruit classification application
shinyUI(fluidPage(

    # Application title
    titlePanel("Fruit classification application"),
    
    tabsetPanel(
        tabPanel("Documentation", mainPanel(
            h3("Description"),
            p("This application is a fruit classification application based on fruit height and fruit width. The application can classify 4 types of fruits: apple, lemon, mandarin and orange."),
            h3("Classification model"),
            p("The classification model is based on a K-nearest-neighbors (KNN) algorithm:"),
            a("https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm",href="https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm"),
            br(),
            br(),
            p("The model has been trained (and tested) on the fruits dataset from:"),
            a("https://www.kaggle.com/mjamilmoughal/fruits-with-colors-dataset",href="https://www.kaggle.com/mjamilmoughal/fruits-with-colors-dataset"),
            br(),
            br(),
            p("The accuracy of the algorithm on the testing set is approximately 75%"),
            h3("Usage"),
            p("The user can input the fruit height and width and see the resulting prediction."),
            p(" The application also displays the KNN model boundaries, as well as the data points from the training and test datasets."),
            h3("Additional documentation & source code"),
            p("A pitch presentation of this application can be found at:"),
            a("https://gvaurs.github.io/FruitClassification/presentation",href="https://gvaurs.github.io/FruitClassification/presentation"),
            br(),
            br(),
            p("The source code of this application is hosted on GitHub:"),
            a("https://github.com/Gvaurs/FruitClassification",href="https://github.com/Gvaurs/FruitClassification"),
            
        )),
        tabPanel("Application",     
                 # Sidebar with a slider input for number of bins
            sidebarLayout(
                sidebarPanel(
                    checkboxInput("display_training", "Display training set points", value = TRUE),
                    checkboxInput("display_testing", "Display test set points", value = TRUE),
                    sliderInput("fruit_height","New fruit height:",min = 4, max = 12, value = 8, step=0.1),
                    sliderInput("fruit_width","New fruit width:",min = 5, max = 10, value = 7.5, step=0.1),
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                    plotOutput("fruitplot", width=600),
                    
                    tags$head(tags$style("#container * {  display: inline;}")),
                        div(id="container","Fruit prediction: ", htmlOutput("pred"))
                )
        ))
    )
))
