USE pokemons;
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
	FOREIGN KEY fk_jou_equipe(idEquipe) REFERENCES Equipe(id) ON DELETE CASCADE);
CREATE TABLE Pokemon(
	id INT PRIMARY KEY,
	nom VARCHAR(30),
	espece VARCHAR(20),
	pointCombat INT,
	idJoueur VARCHAR(30),
	FOREIGN KEY fk_poke_joueur(idJoueur) REFERENCES Joueur(pseudonyme),
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
	horaire DATE DEFAULT (CURRENT_DATE()),
	duree INT,
	CONSTRAINT pk_Apparition PRIMARY KEY (idPokemon, idEmplacement),
	FOREIGN KEY fk_app_pokemon(idPokemon) REFERENCES Pokemon(id),
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
	FOREIGN KEY fk_def_equipe(idEquipe) REFERENCES Equipe(id), 
	FOREIGN KEY fk_def_arene(idArene) REFERENCES Arene(id));
INSERT INTO Equipe VALUES (1, 'Intuition', 'Jaune');
INSERT INTO Equipe VALUES (2, 'Sagesse', 'Bleu');
INSERT INTO Equipe VALUES (3, 'Bravoure', 'Rouge');
INSERT INTO Joueur VALUES ('Shadow', 'Smith', 'F', 10, 1);
INSERT INTO Joueur VALUES ('Root', 'Alice', 'F', 20, 2);
INSERT INTO Joueur VALUES ('Admin', 'Bob', 'M', 1, 1);
INSERT INTO Joueur VALUES ('Flavius', 'Ruth', 'M', 20, 2);	
#INSERT INTO Joueur VALUES ('Asterix', 'Ruth', 'M', 5, 1); Ruth est déjà un personnage pris. Voulez vous prendre Ruth de Campagne.
INSERT INTO Pokemon VALUES (1, 'Bulbizarre', 'Graine', 1071, 'Shadow');
INSERT INTO Pokemon VALUES (25, 'Pikachu', 'Souris', 887, 'Root');
INSERT INTO Pokemon VALUES (107, 'Tygnon', 'Puncheur', 204, 'Shadow');
INSERT INTO Pokemon VALUES (103, 'Noadkoko', 'Fruitpalme', 190, 'Admin');
INSERT INTO Pokemon VALUES (150, 'Mewtwo', 'Génétique', 4144, 'Root');
INSERT INTO Pokemon VALUES (19, 'Rattata', 'Souris', 20, 'Admin');
#INSERT INTO Pokemon VALUES (39, 'Roundoudou', 'Bouboule', 4145, 'Moustache'); Le joueur n'existe pas. Le pokemon va donc être éliminé dans d'atroces souffrances ^^.
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
INSERT INTO Defense VALUES (3, 2, '2016-10-02');
#INSERT INTO Defense VALUES (2, 3); Pas de date, pas de prise. 
#DELETE FROM pokemons.Joueur WHERE pseudonyme = 'admin'; On ne peut pas supprimer le joueur car il a des pokemons associé


-- TD4 exercice 1


-- 5 : Mettre le niveau de tous les joueurs féminins à 15.
UPDATE Joueur 
SET niveau = 15 
WHERE sexe = 'F';

-- 6 : Supprimer les Pokémons dont l'espèce contient le mot "fruit".
DELETE 
FROM Pokemon
WHERE espece = 'fruit';


-- TD4 exercice 2


-- 1 : Quel est l'arène dont le nom contient le mot "eisti" ?
SELECT * 
FROM Arene 
WHERE nom = "eisti";

-- 2 : Quels sont les Pokémons dont le nom commence par la lettre p sans tenir compte de la casse ?
SELECT *
FROM Pokemon
WHERE nom LIKE 'P%';

-- 3 : Quels sont les pseudonymes des joueurs qui ne contiennent pas la lettre a ?
SELECT *
FROM Joueur
WHERE pseudonyme NOT LIKE '%a%' AND pseudonyme NOT LIKE 'A%';

-- 4 :  Trier les Pokémons selon le point de combat en ordre décroissant.
SELECT *
FROM Pokemon 
ORDER BY pointCombat 
DESC;

-- 5 :  Calculer la durée moyenne d'apparition des Pokémons.
SELECT 
AVG(duree) 
FROM Apparition;

-- 6 : Compter le nombre d'apparitions des Pokémons en octobre 2016.
SELECT 
COUNT(*)
FROM Apparition
WHERE horaire LIKE '%2016%';

