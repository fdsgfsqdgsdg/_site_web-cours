#Vecteur

x<-c(5,8,9,3,4,7) # x vecteur de 6 ?lemnts
x
x[3] #Donne la troisieme valeur

#*****************************Generalit?-Introduction***************************
  
  # Pour lire les donn?es
 

  # 1. Selectionner un repertoire de travail (ouvrir le dossier ou se touve les donn?s)
  # 2. ouvrer un nouvel dossier, file-->new file --> R script
  # 3. Choisir les donn?es, soit aller au Import Dataset (haut ? droite), apres vous dites data=frenchCities
  # soit on les entre manuellement par l'instruction

  Dataset <- read.table("FrenchCities.csv",header=TRUE,row.names=1, sep=';',dec='.')
  
  #Dataset est le nom que j'ai choisi pour mon Jeu des donn?es,je peux choisir n'importe quel nom
  
  Dataset # quand je tape Dataset il m'affiche les donn?es
  
  #header=T,pour preciser que le premier ligne du tableau contient le nom des variables
  # row.names=1 indique que la premiere colonne contient le nom des observation (ici villes)
  #sep=';', indique que le separateur de champ entre deux colonnes est le point virgule.
  #dec='.', indique que les points qui sont dans les donn?es designe le virgule du decimale
  
  #Le fleche bleu ? gauche donne la liste des variables avec leur nature.
  #Le petit carr? ? droite permet d'afficher le jeu des donn?es dans une nouvelle fenetre
  
  #**** Remarque : Toujours il faut verifier le nombre de variables et nombre des observations,
  #si ce nombre ne sont pas correcte alors R a mal lu les donn?es, et ici l'importance d'uitiliser header et row.names
  
  #****************************************************
  
  # Quelques Instructions
  
  attributes(Dataset) # Donne les noms des variables et des individus.
  
  names(Dataset)  #Donne les noms de tous les variables
  
  row.names(Dataset) # donne les noms de toutes les observations qui sont les villes.
  
  summary(Dataset) # Dnne tous les resumées numériques des variables (Moye, mediane...)
  
  str(Dataset) # donne nombre de tous les variables et individus et le type de chaque variable
  # factor sont les variables qualitatives, les modalités level.
  # pour variab quantitative type num si variable continue et int si discrete
  
  
  ##########################################################################
  
  
  ### Comment selectionner une vaiable? (colonne)
  
  # Pour choisir la variable 'CLIMAT', ou colonne (CLIMAT),donc Climat pour toutes les observations :
  Dataset$CLIMAT  
  # ou 
  Dataset[,"CLIMAT"]
  # Sion ?crit CLIMAT tout seul on obtient rien, il faut ajouter le nom des donn?es.
  
  Dataset[,1]
  
  Dataset[1,]
  
  # Pour choisir la troisieme colones du données ( ou troisieme variables)
  Dataset[,3]
  #ou
  Dataset[,c(3)]
  
  # Pour choisir deux ou plusiers variables ? la fois, exemple choisir les variables de 3 ? 7
  
  Dataset[,3:7] # Affiche de la troisieme jusqu'? la septieme variables.
  
  Dataset[,c(3,7)]  # Affiche juste les variables 3 et 7
  
  ############################################################################
  
  #### Comment selectionner un Individus? (ligne)
  
  subset(Dataset,row.names(Dataset)=='Angers') # Pour choisir l'individu ou le ligne Angers
  
  Dataset[1,] # Pour choisir le ligne 1 du donnée ou la premiere observation
  
  Dataset["Brest",] #Affiche l'individu 'Brest'
  
  #ou
  
  Dataset[c(7),] #Affiche le septieme individu
  
  Dataset[c(3,7),]  # Affiche les individus 3 et 7
  
  Dataset[3:7,] # Affiche de la trisieme jusqu'? la septieme individus.
  
 
  #######################################################################
  
  #### Comment supprimer des variables et des individus??
  
 Dataset[,-1] #Supprimer la premiere variable
  
  Dataset[,-c(1,3)] # Supprimer les deux colonnes (variables) 1 et 3
  
  Dataset[,-c(1:3)] # Supprimer les colonnes (variables) de 1 ? 3
  
  Dataset[-c(1),] #Supprimer la premiere individu (ligne)
  
  Dataset[-c(1,7),] # Supprimer les deux individus (lignes) 1 et 7

  Dataset[-c(1:7),] # Supprimer les individus de 1 ? 7
  
  #****************************************************

