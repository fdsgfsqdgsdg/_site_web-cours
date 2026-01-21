

####### TP2 : Analyses Bivari?es : Croisement Qunatitatif-Quantitatif ####################################


### Exercice 3 ###

Dataset=read.table("C:/Users/victo/Documents/Travail_1er_semestre/TD/Data exploration/Dataset/DepensesEduData.csv",header=T, row.names=1,sep=';',dec=',') # Attention : le virgule
#de decimale est , et pas le '.' donc il faut mettre dec=',' et pas '.'  sinon, il va me considere les deux variables
#comme qualitatives et du coup on peut pas faire des resum?s num?riques ni etude quanti*quanti

summary(Dataset)  # Donne resum? num?rique de chacune de deux variables.
boxplot(Dataset$nbEleves,Dataset$Depenses) # Ici on peut remarquer qu'il y a des valeurs aberantes pour les deux variables

########################################################################

# Q1- Tracer le nuage de points

plot(Dataset$nbEleves,Dataset$Depenses, main="Budget en fonction du nombre d'eleve en Europe",xlab="nb d'?tudiants",ylab='Budget')

text(Dataset$nbEleves,Dataset$Depenses,row.names(Dataset),cex=0.7)  # Donne les noms des indivuds sur la graphe
#cex taille de la police
# Tout de suite on peut remarquer en regardant le nuage des points qu'il y a un pays qui est tres loi des autres (pays magique)


########################################################################

# Q2- Coefficient de correlation entre les variables

cor(Dataset) # Ici correlation r=0.72369, les deux variables sont li?es de sens positif; c-?-dire plus le nombre des ?leves 
#augmente plus la d?pense augmente.


#ou aussi 
cor(Dataset$nbEleves,Dataset$Depenses)

# Les valeurs dans le diagonale donne correlation entre les variables,les autres valeur sont 1, c'est normal
# car c'est la correlation entre la variable et lui m?me

########################################################################

# Q3- deteminer une Droite de regression alors il faut construire un mod?le lin?aire definit en R par lm (linear model)

modele <-lm(Depenses ~ nbEleves,data=Dataset ) #calculer le modele de regression dont je l'ai donn? le nom modele

modele  # a=3.125 et b=intercept=10253.188 donc le modele de regresion est 
#depenses=3.125*Nbeleves+10253.188

summary(modele) # R?sume toutes las caracteristiques du mod?le

# le Multiple R-squared designe la coefficient de determination, ici 0.5237, c-a-dire le modele de regression donne ici
# explique 50% de la variabilit? de budget 


coefficient=modele$coefficients # affiche seulement les coefficients a et b du mod?le, je l'ai donn?e le nom Coefficient
# donc coefficient vecteur avec deux valeurs a=coefficient[2] et  et b=coefficient[1]


# Pour tracer la droite de r?gression sur le graphique on utilise fonction abline

abline(coefficient[1],coefficient[2],col='red',lwd=2) 

# ou abline(modele$coef[1],modele$coef[2],col='blue',lwd=2) si j'ai pas donner nom coefficients ? mes coefficients obtenu
# lwd pour l'epaisseur du droite trac? 
# coefficient[1] : c'est le premier element du vecteur coefficient

# Remarque : un bon droite de regression qui represente bien les donn?es doit ?tre passer au milieu du nuage de points
# et ca c'est pas le cas ici, car on a des observations atypiques (pays magiques)

########################################################################

# Q4- Verifier les hypotheses sur le residu : 

#Il faut que les residus standardis? soient entre -2 et 2, si non, observation aberrante
# 

y.chapo=modele$fitted # commande fitted Affiche les pr?visions calcul? par le mod?le,ou le 
#(y chapeau) predite par le modele,les depenses donn?es en tableau designe les vraies valeurs des depense

ei=modele$residuals # commande residuals Affiche les residus du modele (ei= y -y chapeau)
# ou il calcule (vrai valeur - valeur predite)
# ou ici ei=y.chapo-depenses$Depenses

restd<-rstandard(modele) # commande rstandard Donne residus standardis?s ou centr? reduit 
# pour les calculer : (residu (i) -moyenne de tous les residus)/ecart type de tous les residus

X11() # Ouvre une nouvelle fenetre graphique

plot(y.chapo,restd,ylim = range(-2,2,restd),main="Residus standardis?s") 
#on trace residu standardis? avec Y predite, on peut mettre au lieu de Y,la variable X=nbEleves 
# commande range donne le min et le max d'une serie de nombres

text(y.chapo,restd,row.names(Dataset),cex=0.7) #j'ajoute les noms des pays sur mon graphe