-- 7 : Donner les noms des Pokémons qui sont de même espèce que Pikachu.
SELECT *
FROM Pokemon
WHERE espece = (
    SELECT espece
    FROM Pokemon
    WHERE nom = 'Pikachu'
);

-- 8 : Quels sont les joueurs dont le niveau est supérieur que le niveau moyen des joueurs ?
SELECT *
FROM Joueur
WHERE niveau > (
	SELECT 
    AVG(niveau) 
	FROM Joueur
);

-- 9 :  Quel est le Pokémon le plus fort ?
SELECT *
FROM Pokemon
WHERE pointCombat = (
	SELECT MAX(pointCombat)
    FROM Pokemon
);

-- 10 :  Augmenter de 2 le niveau de Shadow.
UPDATE Joueur
SET niveau = niveau + 2
WHERE pseudonyme = 'Shadow';


-- TD5


-- 1 : Quelle est la durée de l'apparition la plus récente du Pokémon ?
SELECT duree
FROM Apparition
WHERE horaire = (
	SELECT MAX(horaire)
    FROM Apparition
);

-- 2 : Donner les noms des Pokémons qui ont le même point de combat et le même maître que 'Pikachu'.
SELECT nom
FROM Pokemon
WHERE pointCombat = (
	SELECT pointCombat 
    FROM Pokemon 
    WHERE nom = 'Pikachu'
)
	AND idJoueur = (
		SELECT idJoueur 
        FROM Pokemon 
        WHERE nom = 'Pikachu'
	)
	AND nom != 'Pikachu';

-- 3 : Quel est le joueur dont le pseudonyme est plus long que tous les noms du personnage ?
SELECT *
FROM Joueur
-- La fonction pour obtenir la longueur en SQL est LENGTH()
WHERE LENGTH(pseudonyme) > (
	SELECT MAX(LENGTH(personnage))
    FROM Joueur
);

-- 4 : Quelles sont les dates où il y a à la foi l'apparition d'un Pokémon et la prise de contrôle d'une arène ?
SELECT dateControle
FROM Defense
UNION
SELECT horaire
FROM Apparition;

SELECT d.dateControle
FROM Defense d JOIN Apparition a ON d.dateControle=a.horaire;

SELECT j.pseudonyme
FROM Joueur j JOIN Defense d ON j.idEquipe = d.idEquipe
              JOIN Arene a ON d.idArene = a.id
              AND LOWER(a.nom) = "eisti";

-- 6 : Quels sont les joueurs dont le pseudonyme commence par la lettre A ou S et le personnage s'appelle pas Bob ?
SELECT *
FROM Joueur
WHERE (pseudonyme LIKE 'A%' OR pseudonyme LIKE 'S%') AND personnage != "Bob";

-- 7 : Quels sont les noms des Pokémons du joueur Admin ?
SELECT nom
FROM Pokemon
WHERE idJoueur = "Admin";

-- 8 : Quels sont les joueurs qui n'ont jamais eu des Pokémons de type souris ?
SELECT DISTINCT idJoueur
FROM Pokemon
WHERE lower(espece) != "Souris";

-- 9 : Quel est l'emplacement de l'arène EISTI ?
SELECT idEmplacement
FROM Arene
WHERE nom = "Eisti";

-- 10 : Quelle est l'équipe du joueur Shadow ?	
SELECT nom
FROM Equipe,Joueur
WHERE id = idEquipe 
	AND pseudonyme= "Shadow";

-- 11 : Quels sont les Pokémons qui n'ont pas encore apparu ?
SELECT nom
FROM Pokemon
WHERE id NOT IN (
	SELECT idPokemon
    FROM Apparition
);

-- 12 : Quel est la latitude et la longitude de l'endroit où un Pokémon d'espèce Fruitpalme a apparu le 25 octobre 2016 ?
SELECT latitude,longitude
FROM Emplacement e, Apparition, Pokemon p
WHERE e.id = idEmplacement
AND idPokemon = p.id
AND LOWER(espece) = "fruitpalme"
AND LOWER(horaire) = "2016-10-25";
    
-- 13 : Quels sont les pokémons meilleurs que ceux de l'équipe Jaune ?    
SELECT nom
FROM Pokemon 
WHERE pointCombat > (
	SELECT MAX(pointCombat)
    FROM Pokemon p, Joueur j, Equipe e
	WHERE p.idJoueur = j.pseudonyme
	AND j.idEquipe = e.id 
	AND LOWER(e.nom) != "jaune" 
);


-- TD6

-- 1 : Combien d'arènes l'équipe Intuition a pris le contrôle ?
SELECT COUNT(d.idArene)
FROM Defense d JOIN Equipe e ON e.id = d.idEquipe 
AND LOWER(nom) = "intuition";

