######################################################
### Fit the regression model with testing data ###
######################################################

### Author: Qingyang Zhong
### Project 3

### Fit the classfication model with testing data

### Input: 
###  - the fitted classification model list using training data
###  - processed features from testing images 
### Output: training model specification

test_randomforest <- function(modelList, dat_test){
  
  ### load libraries
  library("randomForest")
  
  predArr <- array(NA, c(dim(dat_test)[1], 4, 3))
  
  for (i in 1:12){
    fit_train <- modelList[[i]]
    ### calculate column and channel
    c1 <- (i-1) %% 4 + 1
    c2 <- (i-c1) %/% 4 + 1
    featMat <- dat_test[, , c2]
    ### make predictions
    predArr[, c1, c2] <- predict(fit_train$fit, newdata=featMat,type="response")
  }
  return(predArr)
}