#### Choisir des individus avec conditions 
  
  subset(Dataset,NO2>50) #donne que les individus qui ont NO2>50
  subset(Dataset,CLIMAT==4) # donne les individus qui ont Climat=4
  
  ####################################
  
  str(Dataset)  # Donne nature de chaque variable
  summary(Dataset)
  
  #La variable CLIMAT is type qualitative avec quatre modalit?s CONT=1 MED=2 ,OCEAN=3 ,SEMI_OCEAN=4, mais considére comme quantitative par R,
  #donc le resum? numerique obtenu avec l'instruction Summary n'a aucun sens!
  #alors, il faut signaler ? R que Climat represente une variable qualitative et pas quantitative
  
  
  is.factor(Dataset$CLIMAT) # Cet instruction donne FALSE si la variable est constat? comme
  #quantitative par R , et TRUE sinon (qualitative)
  
  
  Dataset$CLIMAT=as.factor(Dataset$CLIMAT) # comme ca CLIMAT devient variable qualitatives
  
  #On ressaye l'instruction is.factor pour tester la nature 
  
  is.factor(Dataset$CLIMAT) # Donne TRUE si la variable est qualitative
  
  
  ############# Renommer les modalit?s
  
  levels(Dataset$CLIMAT) #donne modalité de la variable qualitative et NULL si la variable est quantita
  levels(Dataset$CLIMAT)=c('CONT','MED','OCEAN','SEMI-OCEAN') #On nome les modalités
  levels(Dataset$CLIMAT) # Affiche les nouvelles modalit?s
  
  #Maintenant si je demande de nouveau le jeu des donn?es 'Dataset', on trouve que les modalit?s
  #1,2,3 et 4 de la variable 'CLIMAT' sont remplac? par 'Cont','MED',....
  
  summary(Dataset)
  ###################################
  
  #*****************************  RESUME NUMERIQUES  **************************************#
  
 mean(Dataset$NO2) # Donne moyenne de la variable NO2.
 median(Dataset$NO2) # Donne mediane de la variable NO2.
 sd(Dataset$NO2) # Donne l'ecart type de la variale
  
 var(Dataset$NO2) # Donne la varaiance de la variale
 
quantile(Dataset$TEMP) # Donne tous les quantiles de la variable.

