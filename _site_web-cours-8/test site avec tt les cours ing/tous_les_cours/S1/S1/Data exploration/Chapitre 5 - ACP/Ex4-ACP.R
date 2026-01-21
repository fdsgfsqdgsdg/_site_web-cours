

## TP: Analyse en Composantes Principales (ACP)

## Exercice 4: (donn?es EspVieACPData.txt)

#Q1
install.packages("FactoMineR")


# Installer les packages, ? faire une seule fois

# Il faut que ? chaque fois qu'on va faire ACP, appeler la commande de library

library(FactoMineR)


#Q2
Dataset <- read.table('EspVieACPData.txt', header = T, sep='', dec='.')

#Ici le tableau sous forme txt.. Les separateurs est le space et pas le ;


#Q3 : Pr?paration des donn?es

#a)  Nuages de points des donn?es
pairs(Dataset[,1:6]) # Trace nuage des points pour chaque paires des 6 premiers variables quantitatives, 
#combinaison entre toutes les variables 2 ? 2.


#b) Centre et r?duire les donn?es
Dataset[, 1:6] <- scale(Dataset[, 1:6]) # centr?e et r?duire les donn?es.. On prend que les six premiers colonnes
#car le septieme colonne correspond ? une variable qualitataive.



#Q4 : Faire une ACP avec FactoMineR

library(FactoMineR)  # charger le package FactoMineR

#a) 
?PCA # Pour demander l'aide sur ACP


#b) R?aliser un ACP
ACP <- PCA(Dataset[, 1:6],ncp=6,graph=T, axes=c(1,2)) 
# commande r?alise  ACP, ncp=affiche tous les r?sultats 
#( correlations, contribution et coscarre ) pour les 6 axes principales

# ou aussi on peut ajouter dans commande PCA la commande 
# scale.unit = 1 pour normaliser données si pas deja fait.

#c) Diagramme Valeurs propre

ACP$eig   # l'attribut $eig donne un tableau avec
# les valeurs propres, le pourcentage de variance correspondant et le pourcentage cumul'e.

barplot(ACP$eig[,2], main = "pourcentage de variance par axe") #Donne diagrame des valeurs propres

# ACP$eig[,2] pour choisir le deuxieme colonne qui correspond au pourcantage des variances

#d) R?sultats sur les variables:


ACP$var$cos2 # Donne pourcantage de la representation (projection) d'une variable sur les axes principaux

#cos?(1) + cos?(2)= 1 variables tres bien represent? dans le plan (C1,C2)

# Pour la variable (TNAT),cos?(Dim1)+cos?(Dim2)=0.9713181, donc TNAT est bien represent?

#La variable TMORT est bien represent? sue l'Axe 2,car il a cos?= 0.8911353397 sur cet axe(Dim2)
#contre cos?=0.0996249 en Dim1



ACP$var$contrib #Donne la contribution de chaque variable ? la construction des axes principaux
# toutes les variables contribuent a la formation de l'axe 1 sauf TMORT.



#e) R'esultats sur les individus:

# comme pour les variables, le cos? donne le pourcentage d'un individu par axe.
round(ACP$ind$cos2,3)  #Donne cos? de tous les individus

# Pour avoir les cos? que pour le Bengladesh
subset(ACP$ind$cos2,row.names(ACP$ind$cos2)=='Bangladesh') 

#On voit donc que le Bangladesh est projet? `a 46.1% sur l'axe 2
#et 49.8% sur l'axe 3. Donc ella sera bien represent? dans les plan (C2,C3) et pas (C1,C2)


# Il y a 196 pays, donc la contribution moyenne est 1/196 i.e 0.0051.Pour savoir s'il y a 
#des individus qui d?passent beaucoup la contribution moyenne de 0.0051,on range les contri
#par ordre d?croissant

ACP$ind$contrib
sort(ACP$ind$contrib[,1], decreasing = T) # on choisit juste les contributions sur axe 1


# Certains pays ont une contribution bien plus importante que la contribution
# moyenne. Ils pourraient ?tre atypiques et entrainer des perturbations
# comme Niger, Afghanistan, Tchad...

# On va supprimer donc celui qui a la plus grande contribution 
#et on regarde si cela change la construction des axes. 
# NB: le Niger est la 127e ligne. 

#On r?alise un ACP sans l'individu 'Niger'

X11() # Pour garder l'ancien graphe et que les nouveaux graphes s'affiche dans un nouveau fenetre

#On r?alise un nouveau ACP sans l'individu 'Niger' qui represnete la 127?me observation(ligne)

ACP1 <- PCA(Dataset[,1:6], ind.sup=c(127),scale.unit=T,ncp=6,graph=T,axes=c(1,2))


# Le fait de mettre le Niger en individu suppl'ementaire, le retire des calculs lors de la 
# construction des axes, par contre il est ajout? uniquement pour la repr?sentation graphique. 

# Interpretation : Cela ne change pas grande chose aux pourcentages des deux axes.(C1) etait
# ? 22.78% avec tous les individus et pass? ? 23.04% quand on a enlev? 'Niger'.. pareil pour
# (C2) a pass? de 70.34% ? 70.10%.... Donc Niger ne represente pas un individu atypique.

#f) On ajoute le septieme variable (continent) sur l'etude, cette vaiable est qualitative,
# un ACP ne peut se faire que avec des variables quantitatives (numeriques), par contre, on 
# peut representer une variable qualitative graphiquement..

PCA(Dataset, quali.sup = 7, scale.unit = T, ncp=6, graph=T, axes=c(1,2))

# quali.sup = 7, on a ajout? la septieme variable qualitative (Continent) sur le graphe..


#############################################################################