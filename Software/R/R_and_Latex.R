rm(list=ls()) # This cleans the environment, datasets loaded, etc.
# setwd("c:/docs/mydir") # This here sets the working directory on WINDOWS
# setwd("/usr/rob/mydir") # This here sets the working directory on LINUX/MACS
install.packages("sandwich") # First, you install the basic packages
install.packages("car") # Package to run OLS
install.packages("lattice") # Package to plot
install.packages("stargazer") # This package allows you to produce tables in LaTex format
install.packages("MASS") # This here is for the MCSM

# Then, you just load the packages you just installed
library(lattice) # Then, you just load the packages you just installed
library(sandwich)
library(car)
library(stargazer)
library(MASS)

# In this exercise, you will create your first data set using a technique 
# called Monte Carlo Simulation Methods (MCSM). Methodologists use it to generate pure, with-no-error
# data so as to test the methods they create. Cool, right? 

# Well, why don't they just use, for example, ANES data or
# some data set from the ICPSR library? Well, because as you might think, that data, even though is 
# good-quality data, it has measurement error. Moreover, *observational data* is always a 
# (representative) sample from a population. In consequence, if you want to test the efficiency, say,
# for your new method, millimetric precision is required. So these guys use MCSM, and create,
# a data set where the TRUE mean is fully known. That's a privilege you never get to have 
# using real data. This is why we use fake data here. As we will do it here, I will tell
# R to generate a TRULY random variable with a truly NORMAL distribution and very importantly,
# with a truly and fully KNOWN mean and variance. You'll see.

# Why bother? I believe it's important you know how to generate this data because 
# it puts you in control of what happens behind a regression
# (just like when you did your first regression by hand, estimating those betas).


# Lets get started.

# Lets "set the seed". All these procedures here work with algorithms (computational loops)
# that generate *random* data following the distribution you want. Here, we will work with NORMAL
# distributions. However, as you should know, science should be REPLICABLE.
# For ex., what happens if I want to re-check (replicate) your MCSM? 
# Because of the random-ness of these algorithms, I will get a different combination of numbers
# in my fake variables. It will still have the same mean, but yet not the SAME array of numbers. 
# So for that reason, we tell the algorithm to generate random numbers, but using the same pattern
# of random number generation. I will use "89", because of Hickman 89 George St.

# OK. The entire process starts creating the error term. "Mu" is the Greek for "mean". As you
# should know, the error term has mean 0, right? Well, it also has a sigma of 1. 
# Remember, sigma squared is the variance of a variable. Our data has a N of 500.

#Lets call the error term "e", which is the Greek for epsilon.
set.seed(89)
e <-  as.numeric(mvrnorm(n = 500, mu = 0, Sigma = 1))
# Lets check if this thing has mean of zero.
summary(e)
# "0.012340". Yes, very close. Given the decimals of each observations we have just created,
# we have some some perturbation, which is fine.

#lets now make a plot.
histogram(e)
# Looks normal to you, right?

# now, lets store this plot in an R-element called "e.plot". You may name it as you wish.
e.plot <- histogram(e)
# and now, call it to actually see this element
e.plot

# Lets now create two independent variables. x1 will have a mean of 6, and x2 will have a mean
# of 5. Both with have a sigma of 5.
set.seed(891) 
x1 <-  as.numeric(mvrnorm(n = 500, mu = 6, Sigma = 5))
set.seed(892)
x2 <-  as.numeric(mvrnorm(n = 500, mu = 8, Sigma = 5))
# Note that I perturbed the seed, because otherwise both variables are product of the 
# same seed (say 89), and that creates two variables that a are perfect combination of eachother.

summary(x1) # Make a summary table
summary(x2) # Make a summary table

# and two plots
histogram(x1)
histogram(x2)

# Lets now create a binary variable. Binary variables are the type of "yes/no", or "woman/man", etc.
# Usually, they take two values, either 1 or 0. It could be for example, "did you vote last 
# election? Yes or not?". OK, this one is a little more complicated as it requires something from
# MLE, and the inverted logit function. You will see this in more advanced courses. 
# However, in substance, it generates a bunch of random 1's and 0's, and the entire process
# below, it is just to create this constrained numbers (i.e. not a 1.01, or a -0.5)


# Our binary variable is going to be called "x3".
set.seed(89)
pr = as.numeric(1/(1+exp(-0.5)))
x3 = as.numeric(rbinom(500,1,pr))
#

# Again, you ALWAYS have to plot the data
histogram(x3) # As you see, only two values, 0s and 1s
# you can see the actual numbers by calling the ELEMENT "x3" 
x3


