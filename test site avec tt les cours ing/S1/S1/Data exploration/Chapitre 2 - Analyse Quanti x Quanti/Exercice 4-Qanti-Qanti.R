
####### TP2 : Analyses Bivari?es : Croisement Qunatitatif-Quantitatif ####################################


### Exercice 4  ###

# Y = Quantit?s command?s ( Vente)
# X = Prix

# Lire les donn?es

Dataset<-read.table( "Commandes.csv",header=T, sep=';')


# Q1- Nuage des points

plot(Dataset$Prix,Dataset$Vente,main="Nombre de commande en fonction de prix")
#######################################################################################

# Q2- Correlation entre X et Y

cor(Dataset)

cor(Dataset$Prix,Dataset$Vente) #  corr=-0.8685, |-0.8685|=0.8685 proche de 1 donc les deux variables sont tr?s bien li?es
# cor de valeur negatif alors ces deux variables sont li?es de sens negatif, alors si le prix augmente le commande diminue

###############################################################################################

# Q3- Detreminer droite de regression de Y (Quantit? ou vente ) en fonction de X (Prix)
# Pour etablir un equation de regression de Y en X, on utilise lm(Y~X, data=nom du jeu de donn?s)

reg<-lm(Vente ~ Prix,data=Dataset ) 
coefficient=reg$coefficients

# commandes=-0.3848prix+112.7414

abline(coefficient[1],coefficient[2],col='red',lwd=2) 

###############################################################################################

# Q4- Coefficient de determination


summary(reg)


# Multiple R-Squared = 0.7544, 75% de la variabilit? des commandes s'explique par la droite de regression 


###############################################################################################

# Q5- Calculer les r?sidus 

ei=reg$residuals # Les residus du mod?le
ei

rstd<-rstandard(reg) # les residus standardis?s

y.predit=reg$fitted 

plot(y.predit,rstd,ylim=range(-2,2,rstd),main="Residu standardis?s")
# range (-2,2,rstd) c'est Pour prendre les valeurs -2 et 2 sur l'axe


abline(h=-2,col="green",lwd=2)
abline(h=2,col="green",lwd=2)


##################################################################################################

# Q6- On pose u et v

u=log(Dataset$Prix)
v=log(Dataset$Vente)
plot(u,v)

#On peut remarquer un relation lin?aire entre u et v.

##################################################################################################

# Q7- Coeff de correlation entre u et v

cor(u,v)  # corr=-0.9918,les 2 variables sont tres correl? mais de sens inverse,plus u augmente,plus v diminue

##################################################################################################

# Q8- Droite de regression de v sur u 

Reglin=lm(v~u) # on met pas data =... car u et v deux nouelles variables definies,se trouve pas dans data

# On obtient v=16.699-2.624*u

##################################################################################################

# Q9- Coefficient de determination :

summary(Reglin)

# On obtient Multiple R-squared= 0.9838, alors cette droite explique 98% de la variabilit? de v.

##################################################################################################

# Q10- Valider le mod?le

ei1=Reglin$residuals # Les residus du mod?le

rstd1<-rstandard(Reglin) # les residus standardis?s

y.predit1=Reglin$fitted 

plot(y.predit1,rstd1,ylim=range(-2,2,rstd1),main="Residu standardis?s")


abline(h=-2,col="purple",lwd=2)
abline(h=2,col="purple",lwd=2)



# Tous les r?sidus entre -2 et 2, alors on valide le mod?le.  

##################################################################################################

# Q11- Si prix x=75 euros, predit le quantit? y

# Comme ici le meuilleur mod?le c'est avec u et v, alors au lieu de x et y, on prend u=log x et v=log y


newv=16.699-2.624*(log(75)) #Ici on a un modele avec u qui est le log de x
quantit=exp(newv)

# Pour un prix de 75 euros, la quantit? command? serait de 214. 

newu=data.frame(u=c(log(75)))
newv=predict(Reglin,newdata=newu)
exp(newv)

