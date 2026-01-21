DROP DATABASE IF EXISTS Pokemons_TD4; -- supprimer la base seulement si elle existe avant
CREATE DATABASE Pokemons_TD4;
USE Pokemons_TD4; -- se connecter à la base

DROP TABLE IF EXISTS Defense;
DROP TABLE IF EXISTS Arene;
DROP TABLE IF EXISTS Apparition ;
DROP TABLE IF EXISTS Emplacement;
DROP TABLE IF EXISTS Pokemon;
DROP TABLE IF EXISTS Joueur ;
DROP TABLE IF EXISTS Equipe;

CREATE TABLE Equipe(
	id INT PRIMARY KEY,
	nom VARCHAR(9),
	couleur VARCHAR(5));

CREATE TABLE Joueur(
	pseudonyme VARCHAR(30) PRIMARY KEY,
	personnage VARCHAR(30) NOT NULL UNIQUE,
	sexe CHAR(1),
	niveau SMALLINT DEFAULT 0 NOT NULL,
	idEquipe INT,
	FOREIGN KEY fk_joueur_equipe(idEquipe) REFERENCES Equipe(id) ON DELETE CASCADE);

CREATE TABLE Pokemon(
	id INT PRIMARY KEY,
	nom VARCHAR(30),
	espece VARCHAR(20),
	pointCombat INT,
	idJoueur VARCHAR(30),
	FOREIGN KEY fk_joueur(idJoueur) REFERENCES Joueur(pseudonyme),
	CONSTRAINT check_pointCombat CHECK (pointCombat >= 0));	

CREATE TABLE Emplacement(
	id INT PRIMARY KEY,
	latitude DECIMAL(12,10) NOT NULL,
	longitude DECIMAL(13,10) NOT NULL,
	CONSTRAINT check_latitude CHECK (latitude BETWEEN -90 AND 90),
	CONSTRAINT check_longitude CHECK (longitude BETWEEN -180 AND 180));

CREATE TABLE Apparition(
	idPokemon INT, 
	idEmplacement INT,
	horaire DATE,
	duree INT,
	CONSTRAINT pk_Apparition PRIMARY KEY (idPokemon, idEmplacement),
	FOREIGN KEY fk_pokemon(idPokemon) REFERENCES Pokemon(id),
	FOREIGN KEY fk_app_emplacement(idEmplacement) REFERENCES Emplacement(id));

CREATE TABLE Arene(
	id INT PRIMARY KEY, 
	nom VARCHAR(30), 
	idEmplacement INT,
	FOREIGN KEY fk_are_emplacement(idEmplacement) REFERENCES Emplacement(id));	

CREATE TABLE Defense(
	idEquipe INT, 
	idArene INT, 
	dateControle DATE,
	CONSTRAINT pk_Defense PRIMARY KEY (idEquipe, idArene, dateControle),
	FOREIGN KEY fk_defense_equipe(idEquipe) REFERENCES Equipe(id), 
	FOREIGN KEY fk_arene(idArene) REFERENCES Arene(id));

INSERT INTO Equipe VALUES (1, 'Intuition', 'Jaune');
INSERT INTO Equipe VALUES (2, 'Sagesse', 'Bleu');
INSERT INTO Equipe VALUES (3, 'Bravoure', 'Rouge');

INSERT INTO Joueur VALUES ('Shadow', 'Smith', 'F', 10, 1);
INSERT INTO Joueur VALUES ('Root', 'Alice', 'F', 20, 2);
INSERT INTO Joueur VALUES ('Admin', 'Bob', 'M', 1, 1);
INSERT INTO Joueur VALUES ('Flavius', 'Ruth', 'M', 20, 2);
UPDATE Joueur SET niveau = 15 WHERE sexe = 'F';

INSERT INTO Pokemon VALUES (1, 'Bulbizarre', 'Graine', 1071, 'Shadow');
INSERT INTO Pokemon VALUES (25, 'Pikachu', 'Souris', 887, 'Root');
INSERT INTO Pokemon VALUES (107, 'Tygnon', 'Puncheur', 204, 'Shadow');
INSERT INTO Pokemon VALUES (103, 'Noadkoko', 'Fruitpalme', 190, 'Admin');
INSERT INTO Pokemon VALUES (150, 'Mewtwo', 'Génétique', 4144, 'Root');
INSERT INTO Pokemon VALUES (19, 'Ratata', 'Souris', 20, 'Admin');

INSERT INTO Emplacement VALUES (1, 49.0350369, 2.0696998);
INSERT INTO Emplacement VALUES (2, 48.857848, 2.295253);
INSERT INTO Emplacement VALUES (3, -74.0445, 40.6892);

INSERT INTO Apparition VALUES (1, 2, '2016-10-09', 10);
INSERT INTO Apparition VALUES (25, 1, '2016-09-01', 20);
INSERT INTO Apparition VALUES (107, 3, '2016-10-02', 5);
INSERT INTO Apparition VALUES (103, 1, '2016-10-25', 15);
INSERT INTO Apparition VALUES (25, 3, '2016-10-25', 3);

