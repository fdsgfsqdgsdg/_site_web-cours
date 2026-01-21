

#Jeu des donn?es WineQuality.csv

# Ici pas de row.names=1, car il y a pas des noms ds individus

wine=read.table('WineQuality.csv',header=T,sep=';', dec='.')

attributes(wine) #Donne nom variables et individus, ici le logiciel a numerot? les individus
str(wine) #Donne nombres de variables et observations.et noms variables avec type (nature)
# Ici le variable (Color) est consid?r? comme qua,ti,alors qu'il est des var qualitative
# Car int en langage R c-a-dire quanti discrete

# On va transformer Color de type quanti a quali

# commande is.factor renvoie TRUE si la variable et qualitative, et FALSE sinon

#is.factor(wine$color) #is.factor donne FALSE, c-a-dire (Color) est consid?r? comme quanti, il faut changer alors
wine$color=as.factor(wine$color) #comme ca color devientt variable qualitatives
#is.factor(wine$color) # is.factor donne TRUE, alors color a bien devenu variable qualitative
levels(wine$color)  #Donne les modlit?s actuels de variable color qui sont 0 et 1
levels(wine$color)=c('Blanc','Rouge') #On nome les modalités
levels(wine$color) # Affiche le nouvelles modalit?s
wine$color #Donne la nouvelle variable Color avec les nouveaux modalit?s
table(wine$color) # l'effectif de chaque modalit?


#####################################################################################

# Si on interesse ? faire les resum?s numeriques d'une seule variable

mean(wine$density)
median(wine$density)
sd(wine$density)
min(wine$density)


# Pour calculer les resum?s numeriques pour toutes les variables ? la fois


summary(wine) # Donne tous les resum?s num?riques

# Histogramme et Boxplot pour les variables Quantitatives

layout(matrix(1:2,1,2)) #On peut tracer plusiers graphes en meme temps,ici a on 2 graphes, sous formes 1 ligne et 2 colonnes
hist(wine$alcohol,main='Histogramme Alcohol',col='red');
hist(wine$density,main='Histogramme Density',col='green');

layout(matrix(1:2,1,2)) #On peut tracer plusiers graphes en meme temps,ici a on 2 graphes, sous formes 1 ligne et 2 colonnes
hist(wine$pH,main='Histogramme pH',col='blue')
hist(wine$chlorides,main='Histogramme chlorides',col='yellow')

#par(mfrow=c(1,4))
layout(matrix(1:4,2,2)) #Je le fait sous formes 1 lignes et 4 colonnes, ils vont etre l'un a cot? de l'autre
boxplot(wine$alcohol,main='Boxplot Alcohol',col='red');
boxplot(wine$density,main='Boxplot Density',col='green');
boxplot(wine$pH,main='Boxplot pH',col='blue')
boxplot(wine$chlorides,main='Boxplot chlorides',col='yellow')


layout(matrix(1:3,1,3))  
hist(wine$alcohol,main='Histogramme Alcohol',col='red');
hist(wine$density,main='Histogramme Density',col='green');
boxplot(wine$pH,main='Boxplot pH',col='blue')2

layout(matrix(1:2,1,2)) 
boxplot(wine$pH,main='Boxplot pH',col='blue')
boxplot(wine$chlorides,main='Boxplot chlorides',col='yellow')

layout(matrix(1:1,1,1))


## Diagramme en barre et diagramme circulaire pour la variable color

barplot((table(wine$color)),legend=TRUE,col=heat.colors(2) ,main='Diagramme en barre pour la variable color')
pie((table(wine$color)),legend=TRUE,col=c("red","black"),main='Diagramme circulaire pour la variable color')


#####################################################################################

subset(wine,quality>8)  # Donne les observations qui ont quality >8
QualiSup<-wine$quality>8  # On definit la nouvelle variable QualiSup, on prend juste les 
#observations c'est qui ont quality>8

QualiSup=as.factor(QualiSup) # vaiable de type qualitative
levels(QualiSup) # On va obtenir FALSE et TRUE les modalit?s actuels de la variable QualiSup
levels(QualiSup)=c("INF","SUP") # Pour definir les nouveaux modalit?s ou Levels
levels(QualiSup)
QualiSup
table(QualiSup)  # Donne table de contingence ou effectif de chaque modalit?

wine=cbind(wine,QualiSup) # pour ajouter la variable dans le tableau

# ou aussi on peut le faire avec boucle 

QualiSup2=vector(mode="character",length=6497) 

for ( i in 1:6497) { 
  if (wine$quality [i]>8)
    QualiSup2[i]='Sup'
  else 
    QualiSup2[i]='Inf'
    
  }
table(QualiSup2)

# ou aussi

QualSup3 <- ifelse(wine$quality <= 8, 'INF', 'SUP')
table(QualSup3)

wine=cbind(wine,QualiSup2)

