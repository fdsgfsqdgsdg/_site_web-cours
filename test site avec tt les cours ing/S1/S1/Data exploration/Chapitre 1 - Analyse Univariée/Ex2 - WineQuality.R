Wine <- read.table("WineQuality.csv",header=TRUE, sep=';',dec='.')

attributes(Wine) #Donne nom variables et individus, ici le logiciel a numerot? les individus
names(Wine) #permet d'avoir le nom des variables
summary(Wine) #permet d'avoir un résumé numérique des variables
row.names(Wine) #permet de connaître le nom des observations

str(Wine) #donne le type des variables

DatasetWine$color=as.factor(Wine$color) # comme ça color devient variable qualitative
#On ressaye l'instruction is.factor pour tester la nature 
is.factor(Wine$color) # Donne TRUE si la variable est qualitative
levels(Wine$color)
levels(Wine$color)=c('Blanc', 'Rouge')
levels(Wine$color)
Wine$color
table(Wine$color)


pie(table(Wine$color))
barplot(table(Wine$color))
hist(Wine$color,main='Histogram of Color',xlab='Color',col='blue')