INSERT INTO Arene VALUES (1, 'Liberte', 3);
INSERT INTO Arene VALUES (2, 'Eisti', 1);
INSERT INTO Arene VALUES (3, 'Star', 2);

INSERT INTO Defense VALUES (1, 1, '2016-10-10');
INSERT INTO Defense VALUES (1, 2, '2016-09-01');
INSERT INTO Defense VALUES (3, 2, '2016-10-10');


-- q1) Combien d'arènes l'équipe Intuition a pris le contrôle ?
SELECT COUNT(DISTINCT A.id) NbArenePrises
FROM Arene A, Defense D, Equipe E
WHERE A.id = D.idArene
AND D.idEquipe = E.id
AND LOWER(E.nom) = 'intuition'
;

-- q2) Quelle est la date de la première apparition de Tygnon ?
SELECT MIN(A.horaire) 
FROM Apparition A, Pokemon P
WHERE LOWER(P.nom) = 'tygnon'
;

-- q3) Quels sont les joueurs qui ont participé à la défense de l'arène EISTI ?
SELECT pseudonyme
FROM Joueur J, Arene A, defense D
WHERE J.idEquipe = D.idEquipe
AND A.id = D.idArene
AND LOWER(A.nom) = 'eisti'
;

-- q4) Compter le nombre de Pokémons de chaque joueur. Le pseudonyme du joueur suffit dans la réponse.
SELECT p.idJoueur Pseudonyme, COUNT(*) NbPokemon
FROM Pokemon p
GROUP BY p.idJoueur
;

-- q5) Quelle est la moyenne des points de combat de chaque espèce de Pokémon ?
SELECT espece, CAST(AVG(pointCombat) AS DECIMAL(10,2))
FROM Pokemon
GROUP BY espece;

-- q6) Pour chaque joueur, afficher son pseudonyme, son équipe et le nombre de Pokémons qu'il possède.
SELECT j.pseudonyme, e.nom, count(p.id)
FROM Joueur j, Equipe e, Pokemon p
WHERE j.idEquipe = e.id
AND p.idJoueur = j.pseudonyme
GROUP BY j.pseudonyme
;
-- ne marche pas à retravailler

-- q7) Pour chaque Pokémon, donner le nom et la durée totale d'apparition.
SELECT id, nom, SUM(duree) as 'totalTime'
FROM Pokemon LEFT JOIN Apparition 
ON id = idPokemon
GROUP BY id, nom
;

-- q8) Donner pour chaque arène son nom et la date de prise de contrôle la plus récente.
SELECT nom, MAX(dateControle) as 'lastDef'
FROM Arene LEFT JOIN defense ON id = idArene
GROUP BY nom
;

-- q9) Pour chaque Pokémon, donner son nom, son espèce et le nombre d'apparitions. Nous sommes intéressés seulement aux Pokémons qui ont apparu au moins 2 fois.
SELECT nom, espece, COUNT(idPokemon) as 'nbApparition'
FROM Apparition, Pokemon
WHERE (idPokemon = id)
GROUP BY idPokemon, nom, espece
HAVING nbApparition>=2
;

-- q10) Pour chaque Pokémon, donner son nom, son espèce et le nombre d'apparitions dont la durée est supérieure à 5 minutes.
SELECT nom, espece, COUNT(idPokemon) NbApparition
FROM Apparition, Pokemon
WHERE (idPokemon = id) AND (duree > 5)
GROUP BY id, nom, espece
;

-- q11) Pour chaque pokémon de plus de 1000 points de combat, donner son nom, son espèce et la durée totale d'apparition. Nous sommes intéressés seulement aux pokémons 
-- qui sont apparus au moins 10 minutes.
SELECT p.nom, p.espece, SUM(a.duree) as DureeTotale
FROM Apparition a, Pokemon p 
WHERE p.id = a.idPokemon AND (p.pointCombat > 1000)
GROUP BY p.nom, p.espece
HAVING DureeTotale >=10
;

-- q12) Donner le temps moyen d'apparition des pokémons appartenant aux joueurs de l'équipe ayant contrôlé le plus d'arènes différentes.
SELECT p.id, p.nom, AVG(a.duree) as 'TempApp'
FROM Pokemon p, Apparition a, Joueur j
WHERE p.id = a.idPokemon
AND p.idJoueur = j.pseudonyme
AND idEquipe IN (SELECT idEquipe
					FROM defense
					GROUP BY idEquipe
					HAVING COUNT(DISTINCT idArene) = (SELECT MAX(compte)
														FROM (SELECT COUNT(DISTINCT idArene) compte
														FROM defense
														GROUP BY idEquipe) tmp
														)
						)
GROUP BY p.id, p.nom
;

