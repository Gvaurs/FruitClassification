library(shiny)
library(caret)

set.seed(400)
fruits <- read.csv(file='https://raw.githubusercontent.com/susanli2016/Machine-Learning-with-Python/master/fruit_data_with_colors.txt', sep='\t')
fruits_in_training <- createDataPartition(fruits$fruit_label, p=0.7, list=FALSE)
fruits_training <- fruits[fruits_in_training,]
fruits_testing <- fruits[-fruits_in_training,]

getKnnModel <- function(){
    
    # Train the KNN model
    ctrl <- trainControl(method="cv",number = 10)
    model_knn <- train(fruit_name~height+width, trControl = ctrl, method='knn', data=fruits_training, preProcess = c("center","scale"), tuneLength=10)
    
    # Make predictions on the testing set
    predict_knn <- predict(model_knn, newdata=fruits_testing)
    model_knn
}

model <- getKnnModel()
lgrid <- expand.grid(height=seq(4, 12, by=0.1), width=seq(5, 10, by=0.1))
knnPredGrid <- predict(model, newdata=lgrid)
knnPredGrid = as.numeric(knnPredGrid)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    p <- ggplot(data=lgrid) + stat_contour(aes(x=height, y=width, z=knnPredGrid), colour='black', bins=2) +
        geom_point(aes(x=height, y=width, colour=as.factor(knnPredGrid)), alpha=0.5, shape=1)

    p <-  p +
        xlab("Fruit height") + 
        ylab("Fruit width") +
        scale_colour_discrete("Fruit name", labels=c("Apple", "Lemon", "Mandarin", "Orange")) +
        theme_bw()
    
    output$pred <- renderText({
        new_data = data.frame(height=input$fruit_height, width=input$fruit_width)
        fruit_pred <- predict(model, newdata=new_data)
        custom_scale <- p$scales$scales[[1]]$palette(4)
        paste("<font color=\"",custom_scale[as.numeric(fruit_pred)],"\"><b>",fruit_pred,"</b></font>")
    })

    output$fruitplot <- renderPlot({
        
        if (input$display_training){
            p <- p +
                geom_point(data=fruits_training, aes(x=height, y=width, colour=as.factor(as.numeric(fruit_name))), shape=16)
        }
        if (input$display_testing){
            p <- p +
                geom_point(data=fruits_testing, aes(x=height, y=width, colour=as.factor(as.numeric(fruit_name))), shape=16)
        }
        
        new_data = data.frame(height=input$fruit_height, width=input$fruit_width)
        fruit_pred <- predict(model, newdata=new_data)
        
        p <- p +
            geom_point(data=new_data, aes(x=height, y=width, colour=as.factor(as.numeric(fruit_pred))), shape=19, size=4)
        
        p
    })


})
