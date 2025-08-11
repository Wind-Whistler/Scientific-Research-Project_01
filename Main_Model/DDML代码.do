//设置全局变量
global Y TE 
global D post 
global X 人均受教育年限 城镇化率 人均社会消费品零售总额 
gen fid=_n>195

//初始化ddml模型
ddml init partial, foldvar(fid)

//添加监督机器学习以估计条件期望
ddml E[Y|X], gen(regy): reg $Y $X
ddml E[D|X], gen(regd): reg $D $X

//执行交叉拟合步骤
ddml crossfit

//输出结果
ddml estimate, vce(hc2)