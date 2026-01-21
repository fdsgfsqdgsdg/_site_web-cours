
# Qualitatif x Qualitatif 

#Exercice 3 :


Mydata=read.table("lenses.txt",header=T) 
summary(Mydata) 

#Nous allons ?tudier le lien entre les variables Recommendation et Age. 

# Q1 : Tableau de contingences de effectifs et des frequences

# Tableau de contingence des effectifs

cont=table(Mydata$Recommendation,Mydata$Age) #Donne le tableau de contingence
cont #tableau des effectifs
cont.tot=addmargins(cont) # Donne le total de chaque ligne et chaque colonne.
cont.tot


# Tableau des fr?quences 

freq=cont/sum(cont) #Divise chaque element du tableau par l'effe total.
# sum(cont)donne eff total
freq # Tableau de frequences
freq.tot=addmargins(freq) 
print(freq.tot) # Donne total des chaque ligne et chaque colonne, c-a-dire les freq marginales
# ou on l'apelle aussi profil moyen ligne et profil moyen colonne


# Q2 : Profils lignes

# a) Calculs de profils lignes : diviser chaque element du tab de contingence par total de ligne
# on se trouve cet element.

prof.lignes=prop.table(cont,1) # le 1 pour diviser par le total du ligne
prof.lignes


# b) Verification

# Il faut obtenir un somme de 1 pour chaque ligne, on fait alors une v?rification

addmargins(prof.lignes) #addmarings donne total de chaque ligne et colonne

# ou bien 

apply(prof.lignes,1,sum) # 1 pour faire somme en ligne, on utilise 2 pour l'avoir en colonne.




# c) Repr?sentation graphique 

# sans le profil moyen  : on prend le table de profil moyen

plot(prof.lignes,col=heat.colors(3)) 
#donne une representation des modalit?s de la variable 'Ag' par rapport au modalit?s de la
#variable 'Recommandation'


# avec le profil moyen (comme ca on peut comparer graphiquement la distribution des modalit?s
# de la variable 'Age' selon les modalit?s de 'Recommandation' avec le profil moyen ligne)

prof.moy.lignes=freq.tot[4,1:3] # 4eme ligne, de colonne 1 ? 3 du tableau de frequence,
# c'est le profil moyen des lignes ou fr?quence marginale des lignes 

prof.moy.lignes 
 
new.prof.lignes=rbind(prof.lignes,prof.moy.lignes) # on cree un seul tableau, on ajoute 
# le profil moyen des lignes en derni?re ligne avec commande rbind

print(new.prof.lignes)

new.prof.lignes=as.table(new.prof.lignes) # transformation de la matrice en table, n?cessaire pour le plot 
rownames(new.prof.lignes)[4]="Profil moyen" # changer le nom de dernier colonne
print(new.prof.lignes) 
plot(new.prof.lignes,main="Profils lignes",col=heat.colors(3))

# d) Conclusion : Dans l'?chantillon il y a autant de young que de pre-presbyopic ou de 
# presbyopic. On note que cette  r?partition n'est pas respect?e pour les recommendations hard 
# et soft. Il y a beaucoup plus de young pour la recommendation hard et un sous-repr?sentation
# des presbyotic pour la recommendation soft. Cette disparit? semble indiquer un lien entre 
# les variables.



# Q3 : Profils colonnes : on fait le m?me travail avec les colonnes 

prof.col=prop.table(cont,2) # 2 pour que fait la somme par colonne

# v?rification de la somme des colonnes 
addmargins(prof.col) 
# ou bien 
apply(prof.col,2,sum) 


# Repr?sentation graphique 


# sans le profil moyen 
plot(t(prof.col), col='green')


# avec le profil moyen 
prof.moy.col=freq.tot[1:3,4] # profil moyen des colonnes = fr?quence marginale des colonnes

new.prof.col=cbind(prof.col,prof.moy.col) # on ajoute le profil moyen des  colonnes en 
# derni?re colonne avec la commande cbind

new.prof.col=as.table(new.prof.col) # transformation de la matrice en table, etape n?cessaire pour le plot 


plot(t(new.prof.col),main="Profils colonnes",col=heat.colors(3)) # Attention ? transformer les lignes en colonne avec la fonction t (pour transpose)



# Q4) Independance des variables :


# On peut faire le test d'ind?pendance directement avec des commandes

resultat=chisq.test(cont) 
resultat

# On regarde le p-value =0.8614 et on compare avec le risque d'erreur qui est 0.05.
# ici p-value > 0.05 alors les variables sont independantes.

resultat$expected # Donne les effectifs th?oriques

# Le warning obtenu car normalement il faut que tous les effectifs th?oriques soient superieur
# ou egale ? 5 et c'est pas le cas ici, donc les r?sultats obtenus ? prendre mais avec pr?caution
resultat$statistic # distance du chi-deux 
resultat$parameter # degr?s de libert? (df=degre of freedom) 

# La distance du chi-deux vaut 1.3. Nous avons 2 variables ? trois modalit?s donc le nombre 
# de degr?s de libert? est (3-1)*(3-1)=4. Le seuil avec lequel nous devons comparer la 
# distance du chi-deux est 9.49. La distance calcul?e est bien inf?rieure. Donc contrairement ? 
# ce que l'analyse des profils lignes et colonnes laissait supposer, les variables sont
# consid?r?es comme ind?pendantes. Autrement dit l'age  n'a pas d'impact sur la recommandation. 


###################################################


# On peut faire les calculs nous m?me, on calcule le tableau des effect th?oriques, 
#puis le table de chi-deux et finalement la distance du chi-deux 


# Table des effectifs th?oriques :

tab.theo=matrix(0,3,3) #on a definit une matrice pour calculer les effectifs th?oriques

# Pour remplir la matrice 

for (i in 1:3) 
{ 
  for (j in 1:3) 
  { 
    tab.theo[i,j]=(prof.moy.lignes[j]*prof.moy.col[i] )*nrow(Mydata)
  } 
} 

# nrow(Mydata) = donne effectif total ou nombre total des observations (ici 24)

print(tab.theo) 


# Table de chideux qui donne la diff?rence 

tab.chi2=((cont-tab.theo)^2)/tab.theo 

# Calcule de la distance de khi-deux pour ?tudier l'ind?pendance.

dchi2=sum(tab.chi2)
