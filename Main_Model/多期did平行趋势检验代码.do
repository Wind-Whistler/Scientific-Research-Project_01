//多期did平行趋势
gen pd=year-policy_year 
tab pd
forvalues i = 13(-1)1{
	gen pre_`i'=(pd==-`i'& T==1)
}
gen current =(pd==0&T==1)
forvalues j = 1(1)13{
	gen las_`j'=(pd==`j'& T==1)
}
replace pre_1=0

xtset id year
//Tobit 或者 Xtreg 选一个
//面板连续模型回归
xtreg TE  pre_8 pre_7 pre_6 pre_5 pre_4 pre_3 pre_2 current las_1 las_2 las_3 las_4  pre_1  城镇化率 人均受教育年限 人均社会消费品零售总额 i.year,fe vce(cluster id)

est sto reg

//多期DID加随机效应Tobit
xttobit TE  pre_8 pre_7 pre_6 pre_5 pre_4 pre_3 pre_2 current las_1 las_2 las_3 las_4  pre_1  城镇化率 人均受教育年限 人均社会消费品零售总额 i.year,ll(0)  nolog tobit

est sto reg

forvalue i=2/8{

         gen b_`i' = _b[pre_`i']

} 
 gen avg_coef = (b_2+b_3+b_4+b_5+b_6+b_7+b_8)/7
 //去均值前请运行下面两行命令
 su avg_coef
 return list
 
 //不去均值
coefplot,baselevels omitted keep(pre* current las*) vertical recast(connect) color(black) order( pre_8 pre_7 pre_6 pre_5 pre_4 pre_3 pre_2 pre_1 current las_1 las_2 las_3 las_4 ) yline(0,lp(solid) lc(black)) ytitle("政策效应") xtitle("政策时点") xlabel( 1 "-8" 2 "-7" 3 "-6" 4 "-5" 5 "-4" 6 "-3" 7 "-2"8 "-1" 9 "0" 10 "1" 11 "2" 12 "3" 13 "4" ) ciopts(recast(rcap) lc(black) lp(dash) lw(thin)) scale(1.0)
//去均值
coefplot,baselevels omitted keep(pre* current las*) vertical recast(connect) color(black) order( pre_8 pre_7 pre_6 pre_5 pre_4 pre_3 pre_2 pre_1 current las_1 las_2 las_3 las_4 ) yline(0,lp(solid) lc(black)) ytitle("政策效应") xtitle("政策时点") xlabel( 1 "-8" 2 "-7" 3 "-6" 4 "-5" 5 "-4" 6 "-3" 7 "-2"8 "-1" 9 "0" 10 "1" 11 "2" 12 "3" 13 "4") transform(*=@-r(mean)) ciopts(recast(rcap) lc(black) lp(dash) lw(thin)) scale(1.0)

//去均值并保留基期
coefplot,baselevels omitted keep(pre* current las*) vertical recast(connect) order(pre_8 pre_7 pre_6 pre_5 pre_4 pre_3 pre_2 pre_1 current las_1 las_2 las_3 las_4 ) yline(0,lp(solid) lc(black)) ytitle("政策效应") xtitle("政策时点") xlabel( 1 "-8" 2 "-7" 3 "-6" 4 "-5" 5 "-4" 6 "-3" 7 "-2"8 "-1" 9 "0" 10 "1" 11 "2" 12 "3" 13 "4") xline(9,lp(solid)) transform(pre_8=@-r(mean) pre_7=@-r(mean) pre_6=@-r(mean) pre_5*=@-r(mean) pre_4=@ current=@-r(mean) pre_3=@-r(mean) pre_2=@-r(mean)  pre_1=@ current=@-r(mean) las_1=@-r(mean) las_2=@-r(mean) las_3=@-r(mean) las_4=@-r(mean) ) ciopts(recast(rcap) lc(black) lp(dash) lw(thin)) scale(1.0)