-- 2 : Quelle est la date de la première apparition de Tygnon ?
SELECT MIN(a.horaire)
FROM Apparition a JOIN Pokemon p ON p.id = a.idPokemon
AND LOWER(p.nom) = "tygnon";

-- 3 : Quels sont les joueurs qui ont participé à la défense de l'arène EISTI ?
SELECT j.pseudonyme
FROM Joueur j JOIN Defense d ON j.idEquipe = d.idEquipe
              JOIN Arene a ON d.idArene = a.id
              AND LOWER(a.nom) = "eisti";

-- 4 : Compter le nombre de Pokémons de chaque joueur. Le pseudonyme dujoueur suffit dans la réponse.
SELECT COUNT(p.id),j.pseudonyme
FROM Joueur j LEFT JOIN Pokemon p ON j.pseudonyme = idJoueur
GROUP BY j.pseudonyme;

-- 5 : Quelle est la moyenne des points de combat de chaque espèce de Pokémon ?
SELECT espece, AVG(pointCombat) AS moyenneCombat
From Pokemon
GROUP BY espece;
 
-- 7 : Pour chaque Pokémon, donner le nom et la durée totale d'apparition.
SELECT p.nom, SUM(a.duree)
FROM Pokemon p, Apparition a
WHERE a.idPokemon = p.id
GROUP BY p.id,p.nom;

-- 8 :  Donner pour chaque arène son nom et la date de prise de contrôle la plus récente.
SELECT a.nom, MAX(d.dateControle)
FROM Arene a LEFT JOIN Defense d ON d.idArene = a.id
GROUP BY a.id,a.nom;

-- 9 : Pour chaque Pokémon, donner son nom, son espèce et le nombre d'apparitions. Nous sommes intéressés seulement aux Pokémons qui ont apparu au moins 2 fois
SELECT p.nom,p.espece,COUNT(a.idPokemon) AS nombreApparition
FROM Pokemon p JOIN Apparition a ON p.id = a.idPokemon
GROUP BY p.nom,p.espece
HAVING nombreApparition >= 2;

-- 10 : Pour chaque Pokémon, donner son nom, son espèce et le nombre d'apparitions dont la durée est supérieure à 5 minutes.
SELECT p.nom AS nom_pokemon,p.espece AS espece_pokemon, COUNT(a.idEmplacement) AS nombre_apparition
FROM Pokemon p JOIN Apparition a ON p.id = a.idPokemon
WHERE a.duree > 5
GROUP BY p.nom,p.espece;

-- 11 : Pour chaque pokémon de plus de 1000 points de combat, donner son nom, son espèce et la durée totale d'apparition. Nous sommes intéressés seulement aux pokémons qui ont apparu au moins 10 minutes
SELECT p.nom,p.espece, SUM(a.duree) AS duree_total_apparition
FROM Pokemon p JOIN Apparition a ON p.id = a.idPokemon
WHERE p.pointCombat > 1000
GROUP BY p.nom,p.espece,p.id
HAVING duree_total_apparition >= 10;

-- 12 : Donner le temps moyen d'apparition des pokémons appartenant aux joueurs de l'équipe ayant contrôlé le plus d'arène.
WITH req AS (
	SELECT e.id AS idEquipe, e.nom as nomEquipe, COUNT(a.id) AS nbrArene
	FROM Equipe e LEFT JOIN Defense d ON e.id = d.idEquipe
						JOIN Arene a ON a.id = d.idEquipe
	GROUP BY e.id
),
reqMax AS(
	SELECT MAX(nbrArene) AS MaxNbrArene
    FROM req
)
SELECT j.pseudonyme,p.nom,nomEquipe,AVG(a.duree)
FROM reqMax,Apparition a,Joueur j JOIN Pokemon p ON j.pseudonyme = p.idJoueur
									JOIN req r ON r.idEquipe = j.idEquipe
WHERE nbrArene = MaxNbrArene
GROUP BY j.pseudonyme,p.nom,nomEquipe;


-- TD7


