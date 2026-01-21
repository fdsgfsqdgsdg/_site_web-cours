

## Exercice 2 (jeux de donn?es simul?es)

# Partie 1 : Algorithme des K-means
#Q1.a

# On commence avec deux classes : k=2

Distinct <- read.table("Test_Clusters_Distincts.txt")
Distinct <- scale(Distinct)
k2 <- kmeans(Distinct, centers=2)
plot(Distinct, col=k2$cluster)

print(k2)

ACP <- PCA(Distinct,ncp=4, graph=T, axes=c(1,2)) 


#Explication de deux lignes du sortie R :
#Within cluster sum of squares by cluster:
# [1]  378.2372 2319.6631
#(between_SS / total_SS =  70.0 %)
#La somme de deux valeurs 378.2372 +2319.6631 donne la variance(l'inertie) 
# intra-classe.

# 70% est le pourcantage d'inertie expliqué par les classes.

intra2 <- k2$tot.withinss # variance intra pour k=2
intra2
inter2 <- k2$betweenss # variance inter
inter2
total2 <- k2$totss # variance totale
total2
rapport2 <- inter2/total2
rapport2

# R?=0.7, alors 70% d'inertie du nuage est expliqu? par les classes.
# on fait de meme avec k=3 classes

#k=3

k3 <- kmeans(Distinct, 3)
print(k3)
plot(Distinct, col=k3$cluster)
intra3 <- k3$tot.withinss # variance intra
inter3 <- k3$betweenss # variance inter
total3 <- k3$totss # variance totale
rapport3 <- inter3/total3
rapport3

# R?=0.929, alors 92.9% d'inertie du nuage est expliqu? par les classes.


# Puis avec 4 classes, k=4

k4 <- kmeans(Distinct, 4)
print(k4)
plot(Distinct, col=k4$cluster)
intra4 <- k4$tot.withinss # variance intra
intra4
inter4 <- k4$betweenss # variance inter
inter4
total4 <- k4$totss # variance totale
total4 
rapport4 <- inter4/total4
rapport4

# R?=0.935 alors 93.5% d'inertie du nuage est expliqu? par les classes.

# conclusion: pour k=4 l'inertie etait legerement superieur ? celle de k=3, mais on choisit 
# k=3, car notre but est de trouver la valeur de R? la plus ?l?v?e avec un minimum de classes.

##########################################################

#Q1.b

## Disntinct
Res.Distinct <- kmeans(Distinct, 3)
plot(Distinct, col=Res.Distinct$cluster)
intra3 <- Res.Distinct$tot.withinss # variance intra
inter3 <- Res.Distinct$betweenss # variance .inter
total3 <- Res.Distinct$totss # variance totale
rapport3 <- inter3/total3
rapport3

#R?=0.929.

## Melanges
Melanges <- read.table("Test_Clusters_Melanges.txt")
Melanges <- scale(Melanges)
Res.Melanges <- kmeans(Melanges, 3)
plot(Melanges, col=Res.Melanges$cluster)
intra <- Res.Melanges$tot.withinss # variance intra
inter <- Res.Melanges$betweenss # variance inter
total <- Res.Melanges$totss # variance totale
rapport <- inter/total
rapport
ACP <- PCA(Melanges,ncp=4, graph=T, axes=c(1,2)) 
#R?=0.484.

## Random
Random <- read.table("Test_Clusters_Random.txt")
Random <- scale(Random)
Res.Random <- kmeans(Random, 3)
print(Res.Random)
plot(Random, col=Res.Random$cluster)
intra <- Res.Random$tot.withinss # variance intra
inter <- Res.Random$betweenss # variance inter
total <- Res.Random$totss # variance totale
rapport <- inter/total
rapport
ACP <- PCA(Random,ncp=4, graph=T, axes=c(1,2)) 
#R?=0.2.

# Plus les classes sont distincts, plus l'inertie inter-classes (l'inertie entre les classes eux m?me)
#est grand et donc le rapport calcul? qui d?signe le pourcantage d'inertie du nuage expliqu?es
#par les classes est ?lev?.
#########################################################