# Remember this: it's always good to plot the data and see how it looks like.
# Lets imagine x3 is male=1, and female=0. Lets see how x1 and x2 behave by "male" (x3).
# This below represent "density plots". They represent the distribution of x1 and x2.
# As you see, the little dots are the actual data points which are located in different points
# of the X-axis. If we had a larger sigma, probably, this data would be more spread out. 
densityplot(x1, aspect = 1:1, ref = TRUE, groups = x3)
densityplot(x2, aspect = 1:1, ref = TRUE, groups = x3)

# As we have seen, we only have one dependent variable (y) and many independent variables.
# We have seen that y is a "function of" of these independent variables, plus an error term.
# That means that y varies as our X's vary. We also know that our betas are constant, that is,
# they are numbers that DO NOT VARY and that are multiplied by each row of data. Imagine that
# each row might be a person, and each column represent his or her answers to a survey. A row
# might be countries, and each column might be economic and democratic indicators, for example.

# The regression equation for the first row follows this structure, using our three-variable 
# example of regression:
# y(row1) = beta(1)*x1(row1) + beta(2)*x2(row1) + beta(3)*x3(row1) + error(row1)
# For example, imagine the next values

# This here is actual data, NOT ESTIMATIONS, lets say, for the "first country" (i.e. row 1)
# y=10 (level of economy is 10, for ex.)
# x1=2 (level of democracy is 2, for ex.)
# x2=3 (level of corruption is 3, for ex.)
# x3=1 (remember this is binary. Lets say that 1 means "presidential system", 0 for parliamentary)

# Now what the betas and the error term do is to APPROXIMATE the real data in the Y. 
# Following the equation above, we would have that
# 10 = beta1*(2) + beta2*(3) + beta3*(1)
# notice that I used the values above. 10 for the y, 2 for x1, etc.

# Consider that the error term is the difference between the "fitted data" 
# (our estimated betas and the error term / residual) and the "actual data" (i.e. "y"). 
# Lets imagine that we know those betas
# and the values are: beta1=5, beta2=6 and beta3=7. 

# Now, if we update our little regression equation for the first country (i.e. row 1)
# we would have the following
# 10 = 5*2 + 6*3 + 7*1
# This equation above is multiplying the actual data by our fake betas. 
# Given the definition of the error term (difference between fitted values and observed values)
# the error term is what help us to "force" the equation to have a value of 10. 
# Lets see. 5*2=10, 6*3=21, 7*1=1. If we sum everything, is 10 + 21 + 1 = 32. In consequence,
# the error term (difference between observed and fitted) is the following: 10 - 32 = -22.

# This is how regression analysis works. And it does the same thing for all rows, or countries
# in our example, i.e. multiplies the betas (which are the same for all the observations) 
# to each row (which in our example represent countries).

# What regression analysis does is to find, considering the actual data, the betas that 
# minimize the distance between the fitted data and the observed data, that is
# that minimizes the "mean error". In this case, the first country (i.e. row1) 
# has quite a large error, -22, right? However, as you will learn, we care about the 
# complete dataset, not only about the first row. Regression analysis requieres to 
# have an error which average is zero. So if you take that large error term (-22), 
# it will cancel out with other larger and positive errors terms for other countries (rows). 
# Even better, we expect that that average error term has zero mean. We know 
# that the error term is zero, because we construct it. Take a look:
summary(e)


# Ok, we have been working backwards. We first created the error term. Then 3 independent 
# variables. Now, lets create the dependent variable (y), which is going to be a function
# of the data we created (x1, x2 and x3, plus the error term). Notice that I set the betas
# following the example above beta1=5, beta2=6, beta3=7. 

y <- as.numeric(5*x1 + 6*x2 + 7*x3 + e)

data <- data.frame(y, x1, x2, x3) # This is to merge all these vectors in one matrix.
# We call this matrix "data".

# As always, make sure to take a good look at the data **before** do any regression.
# We have run some plots. Lets describe the data in more detail. 
summary(data)
# Think for a moment about this. See the min and the max. The median and the mean. 

# Now, suppose that you just want to take a look at one variable. 
# The way you do that is the following: summary(data$variable).
# As the data in this exercise is called "data", do the following:
summary(data$x2)
# It is the same thing, but you see the information for x2 only.

# Now, in many quantitative methods courses you are told to "describe the data".
# As grad students, we have little or no time. So you don't want to copy and paste each
# number, one by one, right? Well, as you already know some LaTex, there are more
# convenient ways to integrate R and LaTex. The next exercise will teach you how to
# produce LaTex tables in R. 

