salaries=read.table('SalariesData.csv',header=T,sep=';', dec='.')

names(salaries)
salaire <- salaries$Salaire
median(salaire)
mean(salaire)
boxplot(salaire)
quantile(salaire)