-- 1 : Classez les pokémons en fonction du nombre d'apparitions. Nous sommes intéressés par les Pokémons qui n'ont pas encore apparu également (dont le nombre d'apparition vaut 0).
SELECT p.id,p.nom,p.espece,COUNT(a.idPokemon) AS nombreApparition
FROM Pokemon p LEFT JOIN Apparition a ON a.idPokemon = p.id
GROUP BY p.id
ORDER BY nombreApparition DESC;

-- 2 : Quels sont les pokémons dont le nombre d'apparitions est supérieur au nombre moyen d'apparitions ?
SELECT AVG(Sub.NbApparitions) AS AVGNbApparitions
FROM (
	SELECT p.nom,COUNT(a.idPokemon) AS NbApparitions
    FROM Pokemon p LEFT JOIN Apparition a ON p.id = a.idPokemon
    GROUP BY p.nom
    ORDER BY NbApparitions DESC
) AS Sub;

WITH req1 AS (
	SELECT p.id AS idPoke, p.nom AS nomPoke, COUNT(a.idPokemon) AS NbApparitions
    FROM Pokemon p LEFT JOIN Apparition a ON p.id = a.idPokemon
    GROUP BY p.id, p.nom
),
req2 AS (
	SELECT AVG(NbApparitions) AS AVGNbApparitions
    FROM req1
)
SELECT idPoke, nomPoke, NbApparitions
FROM req1, req2
WHERE NbApparitions > AVGNbApparitions;

-- 3 : On veut obtenir le pseudonyme, le sexe, le niveau et le nombre de pokémons de tous les joueurs, y compris ceux qui n'ont capturé aucun Pokémon. Triez votre résultat.
SELECT j.pseudonyme, j.sexe, j.niveau, COUNT(p.id) AS NbPokemon
FROM Joueur j LEFT JOIN Pokemon p ON j.pseudonyme = p.idJoueur
GROUP BY j.pseudonyme, j.sexe, j.niveau
ORDER BY NbPokemon DESC;

-- 4 :  Quels sont les pokémons qui ont apparu dans tous les emplacements différents ?
SELECT nom
FROM Pokemon p INNER JOIN Apparition a ON p.id = a.idPokemon
GROUP BY p.id
HAVING COUNT(DISTINCT a.idEmplacement) = (SELECT COUNT(e.id) FROM Emplacement e);

-- 5. Quels sont les joueurs qui ont capturé toutes les espèces de pokémon ?
SELECT j.pseudonyme
FROM Joueur j
JOIN Pokemon p ON j.pseudonyme = p.idJoueur
GROUP BY j.pseudonyme
HAVING COUNT(DISTINCT p.espece) = (SELECT COUNT(DISTINCT espece) FROM Pokemon);

-- 6. Combien de joueurs possèdent des pokémons qui sont placés dans l'emplacement avec la latitude la plus septentrionale (la plus haute) ?
SELECT COUNT(DISTINCT j.pseudonyme) AS nb_joueurs
FROM Joueur j
JOIN Pokemon p ON j.pseudonyme = p.idJoueur
JOIN Apparition a ON p.id = a.idPokemon
JOIN Emplacement e ON a.idEmplacement = e.id
WHERE e.latitude = (SELECT MAX(latitude) FROM Emplacement);

-- 7. Quelle est l'équipe qui a pris le contrôle d'une arène plus souvent ?
	SELECT eq.nom, COUNT(d.idArene) AS nb_controles
FROM Equipe eq
JOIN Defense d ON eq.id = d.idEquipe
GROUP BY eq.nom
ORDER BY nb_controles DESC
LIMIT 1;

-- 8. Quelle est la plage des dates auxquelles les pokémons de l'équipe de la question précédente ont apparu ?
SELECT MIN(a.horaire) AS date_debut, MAX(a.horaire) AS date_fin
FROM Apparition a
JOIN Pokemon p ON a.idPokemon = p.id
JOIN Joueur j ON p.idJoueur = j.pseudonyme
JOIN Equipe e ON j.idEquipe = e.id
WHERE e.nom = (SELECT eq.nom
               FROM Equipe eq
               JOIN Defense d ON eq.id = d.idEquipe
               GROUP BY eq.nom
               ORDER BY COUNT(d.idArene) DESC
               LIMIT 1);

-- 9. Affichez les joueurs dont le niveau est le plus élevé de leur équipe.
SELECT j.pseudonyme, j.niveau, e.nom AS equipe
FROM Joueur j
JOIN Equipe e ON j.idEquipe = e.id
WHERE j.niveau = (SELECT MAX(j2.niveau)
                  FROM Joueur j2
                  WHERE j2.idEquipe = e.id);

-- 10. Affichez les noms des pokémons dont les points de combat sont supérieur à la moyenne de ceux de leur joueur.
SELECT p.nom
FROM Pokemon p
JOIN Joueur j ON p.idJoueur = j.pseudonyme
WHERE p.pointCombat > (SELECT AVG(p2.pointCombat)
                       FROM Pokemon p2
                       WHERE p2.idJoueur = j.pseudonyme);
