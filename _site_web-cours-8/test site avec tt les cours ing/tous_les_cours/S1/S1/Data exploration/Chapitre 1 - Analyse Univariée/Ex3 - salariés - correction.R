#Jeu de données : SalariesData


salaries<-read.table('SalariesData.csv',header=TRUE,sep=';')
summary(salaries)
###########################################################
# 1-
mean(salaries$Salaire) # Salaire moyenne
median(salaries$Salaire) # Mediane = 23, c-a-dire 50% des salariés ont un salaire inferieur à 23
# La différence entre salaire moyen et médian est due aux trés gros salaires des cadres supérieurs.

###########################################################

# 2- Pour calculer les quartiles

quantile(salaries$Salaire) # Donne tous les quantiles

# Le quantile 0%=18, c a dire il ya 0% des employés ou aucun employé a un salaire inferieur a 18, c'est le minim de salaire alors
#Q1 =21, il ya 25% des employés qui ont un salaire inferieure ou egale à 21
#le quantile 100%= 140, c a dire tous les employes ont salaire inf ou egale a 140, donc c le salaire maximal


# Deuxieme methode pour avoir juste un quantile precise 

Q1=quantile(salaries$Salaire) [2]  # pour demander juste lePremier quantile, qui correspond a la deuxieme valeur de 
# quantiles donnés par le commande quantile(salaries$Salaire)

Q2=quantile(salaries$Salaire) [3]  #deuxieme quantile ou Mediane

Q3=quantile(salaries$Salaire) [4]  #Troisime quantile



# Troisieme méthode

Q=quantile(salaries$Salaire,prob=c(0.25,0.5,0.75))
Q

# Pour
D

#Interpretation decile : D1=x, c'a dire il ya 10% des employés qui ont un salaire inferrieur a x'

# Ou on peut faire les deux ensembles 

DC=quantile(salaries$Salaire,prob=c(0.1,0.25,0.5,0.75,0.9))
DC

D1=quantile(salaries$Salaire,prob=c(0.1)) # pour clculer premier decile tout seul

#Interpretation decile : D1=18, c'a dire il ya 10% des employés qui ont un salaire inferrieur a 18

# Ou on peut faire les deux ensembles 

#D9=55.1, c'a dire il ya 90% des employés qui ont un salaire inferrieur a 55.1

# Ou on peut faire les deux ensembles 

############################################################################################

# 3- Les dirigeants metteraient en avant les quartiles qui masquent les écarts de salaire,
#alors que les salariés parleraient des deciles.

###########################################################################################################

# 4-  Pour donner le table des effectifs, on utlise la commande table

eff.etablis=table(salaries$Etablissement)
eff.catego=table(salaries$Categorie)

# Pour donner table de frequences, on calcule effectif total avec commnde SUM, on peut faire

total=sum(eff.etablis)

#ou ( car ils ont meme effectif total )

total=sum(eff.catego) 

# donc tablea des frequences ( Rappel: freq(i)=eff(i)/effec total)*100 )

freq.etablis=table(salaries$Etablissement)/total * 100
freq.etablis
freq.catego=table(salaries$Categorie)/total * 100
freq.catego

prop.table(eff.etablis)*100 # freq en pourcantage

# Representation adaptées : les deux variables sont de types quali, on fait diag en barre et diag circulaire
# On peut les tracer avec les effectifs ou avec les frequences
# Avec les effectifs, on utilise les effectifs calculés avec fonction (table)


barplot(freq.catego,main="Diagramme en barre pour la variable Categories",xlab ='Categories',ylab='Frequences',col=heat.colors(3),legend.text = TRUE )

pie(freq.catego,main="Diagramme en barre pour la variable Categories",xlab ='Categories',ylab='Effectifs',col=heat.colors(3) )

layout(matrix(1:1,1,1))
# Avec les frequences, on utilise les frequences calculés qu'on a deja calculé 

barplot(freq.etablis,main="Diagramme en barre pour la variable etablissement",xlab ='Categories',ylab='FREQUENCES',col=heat.colors(3),legend.text = TRUE )
x11() # Ouvre nouveau fenetre et trace le prochaine representation sur ce fenetre


# main = pour definir le titre du diagramme 
#xlab= pour nommer les axes des abcisses
#ylab = pour nommer les axes des ordonnés
#col : pour choisir le couleur, je opeux dire encore col=heat.colors(3) si je veux que les couleurs soit differents

########################################################

# 5- Salaire et age deux variables discrete ici, on represente souvent par diag en baton

barplot(salaries$Age,main="Diagramme en baton (Age)",col='blue')
barplot(salaries$Salaire,main="Diagramme en baton (Salaire)",col='purple')

# Comme on a trop des valeurs dans chaque serie, alors les representations par un diagramme en baton est pas adaptés
# alors, il faut regrouper les données par des classes .


###################################################################################

h=hist(salaries$Salaire,breaks=c(18,30,90,120,140))$counts # $counts pour obtenir l'effectif de chaque classe
h # Pour que R renvoie l'efectif de chaque classe

sum(h) # commnde sum fait sommation de tous les elements de h et donne du coup l'effectif total, ici 130
C1=(18+30)/2 # Centre du premier classe [18,30[, 
C2=(30+90)/2  # Centre du deuxieme classe [30,90[
C3=(90+120)/2
C4=(120+140)/2
#h c'est l'effectif de tous les classes
#h[i] c'est l'effectif du classe i

moyenne=(C1*h[1]+C2*h[2]+C3*h[3]+C4*h[4])/130 
moyenne

#Comparer moyenne obtenu pour données regroupé et données initiale

mean(salaries$Salaire) # Moyenne de la variable initiale avant regrouper les donnes

# On peut remarquer qu'on a pas meme moyenne, c'est à dire on a de perte d'information.




