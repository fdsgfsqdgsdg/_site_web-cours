
##  Quantitatif*Qualitatif

## Exercice 2: (Donn?es Salaires Data)

dataset<-read.table("SalairesData.csv", header = TRUE,row.names=1,sep=';')

#Q1 : Represente Bo?te de Tuckey Salaire-Cat?gories

# table(dataset$Categorie,dataset$Etablissement)

boxplot(dataset$Salaire~dataset$Categorie, main = 'Salaire en fonction du Cat?gorie', xlab='Cat?gories',
        ylab = 'Salaire', col ='purple')


#Q2 : On constate une diff?rence de salaires entre les cat?gories, notament pour la cat?gorie CS 
#o? les salaires sont tres ?lev?s. On va calculer le rapport de cor?lation pour confirmer cette 
#conclusion. 


# Pour calculer le rapport de corr?lation, on va cr?er un modele entre les deux variables 
#Salaire et Cat?gories :

model1 <- lm(dataset$Salaire~as.factor(dataset$Categorie)) # relation salaire et cat?gories

# ou on peut ecrire aussi 
model1 <- lm(Salaire~as.factor(Categorie), data = dataset)
summary(model1)
ANOVA1 <- anova(model1) 
print(ANOVA1)

#Variance Inter
var.inter1=ANOVA1$`Sum Sq`[1]/130 # inter
var.inter1

#Variance Intra
var.intra1=ANOVA1$`Sum Sq`[2]/130 #intra
var.intra1

var(dataset$Salaire)
#Variance total
var.total1 <- var.inter1+var.intra1
rapport1 <- var.inter1/var.total1
rapport1

# 95% de la variablilt? des salaires est expliqu? par la cat?gorie, ce qui confirme
#la conclusion tir? par le boxplot.

################################################################

# Q3: lien entre Age et Cat?gories, on va creer un modele entre les deux variables Age et
#Categories, puis on calcule le rapport de corr?lation :

boxplot(dataset$age~dataset$Categorie, main = 'Age en fonction de Cat?gorie', xlab='Categories',
        
        ylab = 'Age', col = 'red')

model2 <- lm(dataset$age~as.factor(dataset$Categorie)) # relation age et cat?gories
summary(model2)
ANOVA2 <- anova(model2) 

#Variance Inter
var.inter2=ANOVA2$`Sum Sq`[1]/130 # inter
var.inter2

#Variance Intra
var.intra2=ANOVA2$`Sum Sq`[2]/130 #intra
var.intra2

#Variance total
var.total2 <- var.inter2+var.intra2
rapport2 <- var.inter2/var.total2
rapport2

## 47% de la variablilt? des ages est expliqu? par la cat?gorie.


# lien entre Age et Etablissement, on va creer un modele entre ces deux variables puis calculer
#le rapport de corr?lation :

boxplot(dataset$age~dataset$Etablissement, main = 'Age en fonction de Etablissement', xlab='Etablissement',
        
        ylab = 'Age', col = 'red')

model3 <- lm(dataset$age~as.factor(dataset$Etablissement)) # relation age et Etablissement

ANOVA3 <- anova(model3) 

#Variance Inter
var.inter3=ANOVA3$`Sum Sq`[1]/130 # inter
var.inter3

#Variance Intra
var.intra3=ANOVA3$`Sum Sq`[2]/130 #intra
var.intra3

#Variance total
var.total3 <- var.inter3+var.intra3
rapport3 <- var.inter3/var.total3
rapport3


## 1.6% de la variablilt? des ages est expliqu? par l'etablissement.


# Q4 : Boites de Tuckey


boxplot(dataset$Salaire~dataset$Etablissement, main = 'Salaire en fonction du site', xlab='Etablissement',
        
        ylab = 'Salaire', col = 'purple')

# On constate qu'il y a beaucoup d'individus atypiques dans chaque s?rie. La moyenne et la 
# variance ne sont donc pas des indicateurs pertinents dans ce cas (car attir?s par les valeurs
# extr?mes). Le rapport de corr?lation se faisant par calcul de moyennes et de varaiance risque
#d'en ?tre fauss?.



#### Code suppl?mentaire :

# Je peux diviser les observations de la variable quantita (Salaire) suivant les modalit?s
# de la variable 'Etablissement'

Etab.A<-dataset[which(dataset[,5]=="A"),2] #salaire du gens qui sont dans ?tablisement A
print(Etab.A)
Etab.B<-dataset[which(dataset[,5]=="B"),2]
Etab.C<-dataset[which(dataset[,5]=="C"),2]

