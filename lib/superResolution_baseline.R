########################
### Super-resolution ###
########################

### Author: Chengliang Tang
### Project 3

superResolution <- function(LR_dir, HR_dir, modelList){
  
  ### Construct high-resolution images from low-resolution images with trained predictor
  
  ### Input: a path for low-resolution images + a path for high-resolution images 
  ###        + a list for predictors
  
  ### load libraries
  library("EBImage")
  n_files <- length(list.files(LR_dir))
  
  ### read LR/HR image pairs
  for(i in 1:n_files){
    imgLR <- readImage(paste0(LR_dir,  "img", "_", sprintf("%04d", i), ".jpg"))
    pathHR <- paste0(HR_dir,  "img", "_", sprintf("%04d", i), ".jpg")
    featMat <- array(NA, c(dim(imgLR)[1] * dim(imgLR)[2], 8, 3))
    
    ### step 1. for each pixel and each channel in imgLR:
    ###           save (the neighbor 8 pixels - central pixel) in featMat
    ###           tips: padding zeros for boundary points
        b = array(0, dim=c(1,dim(imgLR)[2],3))
        c = array(0, dim=c((dim(imgLR)[1]+2),1,3))
        bimg = abind(b,imgLR,along=1)
        bimgb = abind(bimg,b,along=1)
        cbimgb = abind(c,bimgb,along=2)
        cbimgbc = abind(cbimgb,c,along=2)
    #t3 <- Sys.time()   
    #print(paste("pad",t3-t2))
        index.x <- (1:dim(imgLR)[2])
        index.y <- (1:dim(imgLR)[1])
        index.all <- expand.grid(index.y,index.x)
       
        n_points = dim(imgLR)[1] * dim(imgLR)[2]
        mat <- matrix(1:n_points,ncol = 1)
        
        func1 <- function(j){
          cbimgbc[(index.all[j,1]):(index.all[j,1]+2),(index.all[j,2]):(index.all[j,2]+2),]
        }
        points1 <- apply(mat,1,func1)
       
        
        func2 <- function(k){
        allnei = points1[-c(5,14,23),k]
        allcen = points1[c(5,14,23),k]
        featmat = allnei - rep(allcen,c(8,8,8))
        }
        featmat <- apply(mat,1, func2)
        
        
        func3 <- function(m){
        allcen = points1[c(5,14,23),m]
        allcen = rep(allcen,c(4,4,4))
        }
        
        allcen <- apply(mat,1,func3)
        allcen <- t(allcen)
        
        
     featMat <- array(t(featmat),dim=c(n_points,8,3))
     
     
    ### step 2. apply the modelList over featMat
    predMat <- test(modelList, featMat)
    predMat[,,1] <- predMat[,,1] + allcen[,1:4]
    predMat[,,2] <- predMat[,,2] + allcen[,5:8]
    predMat[,,3] <-  predMat[,,3] + allcen[,9:12]
    
    predall <- array(NA,dim=c(dim(imgLR)[1]*2,dim(imgLR)[2]*2,3))
    dim(predall)
    for (k in 1:3){
      for (j in seq(from = 1, to = dim(imgLR)[2]*2,by = 2)){
        for (i in seq(from = 1, to = dim(imgLR)[1]*2,by = 2)){
          indexmat = ceiling(i/2)+(ceiling(j/2)-1)*dim(imgLR)[1]
          predall[(i:(i+1)),(j:(j+1)),k] <-rbind(predMat[indexmat,1:2,k],predMat[indexmat,3:4,k])
          }
             
      }
    }
    length(which(is.na(predall[,,1])))
    predall1 = Image(predall, colormode=Color)
    display(predall1)
    
   
    ## following is not put into use currently
    
    ### step 3. recover high-resolution from predMat and save in HR_dir
    #save(predall, file="/Users/peiluzhang/Documents/2018-fall-study/5243/proj3/data/test_set/HR/img_0001.jpg")
    
    writeImage(predall1, file = pathHR)

  }
}