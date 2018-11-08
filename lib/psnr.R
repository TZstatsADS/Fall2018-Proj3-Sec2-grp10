#############################################################
### Calculating PSNR for models###
#############################################################

### Authors: Qingyang Zhong
### Project 3

### Input: a path for high-resolution images from train set
###       + a path for high-resolution images from test set
### Output: PSNR of model

# load libraries
library("EBImage")

#Calculate MSE
MSE <- function(pred,true) { 
  mean((pred-true)^2)
}

#Calculate PSNR
 ## Define PSNR
psnr <- function(pred,true) {
  10 * log10(1/MSE(pred,true))
}
 ##
  calculate_psnr <- function(pred_dir, true_dir){
  n_pred <- length(list.files(pred_dir))
  n_true <- length(list.files(true_dir))
  
  ###Check for length
  if(n_pred != n_true){
    stop("Input and output must have same length")
  }
  
  list <- matrix(0, nrow = (n_pred + 1), ncol = 1)
  name <- c("Total")
  
  ###Read Images
  for (i in 1:n_pred){
    imgPred <- readImage(paste0(pred_dir,  "img_", sprintf("%04d", i), ".jpg")) 
    imgTrue <- readImage(paste0(true_dir,  "img_", sprintf("%04d", i), ".jpg"))  
  
  ###Calculate PSNR
    list[i+1,] <- psnr(imgPred, imgTrue)
    name <- c(name, paste0("img_", sprintf("%04d", i)))
  }
  
  list[1,] <- mean(list[-1,1])
  row.names(list) <- name
  colnames(list) <- substring(pred_dir,18)
  
  ###Output
  return(list)
}