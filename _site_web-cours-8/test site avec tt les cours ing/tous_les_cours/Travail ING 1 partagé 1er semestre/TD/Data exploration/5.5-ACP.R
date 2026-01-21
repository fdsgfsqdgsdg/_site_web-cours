
## TP: Analyse en Composantes Principales (ACP)

## Exercice 5: (Donn?es: DecathlonData.txt)



Decathlon <- read.table('DecathlonData.txt', header = T, dec = ',')


# On commence ? centrer et r?duire les donn?es

Decathlon[, 1:10] <- scale(Decathlon[, 1:10])

#On r?alise un ACP

library(FactoMineR)

ACP <- PCA(Decathlon[,1:10], ncp =4, graph = T, axes = c(1,2))

ACP$var$cos2
#Q1 : Inertie : Il faut regarder les valeurs propres

ACP$eig #Donne valeurs propres


# les deux premieres composantes contiennent 50.09% de l'inertie totale. Si on regarde les
# r?sultats des valeurs propres, on voit qu'il faut 4 composantes principales pour atteindre
# plus de 70% de l'inertie totale.



#Q2 (Etude des variables)
# a)
ACP$var$cor #Ces 4 variables ont corr?l?s n?gativement avec l'axe C1,alors forme avec C1 un angle
#obtu ou angle superieur ? 90. D'autre part, elles sont cor?l?s positivement avec l'axe C2.

# b)
#On a un grand angle ( >90?) entre les deux variables,alors cosinus entre ces deux angles est
# negatif, alors les deux variables sont correles de sens inverse
# c-a-dire un athlet qui ralise un temps faible au 100m peut aussi sauter loin..

#c)
# On distingue 2 groupes.La 1er constitue par les variables: X100, X400, X110m,
# qui repr?sente des performances de vitesse. La 2e constitue par des variables:
# Discus, Shot.put, high.jump qui repr?sente des performances de force.

#Ces deux groupes sont non corr?l?s,(angle droit entre les deux groupes,donc correlation est 0)
#ce qui signifie que la force et la vitesse sont pas li?es.


#d
round(ACP$var$contrib,3)
# Les variables qui contribuent significativement ? la premi?re composante sont: 
# 100m (18 %), LongJump (16.8%) ... Discus (9%)

# Les variables qui contribuent significativement ? la deuxi?me composante sont: 
#Shotput, quatrecentm,Discus,mille500m

# Rq: Les variables Javeline, Pole.vault, X1500m ou High.jump contribuent
# tr?s peu aux deux premi?res composantes mais contribuent aux composantes suivantes
.
# Le premier axe semble plut?t repr?senter des preuves de vitesse alors que le deuxi?me est
#identifi? (moins clairement) ? des ?preuves de force. 

# On peut tracer un cartographie pour interpreter le graphe des individu, pour la correction, 
# regarder le document 'Correc-TP-EX5-2.d' d?pos? sur Teams.

#Q3 (Etude des individus)

#a
# D'apr?s le graphique, Lorenzo semble ?tre un athl?te lent et faible.
#Pour qu'il ne soit pas dernier,il gagne donc ces points sur les autres ?preuves qui ne
# sont pas repr?sent?es par les deux composantes principales C1 et C2.


cbind(rownames(Decathlon),Decathlon[,11]) #donne combinaison variable athlete et variable 11 qui donne
#le rang du l'athlete, Ici Lorenzo de rang 24 parmi 28 athletes qui ont participer au competition
#OlympicG, donc il est pas le dernier


#b
# Casarsa est un athl?te puissant mais lent., Karpov et Sebrle sont rapides et puissant. 
#Karpov et Serble terminent premiers de leur comp'etition et Casarsa termine dernier.

#c : On refait un nouveau ACP avec les deux autres variables 11 et 12
ACP1 <- PCA(Decathlon[,1:12], quanti.sup = c(11,12), ncp=10, graph=T) 
#quanti.sup pour avoir les 2 nouvelles variables quantitatives 11 et 12 en autre couleurs

# Rank et Points sont bien ?videment deux variables fortement corr?l?es.
#Elle sont n?gativement corr?l?es car plus  on a de points et plus le rang est petit.

# Les variables les plus li?es au nombre de points sont donc celles de la 
# premi?res composante car cette variable est presque confondu avec axe 1.


#d
ACP2 <- PCA(Decathlon, quali.sup = c(13), ncp=10, graph=T)

#Ici on a ajout? la variable qualitative competition (colonne 13), il n'apparait que sur
#le graphe des individus.

#Ces variables sommes consid?r?s comme des individs, le premier point Olympic a commme coordonn?s
#les moyennes des coordonn?es de tous les atheltes qui ont fait cette competition.
#et le deuxieme point Decastar qui a pour coordonn?es la moyenne de tous les athelet
#de competition Decastar

#Les deux points sont tres proches, donc ils ont des caacteristiques proches. Alors, le niveau
#est presque le m?me dans les deux competition.