# Q1.c : Corr
Corr <- read.table("Test_Clusters_Corr.txt")
Corr <- scale(Corr)
Res.Corr <- kmeans(Corr, 2)
plot(Corr, col=Res.Corr$cluster)
intra <- Res.Corr$tot.withinss # variance intra
inter <- Res.Corr$betweenss # variance inter
total <- Res.Corr$totss # variance totale
rapport <- inter/total
rapport

ACP <- PCA(Corr,ncp=4, graph=T, axes=c(1,2)) 
# Les donn?es sont corr?l?s. Il faudrait utiliser peut ?tre un autre type de distance.
#On note que la fct kmeans de R utilise par d?faut le distance ?cludien et ne permet pas 
#de changer la distance. Peut etre il sera mieux d'utiliser une autre m?thode (CAH).


##########################################################

#Q1.d Ici on utilise la m?thode kmeans et on choisit nous m?me les points de d?part

Atypiques <- read.table("Test_Clusters_Atypiques.txt")
Atypiques <- scale(Atypiques)


#On definit la matrice 'Centre' dont ces lignes representent les individus 1 et 1499.

centre <- matrix(NA, 2, ncol(Atypiques)) # on peut mettre 0 ou NA, c-a-d matrice ? remplir apr?s

# On remplit Cette matrice 

centre[1,] <- Atypiques[1,] #premier ligne de matrice (centre) sera obsevation 1
centre[2,] <- Atypiques[1499,]  #deuxi?me ligne de matrice (centre) sera obsevation 1499

# On applique le Kmeans m?thod

Res.Atyp <- kmeans(Atypiques,centre)
plot(Atypiques, col=Res.Atyp$cluster)

# conclusion: Les observations forment un seul classe. On consid?re qu'il y a des observations
# atypiques.

#######################################################################################

#Partie 2 (Classification ascendante hi?rarchique)
#Q2.a

## Distincts data
Distincts <- read.table("Test_Clusters_Distincts.txt")
Distincts <- scale(Distincts)
d <- dist(Distincts, "euclidean")
h <- hclust(d, "ward.D2")
par(mfrow=c(1,1))  # On peut faire deux graphes
plot(h)  # Dendogramme
rect.hclust(h, 2) # je determine je veux combien des classes
c <- cutree(h, 3) # Determine chaque observation est dans quel classe.
c
c[150] # Donne le classe de l'observation 150.
plot(Distincts, col=c, main='Distincts data')



## Melanges data
Melanges <- read.table("Test_Clusters_Melanges.txt", header=F)
Melanges <- scale(Melanges)
d <- dist(Melanges, "euclidean")
h <- hclust(d, "ward.D2")
par(mfrow=c(1,2))
plot(h)
rect.hclust(h, 3)
c <- cutree(h, 3)
plot(Melanges, col=c, main='Melanges data')

# Supplementaire : Code pour compter combien y a t-il des observations dans chaque classes

C1=0;
C2=0;
C3=0;
for (i in 1:1500){
  if (c[i]==1){C1=C1+1}
  if (c[i]==2){C2=C2+1}
  if (c[i]==3){C3=C3+1}
  
}

## Random data
Random<- read.table("Test_Clusters_Random.txt", header=F)
Random <- scale(Random)
d <- dist(Random, "euclidean")
h <- hclust(d, "ward.D2")
par(mfrow=c(1,1))
plot(h)
rect.hclust(h, 2)
c <- cutree(h, 2)
plot(Random, col=c, main='Random data')


# Conclusion: on constate qu'e le dendrogramme indique'il y a clairement trois
# classes pour 'Test_Clusters_Distincts.txt'. Pas de cluster pour 
# 'Test_Clusters_Random.txt'.


#Q2.b (Atypique data)
## Atypiques data with "ward.D2"

Atypiques <- read.table("Test_Clusters_Atypiques.txt", header=F)
Atypiques <- scale(Atypiques)
d <- dist(Atypiques, "euclidean")
h <- hclust(d, "ward.D2")
par(mfrow=c(1,2)) # On peut faire deux graphes
plot(h)
rect.hclust(h, 3)
c <- cutree(h, 3)
plot(Atypiques, col=c, main='Random data')


#Q1.c

# conclusion: les r?sultats sont identiques pour les clusters distincts
# et ensuite de moins en moins semblables pour les autres clusters.

##########################################################################