abline(h=-2,col="blue",lwd=2) # ajoute le ligne pour detecter les observations atypiques au dessous de -2
abline(h=2,col="blue",lwd=2) # ajoute le ligne pour detecter les observations atypiques au dessus de 2


# On remarque que pays magique tres loin des autres,detect? comme atypique on le supprime de l'etude.

#On peut detecter aussi une observation influente en calculant le levier,valeur proch de 1,alors influente 

influence(modele)$hat # fonction influence donne levier, ici pour pays magique levier =0.69 donc influente

influence(modele)$hat["France"] # pour obtenir levier de la France
influence(modele)$hat["Allemagne"]
influence(modele)$hat["PaysMagique"]


# Si on regarde levier de France et Allemagne, ils sont loins de 1.. pour cela on a pas supprim? malgr?
#qu'ils sont au dehors de deux lignes trac?s?? mais levier loin de 1,alors observations non atypiq 

########################################################################

# Q5- Pays magique observation atypique, alors il faut le supprimer et creer un nouveau modele

# Alors je cr?e un nouveau jeu de donn?es avec les 25 premiers observations, car pays magique designe observation 26,on le supprime
newdata=  Dataset[c(1:25),]  #j'ai choisi de ligne 1 ? ligne 25.


#ou aussi supprimer directement le dernier ligne (ligne 26)
newdata=Dataset[-c(26),]


#on a un nouveau jeu de donn?es avec 25 observations et qui s'appelle (tab1)

#On refait le m?me chose, trace nuage de points et creer modele de regression avec le nouveau jeu de donn?es depenses1

# Nuage de point

plot(newdata$nbEleves,newdata$Depenses, main="Budget en fonction du nombre d'eleve en Europe",xlab="nb d'?tudiants",ylab='Budget')
text(newdata$nbEleves,newdata$Depenses,row.names(newdata),cex=0.3) 


# Modele de regression

modele1<-lm(Depenses ~ nbEleves,data=newdata ) #calculer le modele de regression 
modele1  # a=7.1536 et b=intercept=-2093.810192 
#depenses=7.15*NbEleves-2093.81

# on trace le droite de regression sur le graphe de nuage de point
summary(modele1)
abline(modele1$coef[1],modele1$coef[2], col="purple",cex=2)
text(newdata$nbEleves,newdata$Depenses,row.names(newdata),cex=0.7) 

# On peut remrquer que le droite de regression un peu plus centr? que avant : c-a dire il est plus representatif
# tout les pays sont autour de ce droite, mais le pologne un peu plus loin

restd1<-rstandard(modele1)
plot(newdata$nbEleves,restd1,ylim = range(-2,2,restd),main="Residus standardis?s") 


text(newdata$nbEleves,restd1,row.names(newdata),cex=0.7) #j'ajoute les noms des pays sur mon graphe

abline(h=-2,col="blue",lwd=2)
abline(h=2,col="blue",lwd=2)

#Ici on peut voir que Pologne designe observation atypique, pas entre les deux lignes,pour savoir s'il
# faut le supprimer et faire un nouvea modele, on calcule le levier, s'il a une valeur proche de 1
#alors il faut le supprimer et refaire le modele

influence(modele1)$hat # Pour calculer les leviers

influence(modele1)$hat["Pologne"] # pour obtenir levier de la Pologne

# Levier pologne = 0.0855, alors loin de 1, on conserve le mod?le obtenu

########################################################################

# Q6- Poucantage de variablit? : c'est la coefficent de determination

summary(modele1) #donne tous sur le modele de regression creer et donne aussi coeffe de determination

# On obtient Multiple R-squared = 0.9333, c'estle coeff de determination, alors 93% de la variablit? du budget est
#expliqu? par le droite de regression ( c'est mieux que le modele precedent, qui a expliqu? juste 50%)


##################################################################################

# Q7- Budgets predits par le modele pour nb etudiants = 1000, 6500 et 9000

#On definit un vecteur avec les trois valeurs donn?es

newx <- data.frame(c(1000, 6500, 9000)) #On a donn? les valeurs de la variable
names(newx) = "nbEleves"  #On a nomm? cette variable

# on calucle les valeurs predites avec modele 1, car c'est le meuilleur

prev <- predict(modele1, newdata=newx) # calcule les pr?visions aux nouveaux points en utilisant le modele corrig?

prev # Affiche les trois valeurs predites respectiveement pour le 1000, 6500 et 9000

plot(newdata$nbEleves, newdata$Depenses, main = "Budget en fct du nb d'eleves en Europe",
     xlab = "nb d'etudiants (en milliers)", ylab="Budget en Keuro")

points(t(newx), prev, col='red', lwd = 2) # fonction points ajoute les 3 nouveaux valeurs sur le graphe

# t(newsx) transpos?; 

########################################################################################
########################################################################################
########################################################################################

