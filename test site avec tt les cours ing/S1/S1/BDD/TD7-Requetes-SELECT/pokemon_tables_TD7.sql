DROP DATABASE IF EXISTS Pokemons_TD7; -- supprimer la base seulement si elle existe avant
CREATE DATABASE Pokemons_TD7;
USE Pokemons_TD7; -- se connecter à la base

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



-- q1. Classez les Pokémons en fonction de nombre d'apparitions. Nous sommes intéressés aux Pokémons qui n'ont pas encore apparu également 
-- (dont le nombre d'apparition vaut 0).
SELECT p.nom, COUNT(a.idPokemon) as NbApparition
FROM Pokemon p LEFT JOIN Apparition a ON p.id = a.idPokemon
GROUP BY p.nom
ORDER BY NbApparition DESC;

-- q2. Quels sont les Pokémons dont le nombre d'apparitions est supérieur au nombre moyen d'apparitions ?
SELECT nom, COUNT(idPokemon) as NbApparition
FROM Pokemon JOIN Apparition ON id = idPokemon
GROUP BY nom
HAVING NbApparition > (SELECT AVG(cntPokemon)
							FROM (SELECT COUNT(idPokemon) as cntPokemon
									FROM Pokemon LEFT JOIN Apparition ON id = idPokemon
                                    GROUP BY id -- si GROUP BY idPokemon on aura un seul 0 pour tous les pokemons qui ne sont pas apparus
                                    ) as avgTable
								)
ORDER BY NbApparition DESC
;

-- q3. On veut obtenir le pseudonyme, le sexe, le niveau et le nombre de Pokémons de tous les joueurs, y compris ceux qui n'ont capturé aucun Pokémon. Triez votre résultat.
SELECT j.pseudonyme, j.sexe, j.niveau, COUNT(p.id) as NbPokemon
FROM Joueur j LEFT JOIN Pokemon p ON j.pseudonyme = p.idJoueur
GROUP BY j.pseudonyme, j.sexe, j.niveau
ORDER BY NbPokemon DESC
;


-- q4. Quels sont les Pokémons qui ont apparu dans tous les emplacements différents ?
SELECT id, COUNT(DISTINCT idEmplacement) as NbEmplacement
FROM Pokemon INNER JOIN Apparition ON id = idPokemon
			-- INNER JOIN emplacement ON emplacement.id = Apparition.idEmplacement
GROUP BY id
HAVING NbEmplacement = (SELECT COUNT(id) FROM emplacement)
;

-- autre correction possible
SELECT nom
FROM pokemon p, apparition a
WHERE p.id = a.idPokemon
GROUP BY p.id
HAVING COUNT(DISTINCT a.idEmplacement) = (SELECT COUNT(id) FROM emplacement);



-- q5. Quels sont les joueurs qui ont capturé toutes les espèces de Pokémon ?
SELECT pseudonyme
FROM Joueur, Pokemon
WHERE pseudonyme = idJoueur
GROUP BY pseudonyme
HAVING COUNT(DISTINCT espece) = (SELECT COUNT(DISTINCT espece) FROM Pokemon) -- pas distinct count car count renvoie une valeur unique
;


-- q6. Combien de joueurs possèdent des Pokémons qui sont placés dans l'emplacement avec la latitude la plus septentrionale (la plus haute) ?
SELECT COUNT(idJoueur) NbJoueur
FROM Pokemon p, apparition, emplacement e
WHERE p.id = idPokemon
AND e.id = idEmplacement
AND latitude = (SELECT MAX(latitude) FROM emplacement)
;

-- autre correction
SELECT COUNT(DISTINCT j.pseudonyme) AS NbJoueurs
FROM joueur j
JOIN pokemon p ON j.pseudonyme = p.idJoueur
JOIN apparition a ON p.id = a.idPokemon
JOIN emplacement e ON a.idEmplacement = e.id
WHERE e.latitude = (SELECT MAX(latitude) FROM emplacement)
;


-- q7. Quelle est l'équipe qui a pris le contrôle d'une arène plus souvent ?
SELECT id, e.nom
FROM Equipe e, Defense d
WHERE e.id = d.idEquipe
GROUP BY id, e.nom
HAVING COUNT(idArene) = (SELECT MAX(controle)
								FROM (SELECT COUNT(idArene) controle
										FROM Defense
                                        GROUP BY idEquipe
									) DefCount
							)
;

-- autre correction
SELECT e.id
FROM equipe e, defense d
WHERE e.id = d.idEquipe
GROUP BY e.id
HAVING COUNT(DISTINCT d.idArene) = (SELECT MAX(nbrAr)
									FROM(SELECT COUNT(DISTINCT d2.idArene) nbrAr
											FROM defense d2
                                            GROUP BY d2.idEquipe
										) tmpTab
									)
;

-- q8. Quelle est la plage des dates auxquelles les Pokémons de l'équipe de la question précédente ont apparu ?
SELECT MIN(horaire), MAX(horaire)
FROM pokemon p, apparition a, joueur j
WHERE idJoueur = pseudonyme
AND idPokemon = p.id
AND idEquipe IN (SELECT e.id
					FROM equipe e, defense d
					WHERE e.id = d.idEquipe
					GROUP BY e.id
					HAVING COUNT(DISTINCT d.idArene) = (SELECT MAX(nbrAr)
														FROM(SELECT COUNT(DISTINCT d2.idArene) nbrAr
																FROM defense d2
																GROUP BY d2.idEquipe
															)tmpTab
														)
				)
GROUP BY idEquipe
;


-- q9. Affichez les joueurs dont le niveau est le plus élevé de leur équipe.
SELECT pseudonyme -- , niveau as lvl, idEquipe
FROM Joueur, (SELECT idEquipe eqMax, MAX(niveau) lvlmax
				FROM Joueur, Equipe
				WHERE id = idEquipe
                GROUP BY idEquipe) as MaxTable
WHERE eqMax = idEquipe
AND niveau = lvlmax
;

-- q10. Affichez les noms des pokémons dont les points de combat sont supérieur à la moyenne de ceux de leur joueur.
SELECT idJoueur, nom
FROM pokemon p1
WHERE pointCombat > (SELECT AVG(pointCombat)
						FROM pokemon p2
						WHERE p1.idJoueur = p2.idJoueur
					)
GROUP BY idJoueur
;





