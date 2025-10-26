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

INSERT INTO Pokemon VALUES (1, 'Bulbizarre', 'Graine', 1071, 'Shadow');
INSERT INTO Pokemon VALUES (25, 'Pikachu', 'Souris', 887, 'Root');
INSERT INTO Pokemon VALUES (107, 'Tygnon', 'Puncheur', 204, 'Shadow');
INSERT INTO Pokemon VALUES (103, 'Noadkoko', 'Fruitpalme', 190, 'Admin');
INSERT INTO Pokemon VALUES (150, 'Mewtwo', 'Génétique', 4144, 'Root');

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

-- exercice 1 --
-- q°1
INSERT INTO Pokemon VALUES(19, 'Ratata', 'Souris', 20, 'Admin');
-- INSERT INTO Pokemon VALUES(39, 'Rondoudou', 'Bouboule', 4145, 'Moustache'); -- ne fonctionne pas car pas de personnage Moustache

-- q°2
INSERT INTO Defense VALUES (3, 2, '2016-10-10');

-- q°3
-- INSERT INTO Defense VALUES (2, 3); -- ne fonctionne pas car il manque des données (date)

-- q°4
INSERT INTO Joueur VALUES ('Flavius', 'Ruth', 'M', 20, 2);
-- INSERT INTO Joueur VALUES ('Asterix', 'Ruth', 'M', 5, 1); -- ne fonctionne pas car double entrée pour Ruth

-- q°5
UPDATE Joueur SET niveau = 15 WHERE sexe = 'F';

-- q°6
-- DELETE FROM Pokemon WHERE espece LIKE '%fruit%' ;

-- q°7
-- DELETE FROM Joueur WHERE pseudonyme = 'Admin';


-- exercice 2 --
-- q°1 Quel est l'arène dont le nom contient le mot "eisti" ?
SELECT * 
FROM Arene 
WHERE LOWER(nom) 
LIKE '%eisti%'
;

-- q°2 Quels sont les Pokémons dont le nom commence par la lettre p sans tenir compte de la casse ?
SELECT * 
FROM Pokemon 
-- WHERE LOWER(nom) LIKE 'p%' Analyse expression rationnelle plus lente
-- WHERE LOWER(SUBSTR(nom,1,1)) = 'p' moins rapide que left
WHERE LOWER(LEFT(nom,1)) = 'p'
;

-- q°3
SELECT * 
FROM Joueur 
WHERE LOWER(pseudonyme) 
NOT LIKE '%a%'
;

-- q°4
SELECT * 
FROM Pokemon 
ORDER BY pointCombat 
DESC
;

-- q°5
SELECT 
AVG(duree) 
FROM Apparition
; -- 9.5

-- q°6
SELECT COUNT(*) -- on peut remplacer par idPokemon mais ne change rien ici 
FROM Apparition 
-- WHERE horaire LIKE '2016-10-%' -- solution moins rapide
WHERE YEAR(horaire)=2016 AND MONTH(horaire)=10
;

-- q°7
SELECT nom
FROM Pokemon
WHERE espece IN (SELECT espece FROM Pokemon WHERE LOWER(nom)='pikachu') 
	AND LOWER(nom) <> 'pikachu' -- != n'est pas standart SQL
;

-- q°8
SELECT * 
FROM Joueur 
WHERE niveau>(SELECT AVG(niveau) FROM Joueur)
;

-- q°9
SELECT * 
FROM Pokemon 
-- ORDER BY pointCombat DESC LIMIT 1 --va affichier qu'un seul pokemon même s'il y en a 2 de même niveau. Doit tout trier donc plus long -> + de complexité
WHERE pointCombat=(SELECT MAX(pointCombat) FROM Pokemon) 
;

-- q°10
UPDATE Joueur 
SET niveau = 2+niveau 
WHERE LOWER(pseudonyme) = 'Shadow'
;

-- q°11
SELECT idPokemon
FROM Apparition
WHERE MONTH(horaire)=09
; -- fonctionne

-- autre moyen de le faire avec une jointure :
SELECT nom
FROM Apparition A,Pokemon P
WHERE P.id=A.idPokemon 
AND MONTH(A.horaire)=09
;
