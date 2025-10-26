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

-- exercice -- 
-- q°1. Quelle est la durée de l'apparition la plus récente du Pokémon ?
SELECT duree
FROM Apparition
WHERE horaire = (SELECT max(horaire)
				FROM Apparition)
;

-- q°2. Donner les noms des Pokémons qui ont le même point de combat et le même maître que 'Pikachu'.
SELECT nom
FROM Pokemon 
WHERE (idJoueur, pointCombat) = (SELECT idJoueur, pointCombat
					FROM Pokemon 
                    WHERE LOWER(nom)='pikachu')
                    AND LOWER(nom)<>'pikachu'
;

-- q°3. Quel est le joueur dont le pseudonyme est plus long que tous les noms des personnages ?
SELECT pseudonyme
FROM Joueur
WHERE LENGTH(pseudonyme) > (SELECT MAX(LENGTH(personnage))
							FROM Joueur)
;

-- q°4. Afficher toutes les dates de prise de contrôle des arènes, ainsi que les horaires des apparitions des Pokémons.
SELECT dateControle as 'dateControle horaire'
FROM defense
UNION
SELECT horaire
FROM Apparition;

-- q°5. Quelles sont les dates où il y a à la fois l'apparition d'un Pokémon et la prise de contrôle d'une arène ?
SELECT Apparition.horaire, defense.dateControle
FROM Apparition, defense
WHERE Apparition.horaire = defense.dateControle
;

-- q°6. Quels sont les joueurs dont le pseudonyme commence par la lettre A ou S et le personnage s'appelle pas Bob ?
SELECT pseudonyme
FROM Joueur
WHERE SUBSTR(LOWER(pseudonyme),1,1) IN ('a','s')
AND LOWER(personnage) <> 'bob'
-- WHERE (LOWER(pseudonyme) LIKE 'a%'
-- OR LOWER(pseudonyme) LIKE 's%')
-- AND LOWER(personnage) <> 'bob'
;

-- q°7. Quel sont les noms des Pokémons du joueur Admin ?
SELECT nom 
FROM Pokemon 
WHERE UPPER(idjoueur) = 'ADMIN'
;

-- q°8. Quels sont les joueurs qui n'ont jamais eu des Pokémons de type souris ?
SELECT pseudonyme 
FROM Joueur 
WHERE pseudonyme 
NOT IN (SELECT DISTINCT idjoueur 
		FROM Pokemon 
        WHERE LOWER(espece) = 'souris')
;

-- q°9. Quel est l'emplacement de l'arène EISTI ?
SELECT latitude, longitude
-- FROM emplacement
-- WHERE id = (SELECT idemplacement FROM arene WHERE UPPER(nom)='EISTI')
FROM emplacement e, arene
WHERE e.id = idemplacement 
AND UPPER(nom)='EISTI'
;

-- q°10. Quelle est l'équipe du joueur Shadow?
SELECT nom
FROM Equipe e, Joueur
-- WHERE id IN (SELECT idEquipe FROM Joueur WHERE LOWER(pseudonyme)='shadow')
WHERE e.id = idEquipe
AND LOWER(pseudonyme) = 'shadow'
;

-- q°11. Quels sont les Pokémons qui n'ont pas encore apparu 
SELECT id, nom
FROM Pokemon 
WHERE id NOT IN (SELECT DISTINCT idPokemon
				FROM Apparition)
;

-- q°12. Quel est la latitude et la longitude de l'endroit où un Pokémon d'espèce Fruitpalme a apparu le 25 octobre 2016 ?
SELECT latitude, longitude
FROM emplacement e, Apparition a, Pokemon p
WHERE e.id = a.idEmplacement
AND  a.idPokemon = p.id
AND LOWER(p.espece) = 'fruitpalme'
AND LOWER(a.horaire) = '2016-10-25'
;

-- q°13. Quels sont les pokémons meilleurs que ceux de l'équipe Jaune ?
SELECT P.nom
FROM Pokemon P
WHERE P.pointCombat > (SELECT MAX(P2.pointCombat)
							FROM Pokemon P2, Joueur J, Equipe e
                            WHERE e.id = J.idEquipe
                            AND P2.idJoueur = J.pseudonyme
                            AND LOWER(e.couleur) = 'jaune')
;

-- q°14. Combien de pokémons sont apparu dans l'arène EISTI ?
SELECT COUNT(DISTINCT a.idPokemon) nb_pokemon_apparus
FROM Apparition a, Arene ar
WHERE a.idEmplacement = ar.idEmplacement
AND UPPER(ar.nom) = 'EISTI'
;



