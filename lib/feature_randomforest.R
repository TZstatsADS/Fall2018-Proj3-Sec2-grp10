#############################################################
### Construct features and responses for training images###
#############################################################

### Authors: Qingyang Zhong
### Project 3

### Construct process features for training images (LR/HR pairs)

### Input: a path for low-resolution images + a path for high-resolution images 
###        + number of points sampled from each LR image
### Output: an .RData file contains processed features and responses for the images

feature_randomforest <- function(LR_dir, HR_dir, n_points=300){
  
  ### load libraries
  library("EBImage")
  n_files <-50
  
  ### store feature and responses
  featMat <- array(NA, c(n_files * n_points, 8, 3))
  labMat <- array(NA, c(n_files * n_points, 4, 3))
  
  ### read LR/HR image pairs
  
  for(i in 1:n_files){
    imgLR <- readImage(paste0(LR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    imgHR <- readImage(paste0(HR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    ### step 1. sample n_points from imgLR
    # t1 <- Sys.time()
    index.x <- sample(1:dim(imgLR)[2],n_points,replace = TRUE)
    index.y <- sample(1:dim(imgLR)[1],n_points,replace = TRUE)
    #t2 <- Sys.time()
    # print(paste("sample",t2-t1))
    ### step 2. for each sampled point in imgLR,
    
    ### step 2.1. save (the neighbor 8 pixels - central pixel) in featMat
    ###           tips: padding zeros for boundary points
    #pad zero
    b = array(0, dim=c(1,dim(imgLR)[2],3))
    c = array(0, dim=c((dim(imgLR)[1]+2),1,3))
    bimg = abind(b,imgLR,along=1)
    bimgb = abind(bimg,b,along=1)
    cbimgb = abind(c,bimgb,along=2)
    cbimgbc = abind(cbimgb,c,along=2)
    #t3 <- Sys.time()   
    #print(paste("pad",t3-t2))
    mat <- matrix(1:n_points, ncol = 1)
    func1 <- function(j){
      cbimgbc[(index.y[j]):(index.y[j]+2),(index.x[j]):(index.x[j]+2),]
    }
    points1 <- apply(mat,1,func1)
    #t4 <- Sys.time()
    #print(paste("9points",t4-t3))
    # neighbor 8 pixels - central pixel
    
    func2 <- function(k){
      allnei = points1[-c(5,14,23),k]
      allcen = points1[c(5,14,23),k]
      featmat = allnei - rep(allcen,c(8,8,8))
    }
    featmat <- apply(mat,1, func2)
    #t5 <- Sys.time()
    #print(paste("vectorize",t5-t4))
    ### step 2.2. save the corresponding 4 sub-pixels of imgHR in labMat
    imgHR <- imgHR@.Data
    func3 <- function(m){
      imgHR[(2*index.y[m]-1):(2*index.y[m]),(2*index.x[m]-1):(2*index.x[m]),]
    }
    points.hr <- apply(mat,1,func3)
    func4 <- function(k){
      newnei = points.hr[,k]
      allcen = points1[c(5,14,23),k]
      points.hr = newnei - rep(allcen,c(4,4,4))
    }
    points.hr <- apply(mat,1, func4)
    #t6 <- Sys.time()  
    #print(paste("hrpoints",t6-t5))
    ### step 3. repeat above for three channels
    
    featMat[(1+(i-1)*n_points):(n_points*i),,] <- array(t(featmat),dim=c(n_points,8,3))
    labMat[(1+(i-1)*n_points):(n_points*i),,] <-  array(t(points.hr),dim=c(n_points,4,3))
    
    #t7 <- Sys.time()
    #print(paste("toarray",t7-t6))
  }
  
  return(list(feature = featMat, label = labMat))
}
