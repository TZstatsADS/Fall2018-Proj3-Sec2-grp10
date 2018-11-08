# Project: Can you unscramble a blurry image? 
![image](figs/example.png)

### [Full Project Description](doc/project3_desc.md)

Term: Fall 2018

+ Team #
+ Team members
	+ Peilu Zhang(pz2233@columnia.edu)
	+ Chun Zhai(cz2466@columbia.edu）
	+ Qingyang Zhong
	+ Rui Zhang(rz2394@columbia.edu)

+ Project summary: In this project, we created a classification engine for enhance the resolution of images. We used one GBM baseline model, XGboost and Random Forest model to achieve this goal. And we also use more neighbors to extract the features to improve our baseline model. Finally we choose 8 neighbors feature extracting and XGboost model to predict the high resolution pircture from low resolution pictures.

	
**Contribution statement**: 

Peilu Zhang: " I write all the baseline code, including feature.R and superresolution.R for all the models and small changes in test.R and train.R. I shortened the feature extracting time of 1500 pictures to 3 mins, tuned the gbm parameter by cross validation. And I fixed the code of xgboost model." Rui Zhang:"I'm responsible for improving the model using XGBoost algorithm and I tuned the parameters by cross validation. I also need to compare all the possible improvement methods on theoretical level. And I summarized the performance measure indicators regarding accuracy, memory and speed."


Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
