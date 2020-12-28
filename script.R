setwd("C:\\Users\\Geraud\\datasciencecoursera\\FruitClassification")
fruits <- read.csv(file='https://raw.githubusercontent.com/susanli2016/Machine-Learning-with-Python/master/fruit_data_with_colors.txt', sep='\t')
plot(fruits$height, fruits$width, col=fruits$fruit_label)
library(caret)
set.seed(400)
fruits_in_training <- createDataPartition(fruits$fruit_label, p=0.7, list=FALSE)
fruits_training <- fruits[fruits_in_training,]
fruits_testing <- fruits[-fruits_in_training,]
plot(fruits_training$height, fruits_training$width, col=fruits_training$fruit_label)

ctrl <- trainControl(method="cv",number = 10)
model_knn <- train(fruit_name~height+width, trControl = ctrl, method='knn', data=fruits_training, preProcess = c("center","scale"), tuneLength=10)

predict_knn <- predict(model_knn, newdata=fruits_testing)
confusionMatrix(predict_knn, fruits_testing$fruit_name)

# Generate a grid to draw KNN boundaries
lgrid <- expand.grid(height=seq(4, 12, by=0.1),
                    width=seq(5, 10, by=0.1))

knnPredGrid <- predict(model_knn, newdata=lgrid)
knnPredGrid = as.numeric(knnPredGrid)

g <- ggplot(data=lgrid) + stat_contour(aes(x=height, y=width, z=knnPredGrid), colour='black', bins=2) +
    geom_point(aes(x=height, y=width, colour=as.factor(knnPredGrid)), alpha=0.5, shape=1) +
    geom_point(data=fruits_training, aes(x=height, y=width, colour=as.factor(as.numeric(fruit_name))), shape=16) +
    geom_point(data=fruits_testing, aes(x=height, y=width, colour=as.factor(as.numeric(fruit_name))), shape=1) +
    xlab("Fruit height") + 
    ylab("Fruit width") +
    scale_colour_discrete("Fruit name", labels=c("Apple", "Lemon", "Mandarin", "Orange")) +
    theme_bw()
