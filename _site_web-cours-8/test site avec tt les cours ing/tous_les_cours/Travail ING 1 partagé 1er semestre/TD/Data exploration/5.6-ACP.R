

## TP: Analyse en Composantes Principales (ACP)

## Exercice 6: (Donn?es: EconomieEuropData.txt)

# Lire les donn?es

Economie<-read.table('EconomieEuropData.txt',header=TRUE,sep=';')


# 1) R?aliser un ACP

# Il faut centrer et r?duire les donn?es :

Economie[, 1:6] <- scale(Economie[, 1:6])


# On realise un ACP avec les 5 premieres variables, les variables 6 et 7qui represente respect
# la population et l'appartenance du pays au zone euro seront ajout? comme des vaiables 
# supplementaires, c - adire ils entrent pas dans les calculs.
  
library(FactoMineR)

ACP <- PCA(Economie, quanti.sup =  6, quali.sup = 7,scale.unit=T,ncp=5,graph=T, axes=c(1,2)) 

ACP$eig 

# Les deux premiers composantes principales contiennet 38.59+29.70=68.29% de l'inertie totale.
# Alors, pour avoir plus de 70% de  l'inertie totale il faut choisir trois axes et du coup
# travailler dans le diemnsion 3..


# 2) On peut interpreter les axes, pour la laison ou le lien entre les variables,on peut le detecter
# visuellement on utilisant le cercle de correlation, ou en calculant les correlations avec :

cor(Economie[,1:5])
ACP$var$cor

# 3) Individu : Pour ces trois pays, on peut regarder s'i es individus'ils sont bien represent?
# dans le plan(C1,C2), c-a-dire si la valeur de cos2(Dim.1) +cos2(Dim.2) est proche de 1.

ACP$ind$cos2["Luxembourg",]
ACP$ind$cos2["Grece",]
ACP$ind$cos2["Slovaquie",]

# On peut regareder aussi leur coordonn?es dans le nouveau plan (C1,C2)

ACP$ind$coord["Luxembourg",]
ACP$ind$coord["Grece",]
ACP$ind$coord["Slovaquie",]


# ET aussi on peut regarderla contribution de ces pays sur la construction des axes 

ACP$ind$contrib["Luxembourg",]
ACP$ind$contrib["Grece",]
ACP$ind$contrib["Slovaquie",]


# 4) On a 20 pays en totale, donc la contribution moyenne de chaque pays est de 1/20=0.05 ou 5%

ACP$ind$contrib

# On peut remarquer que Grece, Luxembourg et Solvaquie ont des contributions qui depassent 
# bien la contribution moyenne de 5%.. On peut conclure que ces pays pourront ?tre atypique.

# On realise un nouveau ACP mais cette fois le Luxembourg et Solvaquie seront ajout? comme
# des individus supplementaires, c-a-dire on les voit graphiquement mais ils entrent pas dans 
# les calculs.
X11()
ACP2 <- PCA(Economie, quanti.sup = c(6) , quali.sup = 7,ind.sup=c(13,17),scale.unit=T,ncp=5,graph=T,axes=c(1,2))

# Interpretation : Cela change beaucoup les r?sultats, maintenant les deux premiers axes principales
# C1 et C2 contiennent 49.47+27.53 = 77% de l'inertie totale contre 68.29% donc on a moins de 
# perte d'information. Alors, on valide notre pr?cdent conclusion que ces deux pays representent
# des valeurs aberrantes et c'etait mieux de le supprimer de l'etude.


# Remarque : et si on supprime aussi le Grece et on fera un nouveu ACP sans ce pays :

ACP3 <- PCA(Economie, quanti.sup = c(6) , quali.sup = 7,ind.sup=c(9,13,17),scale.unit=T,ncp=5,graph=T,axes=c(1,2))

# On remarque que l'inertie est de 47.31 +30.22 =77.53 % contre 77% donc pas beaucoup de gain
# au niveau des informations, alors le Grece pas aberrante, pour cela on le garde !!

