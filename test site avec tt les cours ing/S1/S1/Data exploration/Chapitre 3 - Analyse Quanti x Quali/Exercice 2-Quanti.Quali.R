
## Exercice 3: Enseignement Sup?rieur Data

EnsSup <- read.table("EnsSuperieurData.csv", header=T,row.names=1, sep=";")

# On peut remarquer que la variabe (Homme) qui represente les nombrs des hommes dans l'enseig
# sup de chaque pays est consid?r? comme une variable qualitative (character), alors qu'elle est 
# une variable numerique,et ca ? cause des espaces entre les valeurs.

#il faut alors enlever ces espacees

EnsSup$Homme <- as.numeric(gsub(' ', '', EnsSup$Homme)) #gsub: suprime l'espace dans les valeurs en millier
EnsSup$Femme <- as.numeric(gsub(' ', '', EnsSup$Femme))
EnsSup$Population.totale <- as.numeric(gsub(' ', '', EnsSup$Population.totale))

# Boxplot de deux modalit?s Hommes et Femmes

boxplot(EnsSup$Homme,EnsSup$Femme,col='yellow', names=colnames(EnsSup[,1:2])) # commande names
#pour qu'il donne les meme noms que les deux colonnes 1 et 2 du tableau EnsSup, si non R le
# renomme automatiquement par 1 et 2.


## calculer les variances intra et inter par la fct lm

#Pour utiliser la fonction (lm) pour cr?er le mod?le, il faut avoir une variable qualitatitive
#et une autre quantitative, et ici c'est pas le cas.. 

#on a dans chaque pays les nombres des etudiants femmes et Hommes, alors on va cr?er une 
# nouvelle vaiable (sexe) avec les modalit?s "Femme" et "Homme".

#c(rep(1,5),rep(2,5))

Sexe <-c(rep("Homme",33),rep("Femme",33))
Sexe

#Sexe <- gl(2, 33, 2*33,
           




#Petit exemple pour utiliser commande gl
#test1 <- gl(2, 5,2*5,labels=c('1','5'))    
#print(test1)
#test2 <- gl(3, 5,3*5,labels=c('1','8','4'))
#print(test2)

Effectif <- c(EnsSup$Homme, EnsSup$Femme)
Effectif
# Maintenant, on peut cr?er le mod?le avec la fonction lm pour obtenir les variances

model <- lm(Effectif~as.factor(Sexe))
ANOVA <- anova(model)
ANOVA

summary(model)
## variance intra
intra <- ANOVA$`Sum Sq`[2]/66

## variance inter
inter <- ANOVA$`Sum Sq`[1]/66
rapport <- inter/(intra+inter)
print(rapport)

# conculsion : 0.4% de la variation du nb d'etudiant est expliqu?e par le sexe.

summary(model)

