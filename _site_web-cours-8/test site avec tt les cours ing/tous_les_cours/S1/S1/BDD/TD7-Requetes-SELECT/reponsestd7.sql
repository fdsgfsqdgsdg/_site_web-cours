-- 1
SELECT nom, COUNT(a.idEmplacement) nbr
FROM pokemon p LEFT JOIN apparition a ON id = idPokemon
GROUP BY p.id
ORDER BY nbr DESC;

-- 2
SELECT nom, count(*) nbr
FROM pokemon p JOIN apparition a ON id = idPokemon
GROUP BY p.id
HAVING nbr > (SELECT AVG(nbrAp)
				FROM (SELECT count(idEmplacement) nbrAp
						FROM apparition RIGHT JOIN pokemon
                        ON id = idPokemon
                        GROUP BY id) tabTmp
                        );
-- 3
SELECT pseudonyme, sexe, niveau, count(p.id)
FROM pokemon p RIGHT JOIN joueur j ON p.idJoueur = j.pseudonyme
GROUP BY pseudonyme
ORDER BY count(p.id);

-- 4
SELECT nom
FROM pokemon p
WHERE NOT EXISTS (SELECT id
					FROM emplacement e
                    WHERE NOT EXISTS (SELECT *
										FROM apparition a
                                        WHERE p.id = a.idPokemon
                                        AND e.id = a.idEmplacement));
SELECT nom
FROM pokemon p, apparition a
WHERE p.id = a.idPokemon
GROUP BY p.id
HAVING COUNT(DISTINCT a.idEmplacement) = (SELECT COUNT(id) FROM emplacement);

-- 5
SELECT pseudonyme
FROM joueur j, pokemon p
WHERE j.pseudonyme = p.idJoueur
GROUP BY j.pseudonyme
HAVING COUNT(DISTINCT p.espece) = (SELECT COUNT(DISTINCT espece) FROM pokemon);

-- 6
SELECT COUNT(DISTINCT j.pseudonyme) AS NombreDeJoueurs
FROM joueur j
JOIN pokemon p ON j.pseudonyme = p.idJoueur
JOIN apparition a ON p.id = a.idPokemon
JOIN emplacement e ON a.idEmplacement = e.id
WHERE e.latitude = (SELECT MAX(latitude) FROM emplacement);

-- 7
SELECT e.id
FROM equipe e, defense d
WHERE e.id = d.idEquipe
GROUP BY e.id
HAVING COUNT(DISTINCT d.idArene) = (SELECT MAX(nbrAr)
									FROM(SELECT COUNT(DISTINCT d2.idArene) nbrAr
											FROM defense d2
                                            GROUP BY d2.idEquipe)tmpTab);



-- 8
select e.nom, MIN(horaire), max(horaire)
FROM pokemon p, apparition a, equipe e, joueur j
where p.id = a.idPokemon AND p.idJoueur = j.pseudonyme AND e.id = j.idEquipe
AND e.id IN (SELECT e.id
FROM equipe e, defense d
WHERE e.id = d.idEquipe
GROUP BY e.id
HAVING COUNT(DISTINCT d.idArene) = (SELECT MAX(nbrAr)
									FROM(SELECT COUNT(DISTINCT d2.idArene) nbrAr
											FROM defense d2
                                            GROUP BY d2.idEquipe)tmpTab))
GROUP BY e.id;

-- 10
SELECT nom
FROM pokemon p1
WHERE pointCombat > (SELECT AVG(pointCombat)
FROM pokemon p2
WHERE p1.idJoueur = p2.idJoueur);
