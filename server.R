library(shiny)
library(datasets)
library(fmri)
library(locfit)
library(NeatMap)

# load the data  
path<-("bold.nii") 
data = read.NIFTI(path) 

# extract voxel intensities  
voxels = extract.data(data) 

# extract mask from NIFTI file  
mask = data$mask 

# denote activity = mask, arbitrarily (used later)  
activity = mask 


shinyServer(
function(input,output,session){
  output$myPlot <- renderPlot({
    
    distType<-input$Distribution
    bandwith<- input$bandwith
    zplane<- input$zplane
    
    print(bandwith)
    print(zplane)
    # define various parameters  
    I = 64  
   
    J = 64  
    K = 33 
    L = 210 
    
    # we will be using CV to choose a bandwidth from:  
    H = c(5, 10, 15) 
    
    # randomly select 80% as training data the other 20% will be validation data  
    index = 1:210  
    per = round(210 * 0.8) 
    
    index_train = sample(index, per)  
    index_valid = index[-index_train] 
    
    # we choose bandwidth 15  
    h = bandwith 

    
    # iterate over all voxels  
    for (i in 1:I) {  
      print('processing')
      print(i)
      for (j in 1:J) {  
        for (k in 1:K) { 
          
          # if mask == TRUE  
          if (mask[i, j, k]) { 
            
            # 210 observations to train from  
            y = voxels[i, j, k, ]  
            x = (1:L) 
            
            # fit local polynomial model with specified bandwidth  
            model_poly = locfit(y[index_train] ~ lp(x[index_train], deg = 2, h = h)) 
            
            # generate predictions for all 210 time points  
            predictions = predict(model_poly, x) 
            
            # fit linear model  
            model_linear = lm(predictions ~ x) 
            
            # we measure activity as the MSE between local polynomial and linear model  
            activity[i, j, k] = mean((predictions - predict(model_linear, data.frame(x)))^2) 
          } 
        } 
      } 
    } 
    
    slice = activity [, ,zplane] 
    
    slice[slice < 10] = 0 
    slice[slice > 100] = 100 
    
    heatmap1(slice) + scale_fill_gradient(low = "black", high = "white")
  
  })
  
  

})