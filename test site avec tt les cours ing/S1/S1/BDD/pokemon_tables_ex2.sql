DROP DATABASE IF EXISTS Pokemons_v2; -- supprimer la base seulement si elle existe avant
CREATE DATABASE Pokemons_v2;
USE Pokemons_v2; -- se connecter à la base

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
	FOREIGN KEY fk_equipe(idEquipe) REFERENCES Equipe(id) ON DELETE CASCADE);

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
	horaire DATE DEFAULT (current_date()), -- fonction date par défaut entre parenthèses  (une fonction)
	duree INT,
	CONSTRAINT pk_Apparition PRIMARY KEY (idPokemon, idEmplacement),
	FOREIGN KEY fk_pokemon(idPokemon) REFERENCES Pokemon(id),
	FOREIGN KEY fk_app_emplacement(idEmplacement) REFERENCES Emplacement(id));

INSERT INTO Equipe VALUES (1, 'Bravoure', 'Rouge') ;
INSERT INTO Equipe VALUES (2, 'Sagesse', 'Bleue') ;
INSERT INTO Equipe VALUES (2, 'Intuition', 'Jaune'); -- il est normal que cette requête ne marche pas car possède le même id que l'équipe sagesse
