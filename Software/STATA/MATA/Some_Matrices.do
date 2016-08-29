* Stata Mata


matrix A = (3,2,1)\(-2,-6,5)
matrix B = (3,2,1)\(-2,-6,5)
matrix C = A + B
matrix list C

matrix P = (6,7)\(8,9)
matrix Pt = P'
matrix list Pt

* outter product 
matrix A = (1,2)\(3,4)
matrix B = (5,6)\(7,8)
matrix Bt = B'
matrix ABt = A*Bt

****

use "/Users/hectorbahamonde/RU/Teaching/Winter_2015/MathCamp/Resources/MATA/MyFirstReg.dta", clear

****
matrix x = (1,6)\(1,7)\(1,8)\(1,9)\(1,7)
matrix xt = x'
matrix list x
matrix list xt

matrix xtx = xt*x
matrix list xtx
inv(xtx)