# POur calculer un quantile pr?cise 
  
  Q1=quantile(Dataset$NO2) [2] # Premier quantile
  Q2=quantile(Dataset$NO2) [3] # Deuxieme quantile egale à la mediane
  Q3=quantile(Dataset$NO2) [4] # Troisime quantile
  
  ### Pour calculer les deciles 10%, 20%...,les quantiles ou n'importe quel proba :
  
  quantile(Dataset$NO2,prob=c(0.1,0.2,0.75,0.5,0.9,0.35))
  
  # ici on a premier et deuxieme deciles, troisime quantile, mediane,neuvieme decile et proba
  # d'avoir 35%...
  

    ##############################################################################
  
  #### Et encore quelque op?ration :
  
 Dataset$NO2 +10 # Pour ajouter 10 ? chaque composante de NO2.
  
  Dataset$NO2 *2 # Pour multiplier par 2 chaque composante de NO2.
  
  c(Dataset$NO2,25) # Pour ajouter une valeur supplementaire 25.
  

  
  ##################### Representations graphiques ################################
  
  ##################### Variables quantitatives ################################
  
  #  1. Histogramme (que pour variable quantita)
  
  Dataset$TEMP
  
  #La variable TEMP est quantitatif continue.
  
  hist(Dataset$TEMP, main='histogramme de la variable TEMPS',xlab='TEMP',ylab='freq',col='red')
  
  # Xlab et ylab pour nomer les axes X et Y.
  # main pour definir le titre
  # col c'est le couleur
  
  # 2. Boxplot (que pour variable quantitative )
  
  boxplot(Dataset$TEMP,main='Box Plot',xlab='TEMP',ylab='freq',col='pink')
  
  points(mean(Dataset$TEMP),col='blue',cex=0.5) # Pour ajouter le moyenne  sur le boxplot
  
  # Ici on remarque qu'il y a une observation abberante qui correspond au dernier ligne
  # du jeu des donn?es pour l'observation error qui a la seule valeur zero pour la temperature
  # Il faut supprimer cet erreur de notre jeux de données.donc, on selectionne que les villes 
  #avec des tempertaures positives, on a supprimé tout cette observation
  # Le nouveau tableau est alors :
  
  Dataset1=subset(Dataset,TEMP>0)
  
  # alors le nouveau jeu des donn?es Dataset1 contient 31 observations au lieu de 32.
  
  
  
  # 3. Diagramme en baton 
  
  
  barplot(table(Dataset$SUNSHINE),main='Diagramme en baton',col='green')
  

  
  
  ##################### Variables qualitatives ################################
  
  # 1. Diagramme circulaire  et diagramme en barre de la variable CLIMAT:
  
  #Pour tacer diagramme circulaire ou diagr en barre pour variable qualitative,
  
  #il faut tout d'abord calculer les effectifs de chaque modalit? avec l'instruction table(data$variable),apres on trace
  
  Effectif=table(Dataset$CLIMAT) # donne les effectifs de chaque modalitée
  
  pie(table(Dataset$CLIMAT),main='Diagramme circulaire',col=heat.colors(4))
  
  # ou aussi 
  
  pie(Effectif,main='Diagramme circulaire',col=c("red", "black", "yellow", "green"))
  
  # heat.colors (4) pour avoir 4 couleurs differents car on a 4 modalit?s.
  
  
  # 2. Diagramme en Barre ( Pour des variables qualitatives)

  
  barplot(as.matrix(Effectif),legend=TRUE,col=heat.colors(4)) # Barrres horizentales
  
  barplot(Effectif,legend=TRUE,col=heat.colors(4))  # Barres verticales
  
  #legend pour dire chaque couleur correspond à quel modalité
  
  ######################### Divers ###################
  
  prop.table(Effectif) # Donne pourcentage de chaque modalités
  addmargins(Effectif) # Donne effectif de chaque modalit?s avec effectif totale
  
  ####################### Transformation Quan en en Qualita
  
  #Transformer variable SUNSHINE qui est de type quantita en variable qualita avec modalité
  #cr?er une nouvelle variable SUN prenant les modalit?s ? TRES ? si la variable SUNSHINE est 
  #sup?rieure ? 2085, ? PEU ? si elle est inf?rieure ? 1793 et ? MODERE ? sinon. 
  
  SUN<-hist(Dataset$SUNSHINE,breaks=c(0,1793,2085,2917))$counts # counts donne l'eff de chaque modalite
  SUN #Pour obtenir l'effectif de chaque Classes
  sum(SUN) # Pour obtenir l'effectif total
  barplot(SUN,names.arg=c("PEU","MODERE","TRES"),col=heat.colors(3)) # Diagramme en barre
  
  # Les donnees sont maintenant sous forme des classes, alors pour calculer la moyenne, il faut la centre de chaque classe
  # Rappel : centre classe = (borne inf+borne sup)/2
 C1=(1793+0)/2 #Centre du premier classe
 C2=(2085+1793)/2
 C3=(2917+2085)/2
 
moyenne=((C1*8)+(C2*16)+(C3*8))/32  # 32 est l'effectif total, on peut le remplacer aussi par sum(SUN)

moyenne   # Affiche la moyenne calcul?
 
mean(Dataset$SUNSHINE) 
