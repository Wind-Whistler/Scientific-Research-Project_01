//基准回归  --面板连续数值回归
xtset id year
xtreg TE post 城镇化率 人均受教育年限 人均社会消费品零售总额 i.year,fe vce(cluster id)

//基准回归  --Tobit模型
//固定效应tobit
tobit TE post 人均社会消费品零售总额 人均受教育年限 城镇化率 i.year, ll(0)  nolog vce(cluster id)

//随机效应Tobit
xttobit TE post 城镇化率 人均受教育年限 人均社会消费品零售总额 i.year , ll (0)  nolog tobit
