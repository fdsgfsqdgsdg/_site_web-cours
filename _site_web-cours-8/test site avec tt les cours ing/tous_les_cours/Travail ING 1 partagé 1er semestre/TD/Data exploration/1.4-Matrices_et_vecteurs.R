
# definir un vecteur et un matrice

#Definir vecteur (variable) qualitative

V=vector(mode="character",length=5) #Definir un vecteur V de 5 élements
V
# apres je peux remplir les valeurs

V=c("A","B","C","D","E")
V

#Definir vecteur (variable) numerique

V=vector(mode="numeric",length=5) #Definir un vecteur V de 5 élements
V

# apres je peux remplir les valeurs


M=matrix(0,nrow=2,ncol=5) #Definir un marice avec 2 lignes et 5 colonnes
M 

###############################################################################

# Remplir matrice avec les élements d'un vecteur V
V=c(1,2,3,4,5,6,7,8,9,10) 

M=matrix(V,nrow=2,ncol=5) #remplit la matrice colonne par colonne M avec les elements de V

M=matrix(V,nrow=2,ncol=5,byrow=T) #remplit la matrice ligne par ligne avec les elements de V

###############################################################################

# Quelques opérations

V1=c(1,2,3,4,5,6,7,8,9,10) 
V2=V1*2
V1+V2

M1=matrix(V1,nrow=2,ncol=5) 
M2=matrix(V2,nrow=2,ncol=5)
M1*M2 #mutliple chaque element M1[i,j] par M2[i,j]
t(M2) # transposé de la matrice
M1%*%t(M2) # %*% multplier deux matrices 


M=matrix(V1,nrow=5,ncol=2) 
diag(M)  # diagonale d'une matrice
det(M)  # déterminant d'une matrice
sum(M)  # somme les éléments d'une matrice 
exp(M) # applique la fonction exponentielle à tous les éléments de la matrice 


cbind(M1,M2)  # concaténation de matrices par les colonnes 
rbind(M1,M2)   # concaténation de matrices par les lignes 
which(V2>=8) # donne les rangs des éléments d'un vecteur vérifiant la condition logique
which.min(V2)# donne le rang du minimum 
which.max(V2)# donne le rang du maximum

##########################################################################################

# Definir un table des données : Passage d'une matrice à un dataframe

M=as.data.frame(M)
M
names(M) #Donne nom des variables
names(M)=c("X1","X2") #On nomme les variables
M 
row.names(M) #Donne les noms des individus
row.names(M)=c("Sarah","Anna","Johnney","Claire","Serena")
M # Finalement on a obtenu un jeu des données avec noms des variables et des individus 
########################################################

V1=vector(mode="numeric",length=5) 
V2=vector(mode="numeric",length=5) 

for (i in 1:5)  {   
  V1[i]=i  
  V2[i]=2*i 
} 


###########################################################


# On va creer un matrice qui genere des observations de loi uniforme tout d'abord en utilisant
#une commande avec boucle et apres sans boucle, et dans les deux cas on utilise le
# commande Sys.time pour avoir le temps qu'il prend R pour réaliser ce matrice 


# Crer la matrice avec boucle

A=matrix(0,nrow=2000,ncol=2000) # Matrice de 2000 lignes et 2000 colonnes, avec elements 0


time1<-Sys.time() # Donne à quel heure exacte boucle commence à calculer

for (i in 1:2000) {  
  for (j in 1:2000)  {  
    A[i,j]=runif(1)
  } 
}

#

time2<-Sys.time()  # Donne à quel heure exacte boucle termine les calculs

Time1=difftime(time2, time1)  # Difference entre les deux valeurs pour savoir temps obtenu par
#le boucle à faire l'opération ou le temps de création de la matrice
# ici la difference est 8.162012 secondes


# Crer même matrice mais Sans boucle 

B=matrix(0,2000,2000) 
time1<-Sys.time() 
B=runif(2000*2000) 
time2<-Sys.time() 
Time2=difftime(time2, time1) #temps de creation du matrice sans boucle

#Ici difference du temps ou le temps pris par R pour donner la matrice est 0.146071 secondes
#Donc, sans boucle c'est plus rapide


#######################################################



