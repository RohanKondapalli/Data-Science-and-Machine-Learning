#Classification Machine Learning Technique - Not regression
#Build a model which tells whether a tumor is benign or malignant and what features affect this
#Build multiple models

library(caret)
library(corrplot)
library(cowplot)
library(e1071)
library(ggplot2)
library(kknn)
library(pROC)
library(randomForest)

data = read.csv("cData.csv")
#check for NA using summary and > colSums(is.na(data))
data = data[, -c(1, 2, 34)]

data=data[complete.cases(data),]
View(data)

data = data[-which(data$diagnosis==""),]
data$diagnosis = ifelse(data$diagnosis == "M", 1, ifelse(data$diagnosis == "B", 0, 1))
#str(), summary(), dim(), unique values for diagnosis
#check for NA


#### PLOT ONE VARIABLE GRAPH FOR ALL VARIABLES

#data$diagnosis = as.factor(ifelse(data$diagnosis=="B", "Benign", "Malignant))

#plot the diagnosis on single variable graph and identify any odd behavior

ggplot(data,aes(diagnosis)) + geom_bar(fill = "red")

# we observe one data point with no diagnosis code and hence we will remove
# row 52 (We can either set it as B, M, or just remove the row)
## data=data[-52,] - unnecessary - handled by line 25

# how many are benign and malignant
table(data$diagnosis) #unique values
prop.table(table(data$diagnosis)) # provides percentage split

#create a correlation plot without diagnosis

# difficult to visualize, remove first column as that isn't numeric -
# won't work for the correlation matrix - can try to make the entire first 
#column integers/numeric
all = cor(data[, -1]) 

corrplot(all, method="pie", type = "lower")

data$diagnosis=ifelse(data$diagnosis == "M",1,0) # makes whole first column numeric
#1 is malignant, 0 is benign

table(data$diagnosis)

all = cor(data)
corrplot(all, method = "pie", type = "lower")

# for the plot, the amount of each pie that is shaded in shows how much each feature will affect the diagnosis

#there are 3 different categories of datasets in cancer data: mean(2-11), standard error(12-21), and worst(22-31)
#here mean means the means of all cells, standard error of all cells and worst means the worst of all cells

#cor for mean
x=cor(data[,c(1:11)]) #column 1 is including the diagnosis to find what features affect the diagnosis - we will see that area_mean and concavepoint_mean affect this, as well as perimiter_mean and radius_mean being strong
#since radius_mean and perimiter_mean are heavily correlated, there's no point using both - only pick one in my prediction
#if we pick features that aren't heavily correlated with each other, then we get additional information for our prediction
corrplot(x) # we need not visualize all 30 variables

#cor for se_error
y=cor(data[,c(12:21)])
corrplot(y)

#cor for worst
z = cor(data[,c(22:31)])
corrplot(z)

foo = heat.colors(12, rev = TRUE)
heatmap(all,col=col,symm=F)
heatmap(all,col=col,symm)
heatmap(all,Rowv = FALSE, Colv=FALSE)
#analysis:  high correlation value means it has “collinearity” between variables.
#Use one variable only with high correlation for model development as it does not add much value to use similar features.

#the radius, parameter and area are highly correlated as expected from their relation so from these we will use anyone of them
#compactness_mean, concavity_mean and concavepoint_mean are highly correlated so we will use compactness_mean from here
#so selected Parameter for use is perimeter_mean, texture_mean, compactness_mean, symmetry_mean*

####################################### Visualization
################# UNIVARIATE ANALYSIS ONE VARIABLE PLOTS

#These plots show that, in general, malignant diagnoses have higher scores in all variables.

data$diagnosis = as.factor(data$diagnosis)
####These plots show that, in general, malignant diagnoses have higher scores in all variables.
p1=ggplot(data = data, aes(y=radius_mean, fill=diagnosis)) + geom_boxplot() 
#plot boxplots for all variables for _mean and assign them to a variable
p2=ggplot(data = data, aes(y=area_mean, fill=diagnosis)) + geom_boxplot()
p3=ggplot(data = data, aes(y=perimeter_mean, fill=diagnosis)) + geom_boxplot()
p4=ggplot(data = data, aes(y=concave.points_mean, fill=diagnosis)) + geom_boxplot()
p5=ggplot(data = data, aes(y=concavity_mean, fill=diagnosis)) + geom_boxplot()
p6=ggplot(data = data, aes(y=compactness_mean, fill=diagnosis)) + geom_boxplot()
p7=ggplot(data = data, aes(y=smoothness_mean, fill=diagnosis)) + geom_boxplot()
p8=ggplot(data = data, aes(y=symmetry_mean, fill=diagnosis)) + geom_boxplot()
p9=ggplot(data = data, aes(y=texture_mean, fill=diagnosis)) + geom_boxplot()
p10=ggplot(data = data, aes(y=fractal_dimension_mean, fill=diagnosis)) + geom_boxplot()

