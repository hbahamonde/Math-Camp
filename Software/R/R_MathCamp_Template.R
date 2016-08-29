rm(list=ls()) # This cleans the environment, datasets loaded, etc.
# setwd("c:/docs/mydir") # This here sets the working directory on WINDOWS
# setwd("/usr/rob/mydir") # This here sets the working directory on LINUX/MACS

install.packages("sandwich") # First, you install the basic packages
install.packages("car") # Package to run OLS
install.packages("lattice") # Package to plot

# Then, you just load the packages you just installed
library(lattice)
library(sandwich)
library(car)

