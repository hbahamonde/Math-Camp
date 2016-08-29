* Welcome to STATA

* INTRODUCTION

* This is a "DO file". Basically, it allows you to write everything you want to execute. 
* It is VERY recommendable that you write and run your commands from here. In that way
* you keep stored in this DO file a log of everything. For example, say you make a mistake, like 
* you deleted a variable, and then you needed it back. Well, if you use a DO file you can easily go back and run 
* everything again. If you do it from the command line, you won't be able to do so. 

* Look at the top-right of this window. Just like in LaTex, you have a "DO" button. That's the thing that allows you
* to run everything. 


* MANIPULATIONS

* We won't create our data set here, just do some basic manipulations. STATA is a little more easy to learn,
* but it is a little more restricted. I don't know a way to create random data here. 
* STATA has (almost) everything pre-loaded. As you will notice, for example,
* you DO NOT need to load a package to run regressions. It is already loaded it for you. In R, however, everything is 
* created by other users. For that reason, you can find almost everything you need, as there is a ton of people out there who (for own
* benefit!) spend a lot of time creating packages. In the STATA framework, people can also write packages, but it is less common.

* OK, lets get started. Open manually the data set (double click on it).



* Lets start by describing the data. That should be very clear by now: before do any regression, spend A LOT of time just
* taking a VERY GOOD look at your data. 

* Lets make a table to describe the data
* Highlight the code below and press the DO button at your top-right
sum y x1 x2 x3
* Now, if you want to know more "details" about your data, just run the following
sum y x1 x2 x3, detail


* Here, we don't have the R "stargazer" package. However, we have another alternative.
* "sutex" is a package that allows you to produce summary stats in LaTex format.
* first, find it
findit sutex
* then click on the sutex package to install it

* OK, lets run this package
sutex y x1 x2 x3
* This is the basic form, lets do a more useful table
sutex y x1 x2 x3, minmax title("Summary Statistics") 
* OK, this looks better for a paper.

* OK, lets continue describing the data. Lets make some plots.
histogram y
* Nice!

* Lets do another one
histogram x3
* OK!

* However, many times histograms alone are not optimal for continuous variables. Perhaps, we are more interested in 
* the "density", or the area under the curve, considering the distribution of our data (remember integrals!) 
histogram x2, normal
* This is a histogram of x2, but also, I added the density function of a **theoretical** normal distribution.
* In easy words it means a comparison between the **empirical distribution** of x2, and a "theoretical x2" that is PERFECTLY normal. 
* As you see there is no 100% overlap. That is because histograms are constructed using integrals. Each bar or bin is an integral.
* Essentially, more bins, more close to the empirical distribution. We have 500 observations. For example, lets see how three bins
* summarize our normal data.
twoway histogram x2, bin(3)

* You see? We know that our data is truly normal. However this plot, using 3 bins, does not show it. Right? That's because
* we are asking 3 columns to summarize 500 observations. Now, lets put one integral (or bin) per observation.

twoway histogram x2, bin(500)

* Well, this looks better, right? Always make sure to inspect this kind of things before run regressions. 


* This may be a good opportunity to talk about "continuous variables". The truth is that "truly" continuous variables DO NOT exist.
* for example, list the 10 elements of x2
list x2 in 1/10
* One of the values is 5.676988, right? Well, a TRULY continuous variable should have also  a 5.676988+1,  5.676988+2,  5.676988+3, etc.
* That is, infinitesimal numbers between 5.676988 and 5.676988+1. That kind of variables do not exist. However, we think of variables 
* with more than 5 categories, hopefully, more than 7 categories, as continuous. Even mathematically false, it is a convention. 
* For example? A 7-scale ideological scale. It would be very difficult to force people to take an ideological position
* between 5.0001 and 5.00000000000001, right? For that reason, we just think of ideological scales as round numbers.


* Good job. Now, lets start making scatter plots.
* Take a good look the structure of this commands. Everything works as "layers of instructions". 
* The basic structure is TYPE_OF_PLOT (THING1 Y-AXIS X-AXIS) (THING2 Y-AXIS X-AXIS)
twoway (scatter y x2) (lfit y x2) (lfitci y x2)
* As you see, the type of plot is a two-way, i.e. including two variables.

* Then, I told STATA to include the first "thing" in parenthesis: a scatter plot between y and x2. That is, the set of POINTS
* between these two variables. Lets now try the same thing without the first thing "scatter"
twoway (lfit y x2) (lfitci y x2)
* See? No points. We want those points because they are useful. Lets keep them. 
* The second thing ("lfit") is the "linear fit", that is the "slope" (remember from calculus?), the "rate of change on Y as we move X1". 
* It's positive, right? 

* OK, good job. Now, finally, the third "element" ("lfitci") is the "linear fit with confidence intervals".
* As you will learn in future courses, confidence intervals contain the TRUE value of our estimations. In consequence, everything 
* inside those CI is **uncertainty**: you know that the true value is inside the CI's but you DO NOT KNOW **exactly** where 
* the true value is. The only thing you have it's a range (the CI). 
* If don't want that information, just do no include "lfitci".
twoway (scatter y x2) (lfit y x2), title("Scatter plot Y-x2") subtitle("What am I doing?") ytitle("Title for Y Axis") xtitle("Title for X Axis")
* I just included some titles, labels for the axis and a subtitle.


* OK. We have described the data. Lets now run our regression.
* It's very easy.

regress y x1 x2 x3

* Nice! 

* In all quantitative courses, we are told to make tables so as to present our results. Our professors are right in asking us
* not just copying and pasting that output straight from the STATA screen. We want in consequence, present results 
* as people do in the journals we read. "SUTEX" is only for summary stats, but there are other alternatives for regression analysis.

* This is for the "outtex" command
* Same thing: find it and install it
findit outtex

* OK now run the regression
regress y x1 x2 x3
* and then say
outtex


* One drawback of this package is that it does not allow you append several columns for the alternative models we did in R.
* For this reason, we have to use a different and better package. However, some extra work is required.

* This is going to be way we do it:
* First, run the model
* Second, save those estimates
* And we repeat these two steps for each model

regress y x1 x2 x3
estimates store model1

regress y x1
estimates store model2

regress y x1 x2
estimates store model3

regress y x1 x3
estimates store model4


* Then, you need to follow this code. This is a perfect example to teach you what to do when you have tons of lines of code.
* What we do in these cases is to put /// so as to put a break in each line without breaking the functionality of the code.
* It looks complicated but it is not. Take a moment to examine the code. The first line calls the models. The second line,
* tells the program to format the cells, putting the betas ("b") labeled as "coefficients", for example. 
* The second line, tells the program to include the r-squared and other statistics. 
* Etc.

estout model1 model2 model3 model4, ///
cells("b(label(Coef.) fmt(%9.3f)) p(label(\$p\$-value))") ///
stats(r2_a N, fmt(%9.3f %9.0f) ///
labels("Adj. \$R^2\$" "No. of cases")) ///
style(tex) ///
prehead("\begin{table}\caption{@title}" "\begin{center}" "\begin{tabular}{l*{@M}{rr}}" "\hline") ///
posthead(\hline) prefoot(\hline) postfoot("\hline" "\end{tabular}" "\end{center}" "\end{table}")


* This code is going to be useful for you. You might want to keep it for your future work and customize the code as you want.
* Do not thing that we all memorize this. We keep records and all of us have very worked out templates for everything: Latex, R, Stata, etc.
* So don't feel bad if you see a giant piece of code that you will never remember. Nobody does.  


* Good job!
* Now, lets move to the "Computing workshop 2"