# Run the next library
library(stargazer) # which allows you to produce fancy descriptives tables in LaTex form.
stargazer(data, summary=T, title = "Descriptive Stats")
# Now, you have descriptive tables in seconds. You copy and paste the code below!


# OK, we have described the data and made several plots, now lets run the regression.
lm(y ~ x1 + x2 + x3, data = data)
# "lm" stands for "linear model", which in other words means "linear regression", or "OLS".

# As you see our estimations worked. Cool, right? You see that the betas are 
# exactly as we created them.

# Now, many people, even **very advanced gradute students** ask whether they should introduce
# the IV's in order or not. As you know, does it matter if you sum beta2*x2 + beta3*x3 
# or sum beta3*x3 + beta2*x2?

# Right. It does not matter. Sums are commutativity. 
# However, by tradition, we include in our regression tables 
# first the variable we care the most. However, the mathematics behind do not vary. 

# OK, we have run our first regression, and learned how to make plot. However, 
# part of our job is to communicate results effectively. Now, we will learn a set of 
# skills that will help you to make tables very quickly.

# Now, what I will do is to run four different regressions. Say we are mainly interested in the 
# effect of x1, that variable is our main theoretical contribution. That's why x2 and x3 are
# called "control variables" (because we care mainly about x1). 

# We usually show in our papers that the estimations of our key variable (beta1) is not the result 
# of any statistical trick, that is, kitchen-sink regressions. As you have seen, the fitted y
# is the combination of the sum of several data points multiplied by the betas. In consequence,
# beta1 will vary if you do not include x2 and x3. However, we want to show to our readers
# whether our results are **fragile** or not. Do our results vary TOO MUCH depending on 
# which control variable we include? IF the answer is yes, well, our results are very fragile.
# We make our research stronger if our key independent variable stays "robust", that is,
# they behave relatively similar REGARDLESS of our control variables. 

# For this reason we run several models, some more conservatives
# than others, that is, with less control variables.

# Lets run the "main model", controlling for everything. 
model1 <- lm(y ~ x1 + x2 + x3, data = data) # run this model, and call this element "model1"

# Now lets run the alternative models. We want to show the extent in which our model is 
# "fragile"/"robust" or not.
model2 <- lm(y ~ x1, data = data) # x1 alone, this is the best way to test the robust-ness of your model.
model3 <- lm(y ~ x1 + x2 , data = data) # x1 and x2
model4 <- lm(y ~ x1 + x3 , data = data) # x1 and x3

# Notice that we always include x1, as that's is our key independent variable.
# We only play around with the control variables.


# This is one of data analyst's best friends: an automatically generator of tables.
# We don't want to be copying and pasting into our LaTex document
# as that increases the likelihood of error.
# Also, it ain't cool :) 

# Take a look what the package "stargazer" does: it shows several statistical tests, it generates
# tables according to the APSR journal (so we can imagine getting ourselves published there!)

# Lets put all these models into the stargazer package and make a "text" table first. 
stargazer(model1,
          model2,
          model3,
          model4,
          type = "text",
          covariate.labels=c("x1", "x2","x3"),
          dep.var.labels=c("Dependent Variable: y"), 
          column.labels=c("Model 1", "Model 2", "Model 3", "Model 4"),
          colnames = TRUE, # if you say FALSE, it won't give you the 
          omit.stat=c("f", "ser", "adj.rsq"),
          title = "Estimation Results (OLS)",
          style = "apsr")

# One substantive comment might be: "My model is very robust because it does not vary that
# much if you add or remove other IV's". This is why we show different parametrization
# of our models.

# Now that you know how to use LaTEX, one of the advantages of this package is that
# it allows you to produce the same numbers, but in LaTex format. The ONLY difference is that
# you tell stargazer that the type is "latex" instead of "text". Lets try that.

stargazer(model1,
          model2,
          model3,
          model4,
          type = "latex", 
          covariate.labels=c("x1", "x2","x3"),
          dep.var.labels=c("Dependent Variable: y"), 
          column.labels=c("Model 1", "Model 2", "Model 3", "Model 4"),
          colnames = TRUE, # if you say FALSE, it won't give you the 
          omit.stat=c("f", "ser", "adj.rsq"),
          title = "Estimation Results (OLS)",
          style = "apsr")

# You see? Now you can simply copy and paste this output every time you need to, 
# instead of you doing the tedious job of copying, pasting and rounding numbers every single time


# Now go to STATA and lets do the same thing.