#### put all plots on one graph
    # used for combining multiple plots 
plot_grid(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)
#-------------- Visualization Complete --- 
  ############## building models ############
#Split Test and Training Dataset
set.seed(1234567890)
index = createDataPartition(data$diagnosis, p=0.7, list=F)
training = data[index,]
testing = data[-index,]

# check how many malignant and benign cells in train dataset
table(training$diagnosis)
# check how many malignant and benign cells in test dataset
table(testing$diagnosis)
#Remove imbalance from data


###########################################Logistic Regression
#for glm select only one category of data else it is difficult to converge 
train_mean=training[,c(1:11)] 
train_mean
# THURS: Review correlation plot and pick the best features to begin with
#make sure that diagnosis is a numeric variable for logistic regression
# now these are the variables which will use for prediction based on corr. no errors

# picking the best features to predict diagnosis of cancer. Removing collinearity by only picking one feature from heavily correlated features
#collinearity: eg: picking only one feature, eg: perimeter_mean between (area_mean, radius_mean, perimeter_mean)
prediction_var = c('diagnosis', 'texture_mean','perimeter_mean','smoothness_mean','compactness_mean','symmetry_mean')

#create a dataset with only the features selected above

#build logistic regression model
train_mean_features = train_mean[, prediction_var]


model.lg = glm(diagnosis~., train_mean_features, family=binomial(link="logit"))
summary(model.lg)
prediction_results.lg = predict(model.lg, testing, type="response")
prediction_results.lg

myLGresults = ifelse(prediction_results.lg < 0.5, 0, 1)
#test_mean_features$prediction_results = prediction_results.lg
#test_mean_features$results = myLGresults
summary(myLGresults)
accuracy.glm = mean(myLGresults == testing$diagnosis)
accuracy.glm #0.9470588
### CONFUSION MATRIX
cm_lg  <- confusionMatrix(as.factor(myLGresults), as.factor(test_mean_features$diagnosis))   
cm_lg
# Confusion Matrix and Statistics
# 
#               Reference
# Prediction  0     1
#   0         76   34
#   1         31     29


#Prediction using K-nearest Neighbor:
index_knn = createDataPartition(data$diagnosis, p=0.7, list=F)
train_data = data[index_knn,]
test_data = data[-index_knn,]
model.knn = train(diagnosis ~., training, method="kknn")


prediction_results.knn = predict(model.knn, testing)

accuracy.knn = mean (prediction_results.knn == testing$diagnosis)
accuracy.knn #0.9764706

#confusion matrix:
cm_knn  <- confusionMatrix(as.factor(prediction_results.knn), as.factor(testing$diagnosis))   
cm_knn

# Run the model on entire dataset, and not just selected features to check for 
#accuracy and gradually remove one feature at a time
model.rf = train(diagnosis~., training, method="rf")
predict.rf = predict(model.rf, testing)
accuracy.rf = mean(predict.rf==testing$diagnosis)
accuracy.rf #0.9705882
cm_rf  <- confusionMatrix(as.factor(predict.rf), as.factor(testing$diagnosis))   
cm_rf
# 
# Reference
# Prediction   0   1
# 0 105   3
# 1   2  60

######Rpart (recursive partitioning and regression trees)
## Identify the variables that will be used for prediction
## train the model
model.rpart = train(diagnosis~., training, method="rpart")
predict.rpart = predict(model.rpart, testing)
accuracy.rpart = mean(predict.rpart==testing$diagnosis)
accuracy.rpart #0.9470588
cm_rpart  <- confusionMatrix(as.factor(predict.rpart), as.factor(testing$diagnosis))   
cm_rpart

######################### Support Vector Machines 
model.svm <- svm(diagnosis~., data=training)

predict.svm=predict(model.svm, testing)
accuracy.svm = mean(predict.svm==testing$diagnosis)
accuracy.svm #0.9823529
cm_svm=confusionMatrix(as.factor(predict.svm), as.factor(testing$diagnosis))
cm_svm
#Reference
#Prediction   0   1
#0 105   1
#1   2  62

####################### Class imbalance
table(training$diagnosis)
# Benign: 250 ; Malignant: 149

# Final Analysis + Observations
AllModels = c(model.lg, model.rf, model.knn, model.rpart, model.svm)
FinalAccuracy = c(accuracy.glm, accuracy.rf, accuracy.knn, accuracy.rpart, accuracy.svm)
FinalTable=data.frame(AllModels, FinalAccuracy)

modelsUsed = c("Logistic Regression", "Random Forest", "KKNN", "SVM", "R-Part")
accuracy = c(accuracyCancerPredictions, accuracyRF, accuracyKKNN, accuracy.svm, accuracy.rpart)
observationTable = data.frame(modelsUsed, accuracy)