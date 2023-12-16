/*
Chabran, Vincent 
*/


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE emprunts';
    EXECUTE IMMEDIATE 'DROP TABLE adherents';
    EXECUTE IMMEDIATE 'DROP TABLE livres';
    EXECUTE IMMEDIATE 'DROP TABLE bibliotheques';
    EXECUTE IMMEDIATE 'DROP TABLE villes';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_emprunt';
    EXECUTE IMMEDIATE 'DROP TYPE t_adherent';
    EXECUTE IMMEDIATE 'DROP TYPE t_livre';
    EXECUTE IMMEDIATE 'DROP TYPE t_bibliotheque';
    EXECUTE IMMEDIATE 'DROP TYPE t_ville';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4043 THEN
            RAISE;
        END IF;
END;
/



-- 2.1 Création des types à partir du schéma de types

CREATE OR REPLACE TYPE t_ville AS OBJECT (
    id_ville NUMBER,
    nom VARCHAR2(100),
    STATIC FUNCTION create_ville (id NUMBER, nom VARCHAR2) RETURN t_ville,
    MEMBER PROCEDURE update_ville (newNom VARCHAR2),
    STATIC PROCEDURE delete_ville (id NUMBER),
    MEMBER FUNCTION count_bibliotheques RETURN NUMBER,
    MEMBER FUNCTION list_bibliotheques RETURN SYS_REFCURSOR,
    STATIC FUNCTION list_villes_ordered RETURN SYS_REFCURSOR
);
/


CREATE OR REPLACE TYPE t_bibliotheque AS OBJECT (
    id_bibliotheque NUMBER,
    ville_ref REF t_ville,
    nom VARCHAR2(100),
    adresse VARCHAR2(200),
    STATIC FUNCTION create_bibliotheque (id NUMBER, ville_id NUMBER, nom VARCHAR2, adresse VARCHAR2) RETURN t_bibliotheque,
    MEMBER PROCEDURE update_bibliotheque (newNom VARCHAR2, newAdresse VARCHAR2),
    STATIC PROCEDURE delete_bibliotheque (id NUMBER),
    MEMBER FUNCTION count_livres RETURN NUMBER,
    MEMBER FUNCTION list_livres RETURN SYS_REFCURSOR,
    STATIC FUNCTION list_bibliotheques_ordered RETURN SYS_REFCURSOR
);
/


CREATE OR REPLACE TYPE t_livre AS OBJECT (
    id_livre VARCHAR2(50),
    bibliotheque_ref REF t_bibliotheque,
    titre VARCHAR2(100),
    auteur VARCHAR2(100),
    genre VARCHAR2(50),
    STATIC FUNCTION create_livre (id VARCHAR2, bibliotheque_id NUMBER, titre VARCHAR2, auteur VARCHAR2, genre VARCHAR2) RETURN t_livre,
    MEMBER PROCEDURE update_livre (newTitre VARCHAR2, newAuteur VARCHAR2, newGenre VARCHAR2),
    STATIC PROCEDURE delete_livre (id VARCHAR2),
    MEMBER FUNCTION count_emprunts RETURN NUMBER,
    MEMBER FUNCTION list_adherents_emprunteurs RETURN SYS_REFCURSOR,
    STATIC FUNCTION list_livres_ordered RETURN SYS_REFCURSOR
);
/


CREATE OR REPLACE TYPE t_adherent AS OBJECT (
    id_adherent NUMBER,
    bibliotheque_ref REF t_bibliotheque,
    nom VARCHAR2(100),
    prenom VARCHAR2(100),
    STATIC FUNCTION create_adherent (id NUMBER, bibliotheque_id NUMBER, nom VARCHAR2, prenom VARCHAR2) RETURN t_adherent,
    MEMBER PROCEDURE update_adherent (newNom VARCHAR2, newPrenom VARCHAR2),
    STATIC PROCEDURE delete_adherent (id NUMBER),
    MEMBER FUNCTION count_emprunts RETURN NUMBER,
    MEMBER FUNCTION list_livres_empruntes RETURN SYS_REFCURSOR,
    STATIC FUNCTION list_adherents_ordered RETURN SYS_REFCURSOR
);
/


CREATE OR REPLACE TYPE t_emprunt AS OBJECT (
    id_emprunt NUMBER,
    livre_ref REF t_livre,
    adherent_ref REF t_adherent,
    date_emprunt DATE,
    date_retour DATE,
    STATIC FUNCTION create_emprunt (id NUMBER, livre_id VARCHAR2, adherent_id NUMBER, date_emprunt DATE, date_retour DATE) RETURN t_emprunt,
    MEMBER PROCEDURE update_emprunt (newDateEmprunt DATE, newDateRetour DATE),
    STATIC PROCEDURE delete_emprunt (id NUMBER),
    MEMBER FUNCTION is_overdue RETURN BOOLEAN,
    MEMBER FUNCTION duration_days RETURN NUMBER,
    STATIC FUNCTION list_emprunts_ordered RETURN SYS_REFCURSOR
);
/



-- 2.2 Création des tables objets et des indexes à partir des types créés auparavant


CREATE TABLE villes OF t_ville (
    id_ville PRIMARY KEY,
    nom CONSTRAINT nnl_ville_nom NOT NULL
) OBJECT IDENTIFIER IS PRIMARY KEY;
CREATE UNIQUE INDEX idx_unique_nom ON villes(nom);


CREATE TABLE bibliotheques OF t_bibliotheque (
    id_bibliotheque PRIMARY KEY,
    nom CONSTRAINT nnl_bibliotheques_nom NOT NULL
) OBJECT IDENTIFIER IS PRIMARY KEY;
ALTER TABLE bibliotheques ADD SCOPE FOR (ville_ref) IS villes;
CREATE INDEX idx_nom_bibliotheques ON bibliotheques(nom);


CREATE TABLE livres OF t_livre (
    id_livre PRIMARY KEY,
    titre CONSTRAINT nnl_livres_titre NOT NULL,
    auteur CONSTRAINT nnl_livres_auteur NOT NULL
) OBJECT IDENTIFIER IS PRIMARY KEY;
ALTER TABLE livres ADD SCOPE FOR (bibliotheque_ref) IS bibliotheques;
CREATE UNIQUE INDEX idx_titre_livres ON livres(titre);
CREATE INDEX idx_auteur_livres ON livres(auteur);


CREATE TABLE adherents OF t_adherent (
    id_adherent PRIMARY KEY,
    nom CONSTRAINT nnl_adherents_nom NOT NULL
) OBJECT IDENTIFIER IS PRIMARY KEY;
ALTER TABLE adherents ADD SCOPE FOR (bibliotheque_ref) IS bibliotheques;
CREATE INDEX idx_nom_adherents ON adherents(nom);


CREATE TABLE emprunts OF t_emprunt (
    id_emprunt PRIMARY KEY,
    date_emprunt CONSTRAINT nnl_adherents_date_emprunt NOT NULL,
    date_retour CONSTRAINT nnl_adherents_date_retour NOT NULL
) OBJECT IDENTIFIER IS PRIMARY KEY;
ALTER TABLE emprunts ADD SCOPE FOR (livre_ref) IS livres;
ALTER TABLE emprunts ADD SCOPE FOR (adherent_ref) IS adherents;



-- 2.3 Insertion des lignes dans vos tables objets

BEGIN
    INSERT INTO villes VALUES (1001, 'Paris');
    INSERT INTO villes VALUES (1002, 'Marseille');
    INSERT INTO villes VALUES (1003, 'Lyon');
    INSERT INTO villes VALUES (1004, 'Toulouse');
    INSERT INTO villes VALUES (1005, 'Nice');
    INSERT INTO villes VALUES (1006, 'Nantes');
    INSERT INTO villes VALUES (1007, 'Strasbourg');
    INSERT INTO villes VALUES (1008, 'Montpellier');
    INSERT INTO villes VALUES (1009, 'Bordeaux');
    INSERT INTO villes VALUES (1010, 'Lille');
    INSERT INTO villes VALUES (1011, 'Ajaccio');
    INSERT INTO villes VALUES (1012, 'Bastia');
    INSERT INTO villes VALUES (1013, 'Corte');
END;
/

BEGIN
    FOR i IN 1..20 LOOP
        INSERT INTO bibliotheques VALUES (2000 + i, (SELECT REF(v) FROM villes v WHERE v.id_ville = 1000 + i), 'Bibliotheque ' || LPAD(i, 2, '0'), 'Adresse ' || i);
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..20 LOOP
        INSERT INTO livres VALUES ('L' || LPAD(i, 3, '0'), (SELECT REF(b) FROM bibliotheques b WHERE b.id_bibliotheque = 2000 + i), 'Livre ' || LPAD(i, 2, '0'), 'Auteur ' || i, 'Genre ' || i);
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..20 LOOP
        INSERT INTO adherents VALUES (3000 + i, (SELECT REF(b) FROM bibliotheques b WHERE b.id_bibliotheque = 2000 + i), 'Nom ' || LPAD(i, 2, '0'), 'Prenom ' || LPAD(i, 2, '0'));
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..20 LOOP
        INSERT INTO emprunts VALUES (4000 + i, (SELECT REF(l) FROM livres l WHERE l.id_livre = 'L' || LPAD(i, 3, '0')), (SELECT REF(a) FROM adherents a WHERE a.id_adherent = 3000 + i), SYSDATE - i, SYSDATE + i);
    END LOOP;
END;
/


SET SERVEROUTPUT ON;



-- 2.4 Mise à jour et consultation des données dans vos tables objets


-- Requêtes de mise à jour
-- 1 Table
UPDATE livres SET genre = 'Fantaisie' WHERE id_livre = 'L001';
UPDATE bibliotheques SET adresse = '123 Rue Nouvelle' WHERE id_bibliotheque = 2001;
-- 2 Tables
INSERT INTO livres (id_livre, bibliotheque_ref, titre, auteur, genre)
VALUES ('L021', (SELECT REF(b) FROM bibliotheques b WHERE b.id_bibliotheque = 2002), 'Nouveau Livre', 'Nouvel Auteur', 'Science-Fiction');
INSERT INTO emprunts (id_emprunt, livre_ref, adherent_ref, date_emprunt, date_retour)
VALUES (4021, (SELECT REF(l) FROM livres l WHERE l.id_livre = 'L020'), (SELECT REF(a) FROM adherents a WHERE a.id_adherent = 3020), SYSDATE, SYSDATE + 30);
-- Plus de 2 tables
BEGIN
    UPDATE livres SET bibliotheque_ref = (SELECT REF(b) FROM bibliotheques b WHERE b.id_bibliotheque = 2003) WHERE id_livre = 'L005';
END;
/
BEGIN
    UPDATE adherents SET nom = 'Nom Mis à Jour' WHERE id_adherent = 3005;
    UPDATE emprunts SET date_retour = SYSDATE + 30 WHERE adherent_ref = (SELECT REF(a) FROM adherents a WHERE a.id_adherent = 3005);
END;
/


-- Requêtes de suppression 
-- 1 table
DELETE FROM livres WHERE id_livre = 'L002';
DELETE FROM adherents WHERE id_adherent = 3002;
-- 2 tables
BEGIN
    DELETE FROM emprunts WHERE livre_ref = (SELECT REF(l) FROM livres l WHERE l.id_livre = 'L003');
    DELETE FROM livres WHERE id_livre = 'L003';
END;
/
BEGIN
    DELETE FROM adherents WHERE bibliotheque_ref = (SELECT REF(b) FROM bibliotheques b WHERE b.id_bibliotheque = 2003);
    DELETE FROM bibliotheques WHERE id_bibliotheque = 2003;
END;
/
-- Plus de 2 tables
BEGIN
    DELETE FROM livres l WHERE l.bibliotheque_ref IN (SELECT REF(b) FROM bibliotheques b WHERE b.ville_ref = (SELECT REF(v) FROM villes v WHERE v.id_ville = 1003));
    DELETE FROM bibliotheques WHERE ville_ref = (SELECT REF(v) FROM villes v WHERE v.id_ville = 1003);
    DELETE FROM villes WHERE id_ville = 1003;
END;
/
BEGIN
    DELETE FROM emprunts WHERE adherent_ref = (SELECT REF(a) FROM adherents a WHERE a.id_adherent = 3003);
    DELETE FROM adherents WHERE id_adherent = 3003;
END;
/


-- Requêtes de consultation
-- 1 Table
SELECT * 
    FROM bibliotheques;
SELECT b.id_bibliotheque, COUNT(*) AS nombre_de_livres 
    FROM livres l
    JOIN bibliotheques b ON l.bibliotheque_ref = REF(b)
    GROUP BY b.id_bibliotheque;
SELECT * 
    FROM bibliotheques
    ORDER BY nom;
SELECT *
    FROM livres l
    WHERE l.auteur = 'Auteur 10';
SELECT * 
    FROM livres
    ORDER BY titre;

-- 2 Tables
SELECT e.id_emprunt, a.nom AS nom_adherent, l.titre AS titre_livre, b.nom AS nom_bibliotheque
    FROM emprunts e
    JOIN adherents a ON e.adherent_ref = REF(a)
    JOIN livres l ON e.livre_ref = REF(l)
    JOIN bibliotheques b ON l.bibliotheque_ref = REF(b);
SELECT b.nom, COUNT(*) AS nombre_emprunts
    FROM emprunts e
    JOIN livres l ON e.livre_ref = REF(l)
    JOIN bibliotheques b ON l.bibliotheque_ref = REF(b)
    GROUP BY b.nom;
SELECT a.nom AS nom_adherent, l.titre AS titre_livre, b.nom AS nom_bibliotheque
    FROM emprunts e
    JOIN adherents a ON e.adherent_ref = REF(a)
    JOIN livres l ON e.livre_ref = REF(l)
    JOIN bibliotheques b ON l.bibliotheque_ref = REF(b)
    ORDER BY a.nom;
SELECT a.id_adherent, a.nom, COUNT(*) AS nombre_emprunts
    FROM emprunts e
    JOIN adherents a ON e.adherent_ref = REF(a)
    GROUP BY a.id_adherent, a.nom
    HAVING COUNT(*) > 5;
SELECT b.nom AS nom_bibliotheque, COUNT(*) AS nombre_livres_empruntes
    FROM bibliotheques b
    JOIN livres l ON l.bibliotheque_ref = REF(b)
    JOIN emprunts e ON e.livre_ref = REF(l)
    GROUP BY b.nom;

-- plus de 2 tables
SELECT a.nom AS nom_adherent, b.nom AS nom_bibliotheque, COUNT(*) AS nombre_livres_empruntes
    FROM adherents a
    LEFT JOIN emprunts e ON e.adherent_ref = REF(a)
    LEFT JOIN livres l ON e.livre_ref = REF(l)
    LEFT JOIN bibliotheques b ON l.bibliotheque_ref = REF(b)
    GROUP BY a.nom, b.nom
    ORDER BY nombre_livres_empruntes DESC;
SELECT l.genre, l.titre, COUNT(e.id_emprunt) AS nombre_emprunts
    FROM livres l
    JOIN emprunts e ON e.livre_ref = REF(l)
    GROUP BY l.genre, l.titre
    ORDER BY l.genre, nombre_emprunts DESC;
SELECT a.nom, COUNT(*) AS nombre_emprunts_sf
    FROM emprunts e
    JOIN adherents a ON e.adherent_ref = REF(a)
    JOIN livres l ON e.livre_ref = REF(l)
    WHERE l.genre = 'Science-Fiction'
    GROUP BY a.nom
    HAVING COUNT(*) >= 5
    ORDER BY a.nom;
SELECT b.nom AS nom_bibliotheque, TO_CHAR(e.date_emprunt, 'Day') AS jour, COUNT(*) AS nombre_emprunts
    FROM emprunts e
    JOIN livres l ON e.livre_ref = REF(l)
    JOIN bibliotheques b ON l.bibliotheque_ref = REF(b)
    GROUP BY b.nom, TO_CHAR(e.date_emprunt, 'Day')
    ORDER BY b.nom, nombre_emprunts DESC;
SELECT b.nom AS nom_bibliotheque, l.genre, COUNT(l.id_livre) AS total_livres_empruntes_par_genre
    FROM bibliotheques b
    JOIN livres l ON l.bibliotheque_ref = REF(b)
    JOIN emprunts e ON e.livre_ref = REF(l)
    GROUP BY b.nom, l.genre
    ORDER BY b.nom, total_livres_empruntes_par_genre DESC;



-- 2.5 Implémentation des méthodes de vos types en PLSQL

CREATE OR REPLACE TYPE BODY t_ville AS 
    STATIC FUNCTION create_ville(id NUMBER, nom VARCHAR2) RETURN t_ville IS
        new_ville t_ville;
    BEGIN
        INSERT INTO villes (id_ville, nom) VALUES (id, nom);
        new_ville := NEW t_ville(id, nom);
        RETURN new_ville;
    END create_ville;

  
    MEMBER PROCEDURE update_ville(newNom VARCHAR2) IS
    BEGIN
        UPDATE villes v SET v.nom = newNom WHERE v.id_ville = SELF.id_ville;
    END update_ville;


    STATIC PROCEDURE delete_ville(id NUMBER) IS
    BEGIN
        DELETE FROM villes v WHERE v.id_ville = id;
    END delete_ville;


    MEMBER FUNCTION count_bibliotheques RETURN NUMBER IS
        cnt NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO cnt
        FROM bibliotheques
        WHERE ville_ref = (SELECT REF(v) FROM villes v WHERE v.id_ville = SELF.id_ville);
        RETURN cnt;
    END count_bibliotheques;

    MEMBER FUNCTION list_bibliotheques RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
        SELECT b.nom
        FROM bibliotheques b
        WHERE b.ville_ref = (SELECT REF(v) FROM villes v WHERE v.id_ville = SELF.id_ville);
        RETURN rc;
    END list_bibliotheques;

    STATIC FUNCTION list_villes_ordered RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
            SELECT v.nom
            FROM villes v
            ORDER BY v.nom;
        RETURN rc;
    END list_villes_ordered;
END;
/


CREATE OR REPLACE TYPE BODY t_bibliotheque AS 
    STATIC FUNCTION create_bibliotheque(id NUMBER, ville_id NUMBER, nom VARCHAR2, adresse VARCHAR2) RETURN t_bibliotheque IS
        ville_ref REF t_ville;
        new_bibliotheque t_bibliotheque;
    BEGIN
        SELECT REF(v) INTO ville_ref 
            FROM villes v WHERE v.id_ville = ville_id;

        INSERT INTO bibliotheques (id_bibliotheque, ville_ref, nom, adresse)
            VALUES (id, ville_ref, nom, adresse);

        new_bibliotheque := NEW t_bibliotheque(id, ville_ref, nom, adresse);
        RETURN new_bibliotheque;
    END create_bibliotheque;


    MEMBER PROCEDURE update_bibliotheque(newNom VARCHAR2, newAdresse VARCHAR2) IS
    BEGIN
        UPDATE bibliotheques b SET b.nom = newNom, b.adresse = newAdresse WHERE b.id_bibliotheque = SELF.id_bibliotheque;
    END update_bibliotheque;


    STATIC PROCEDURE delete_bibliotheque(id NUMBER) IS
    BEGIN
        DELETE FROM bibliotheques WHERE id_bibliotheque = id;
    END delete_bibliotheque;


    MEMBER FUNCTION count_livres RETURN NUMBER IS
        cnt NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO cnt
        FROM livres
        WHERE bibliotheque_ref = (SELECT REF(b) FROM bibliotheques b WHERE b.id_bibliotheque = SELF.id_bibliotheque);
        RETURN cnt;
    END count_livres;

    MEMBER FUNCTION list_livres RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
        SELECT l.titre
        FROM livres l
        WHERE l.bibliotheque_ref = (SELECT REF(b) FROM bibliotheques b WHERE b.id_bibliotheque = SELF.id_bibliotheque);
        RETURN rc;
    END list_livres;

    STATIC FUNCTION list_bibliotheques_ordered RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
            SELECT b.nom
            FROM bibliotheques b
            ORDER BY b.nom;
        RETURN rc;
    END list_bibliotheques_ordered;
END;
/


CREATE OR REPLACE TYPE BODY t_livre AS 
    STATIC FUNCTION create_livre(id VARCHAR2, bibliotheque_id NUMBER, titre VARCHAR2, auteur VARCHAR2, genre VARCHAR2) RETURN t_livre IS
        bibliotheque_ref REF t_bibliotheque;
        new_livre t_livre;
    BEGIN
        SELECT REF(b) INTO bibliotheque_ref 
            FROM bibliotheques b WHERE b.id_bibliotheque = bibliotheque_id;

        INSERT INTO livres (id_livre, bibliotheque_ref, titre, auteur, genre)
            VALUES (id, bibliotheque_ref, titre, auteur, genre);

        new_livre := NEW t_livre(id, bibliotheque_ref, titre, auteur, genre);
        RETURN new_livre;
    END create_livre;


    MEMBER PROCEDURE update_livre(newTitre VARCHAR2, newAuteur VARCHAR2, newGenre VARCHAR2) IS
    BEGIN
        UPDATE livres l SET l.titre = newTitre, l.auteur = newAuteur, l.genre = newGenre WHERE l.id_livre = SELF.id_livre;
    END update_livre;


    STATIC PROCEDURE delete_livre(id VARCHAR2) IS
    BEGIN
        DELETE FROM livres WHERE id_livre = id;
    END delete_livre;

    MEMBER FUNCTION count_emprunts RETURN NUMBER IS
        cnt NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO cnt
        FROM emprunts
        WHERE livre_ref = (SELECT REF(l) FROM livres l WHERE l.id_livre = SELF.id_livre);
        RETURN cnt;
    END count_emprunts;

    MEMBER FUNCTION list_adherents_emprunteurs RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
        SELECT a.nom, a.prenom
        FROM emprunts e, adherents a
        WHERE e.livre_ref = (SELECT REF(l) FROM livres l WHERE l.id_livre = SELF.id_livre)
        AND e.adherent_ref = REF(a);
        RETURN rc;
    END list_adherents_emprunteurs;

    STATIC FUNCTION list_livres_ordered RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
            SELECT l.titre
            FROM livres l
            ORDER BY l.titre;
        RETURN rc;
    END list_livres_ordered;
END;
/


CREATE OR REPLACE TYPE BODY t_adherent AS 
    STATIC FUNCTION create_adherent(id NUMBER, bibliotheque_id NUMBER, nom VARCHAR2, prenom VARCHAR2) RETURN t_adherent IS
        bibliotheque_ref REF t_bibliotheque;
        new_adherent t_adherent;
    BEGIN
        SELECT REF(b) INTO bibliotheque_ref 
            FROM bibliotheques b WHERE b.id_bibliotheque = bibliotheque_id;

        INSERT INTO adherents (id_adherent, bibliotheque_ref, nom, prenom)
            VALUES (id, bibliotheque_ref, nom, prenom);

        new_adherent := NEW t_adherent(id, bibliotheque_ref, nom, prenom);
        RETURN new_adherent;
    END create_adherent;


    MEMBER PROCEDURE update_adherent(newNom VARCHAR2, newPrenom VARCHAR2) IS
    BEGIN
        UPDATE adherents a SET a.nom = newNom, a.prenom = newPrenom WHERE a.id_adherent = SELF.id_adherent;
    END update_adherent;


    STATIC PROCEDURE delete_adherent(id NUMBER) IS
    BEGIN
        DELETE FROM adherents WHERE id_adherent = id;
    END delete_adherent;


    MEMBER FUNCTION count_emprunts RETURN NUMBER IS
        cnt NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO cnt
        FROM emprunts
        WHERE adherent_ref = (SELECT REF(a) FROM adherents a WHERE a.id_adherent = SELF.id_adherent);
        RETURN cnt;
    END count_emprunts;

    MEMBER FUNCTION list_livres_empruntes RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
        SELECT l.titre
        FROM emprunts e, livres l
        WHERE e.adherent_ref = (SELECT REF(a) FROM adherents a WHERE a.id_adherent = SELF.id_adherent)
        AND e.livre_ref = REF(l);
        RETURN rc;
    END list_livres_empruntes;


    STATIC FUNCTION list_adherents_ordered RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
            SELECT a.nom || ' ' || a.prenom
            FROM adherents a
            ORDER BY a.nom, a.prenom;
        RETURN rc;
    END list_adherents_ordered;
END;
/


CREATE OR REPLACE TYPE BODY t_emprunt AS 
    STATIC FUNCTION create_emprunt(id NUMBER, livre_id VARCHAR2, adherent_id NUMBER, date_emprunt DATE, date_retour DATE) RETURN t_emprunt IS
        livre_ref REF t_livre;
        adherent_ref REF t_adherent;
        new_emprunt t_emprunt;
    BEGIN
        SELECT REF(l) INTO livre_ref 
            FROM livres l WHERE l.id_livre = livre_id;

        SELECT REF(a) INTO adherent_ref 
            FROM adherents a WHERE a.id_adherent = adherent_id;

        INSERT INTO emprunts (id_emprunt, livre_ref, adherent_ref, date_emprunt, date_retour)
            VALUES (id, livre_ref, adherent_ref, date_emprunt, date_retour);

        new_emprunt := NEW t_emprunt(id, livre_ref, adherent_ref, date_emprunt, date_retour);
        RETURN new_emprunt;
    END create_emprunt;

    MEMBER PROCEDURE update_emprunt(newDateEmprunt DATE, newDateRetour DATE) IS
    BEGIN
        UPDATE emprunts e SET e.date_emprunt = newDateEmprunt, e.date_retour = newDateRetour WHERE e.id_emprunt = SELF.id_emprunt;
    END update_emprunt;

    STATIC PROCEDURE delete_emprunt(id NUMBER) IS
    BEGIN
        DELETE FROM emprunts WHERE id_emprunt = id;
    END delete_emprunt;

    MEMBER FUNCTION is_overdue RETURN BOOLEAN IS
    BEGIN
        RETURN SYSDATE > SELF.date_retour;
    END is_overdue;

    MEMBER FUNCTION duration_days RETURN NUMBER IS
    BEGIN
        RETURN SELF.date_retour - SELF.date_emprunt;
    END duration_days;


    STATIC FUNCTION list_emprunts_ordered RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
            SELECT e.date_emprunt
            FROM emprunts e
            ORDER BY e.date_emprunt;
        RETURN rc;
    END list_emprunts_ordered;
END;
/


-- Wrapper

BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE update_ville_wrapper';
    EXECUTE IMMEDIATE 'DROP FUNCTION count_bibliotheques_wrapper';
    EXECUTE IMMEDIATE 'DROP FUNCTION list_bibliotheques_wrapper';
    EXECUTE IMMEDIATE 'DROP PROCEDURE update_bibliotheque_wrapper';
    EXECUTE IMMEDIATE 'DROP FUNCTION count_livres_wrapper';
    EXECUTE IMMEDIATE 'DROP PROCEDURE list_livres_wrapper';
    EXECUTE IMMEDIATE 'DROP PROCEDURE update_livre_wrapper';
    EXECUTE IMMEDIATE 'DROP FUNCTION count_emprunts_livre_wrapper';
    EXECUTE IMMEDIATE 'DROP PROCEDURE list_adherents_emprunteurs_wrapper';
    EXECUTE IMMEDIATE 'DROP PROCEDURE update_adherent_wrapper';
    EXECUTE IMMEDIATE 'DROP PROCEDURE count_emprunts_adherent_wrapper';
    EXECUTE IMMEDIATE 'DROP PROCEDURE list_livres_empruntes_wrapper';

    EXECUTE IMMEDIATE 'DROP PROCEDURE update_emprunt_wrapper';
    EXECUTE IMMEDIATE 'DROP PROCEDURE is_overdue_wrapper';
    EXECUTE IMMEDIATE 'DROP PROCEDURE duration_days_wrapper';

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4043 THEN
            RAISE;
        END IF;
END;    
/


CREATE OR REPLACE PROCEDURE update_ville_wrapper(p_id_ville NUMBER, p_newNom VARCHAR2) IS
    v t_ville;
BEGIN
    SELECT VALUE(v) INTO v FROM villes v WHERE v.id_ville = p_id_ville;
    v.update_ville(p_newNom);
END update_ville_wrapper;
/

CREATE OR REPLACE FUNCTION count_bibliotheques_wrapper(p_id_ville NUMBER) RETURN NUMBER IS
    v t_ville;
BEGIN
    SELECT VALUE(v) INTO v FROM villes v WHERE v.id_ville = p_id_ville;
    RETURN v.count_bibliotheques();
END count_bibliotheques_wrapper;
/

CREATE OR REPLACE PROCEDURE list_bibliotheques_wrapper(p_id_ville NUMBER, p_rc OUT SYS_REFCURSOR) IS
    v t_ville;
BEGIN
    SELECT VALUE(v) INTO v FROM villes v WHERE v.id_ville = p_id_ville;
    p_rc := v.list_bibliotheques();
END list_bibliotheques_wrapper;
/



CREATE OR REPLACE PROCEDURE update_bibliotheque_wrapper(p_id_bibliotheque NUMBER, p_newNom VARCHAR2, p_newAdresse VARCHAR2) IS
    b t_bibliotheque;
BEGIN
    SELECT VALUE(b) INTO b FROM bibliotheques b WHERE b.id_bibliotheque = p_id_bibliotheque;
    b.update_bibliotheque(p_newNom, p_newAdresse);
END update_bibliotheque_wrapper;
/

CREATE OR REPLACE FUNCTION count_livres_wrapper(p_id_bibliotheque NUMBER) RETURN NUMBER IS
    b t_bibliotheque;
BEGIN
    SELECT VALUE(b) INTO b FROM bibliotheques b WHERE b.id_bibliotheque = p_id_bibliotheque;
    RETURN b.count_livres();
END count_livres_wrapper;
/

CREATE OR REPLACE PROCEDURE list_livres_wrapper(p_id_bibliotheque NUMBER, p_rc OUT SYS_REFCURSOR) IS
    b t_bibliotheque;
BEGIN
    SELECT VALUE(b) INTO b FROM bibliotheques b WHERE b.id_bibliotheque = p_id_bibliotheque;
    p_rc := b.list_livres();
END list_livres_wrapper;
/



CREATE OR REPLACE PROCEDURE update_livre_wrapper(p_id_livre VARCHAR2, p_newTitre VARCHAR2, p_newAuteur VARCHAR2, p_newGenre VARCHAR2) IS
    l t_livre;
BEGIN
    SELECT VALUE(l) INTO l FROM livres l WHERE l.id_livre = p_id_livre;
    l.update_livre(p_newTitre, p_newAuteur, p_newGenre);
END update_livre_wrapper;
/

CREATE OR REPLACE FUNCTION count_emprunts_livre_wrapper(p_id_livre VARCHAR2) RETURN NUMBER IS
    l t_livre;
BEGIN
    SELECT VALUE(l) INTO l FROM livres l WHERE l.id_livre = p_id_livre;
    RETURN l.count_emprunts();
END count_emprunts_livre_wrapper;
/

CREATE OR REPLACE PROCEDURE list_adherents_emprunteurs_wrapper(p_id_livre VARCHAR2, p_rc OUT SYS_REFCURSOR) IS
    l t_livre;
BEGIN
    SELECT VALUE(l) INTO l FROM livres l WHERE l.id_livre = p_id_livre;
    p_rc := l.list_adherents_emprunteurs();
END list_adherents_emprunteurs_wrapper;
/



CREATE OR REPLACE PROCEDURE update_adherent_wrapper(p_id_adherent NUMBER, p_newNom VARCHAR2, p_newPrenom VARCHAR2) IS
    a t_adherent;
BEGIN
    SELECT VALUE(a) INTO a FROM adherents a WHERE a.id_adherent = p_id_adherent;
    a.update_adherent(p_newNom, p_newPrenom);
END update_adherent_wrapper;
/

CREATE OR REPLACE FUNCTION count_emprunts_adherent_wrapper(p_id_adherent NUMBER) RETURN NUMBER IS
    a t_adherent;
BEGIN
    SELECT VALUE(a) INTO a FROM adherents a WHERE a.id_adherent = p_id_adherent;
    RETURN a.count_emprunts();
END count_emprunts_adherent_wrapper;
/

CREATE OR REPLACE PROCEDURE list_livres_empruntes_wrapper(p_id_adherent NUMBER, p_rc OUT SYS_REFCURSOR) IS
    a t_adherent;
BEGIN
    SELECT VALUE(a) INTO a FROM adherents a WHERE a.id_adherent = p_id_adherent;
    p_rc := a.list_livres_empruntes();
END list_livres_empruntes_wrapper;
/


CREATE OR REPLACE PROCEDURE update_emprunt_wrapper(p_id_emprunt NUMBER, p_newDateEmprunt DATE, p_newDateRetour DATE) IS
    e t_emprunt;
BEGIN
    SELECT VALUE(e) INTO e FROM emprunts e WHERE e.id_emprunt = p_id_emprunt;
    e.update_emprunt(p_newDateEmprunt, p_newDateRetour);
END update_emprunt_wrapper;
/

CREATE OR REPLACE FUNCTION is_overdue_wrapper(p_id_emprunt NUMBER) RETURN BOOLEAN IS
    e t_emprunt;
BEGIN
    SELECT VALUE(e) INTO e FROM emprunts e WHERE e.id_emprunt = p_id_emprunt;
    RETURN e.is_overdue();
END is_overdue_wrapper;
/

CREATE OR REPLACE FUNCTION duration_days_wrapper(p_id_emprunt NUMBER) RETURN NUMBER IS
    e t_emprunt;
BEGIN
    SELECT VALUE(e) INTO e FROM emprunts e WHERE e.id_emprunt = p_id_emprunt;
    RETURN e.duration_days();
END duration_days_wrapper;
/




-- ------------
-- Test Create, Update, Delete
-- ------------

SET SERVEROUTPUT ON;

-- Test Ville
DECLARE
    v t_ville;
BEGIN
    v := t_ville.create_ville(100, 'NouvelleVille');
    DBMS_OUTPUT.PUT_LINE('Ville créée : ' || v.nom);

    v.update_ville('VilleMiseAJour');
    SELECT VALUE(v) INTO v FROM villes v WHERE v.id_ville = 100;
    DBMS_OUTPUT.PUT_LINE('Ville après mise à jour : ' || v.nom);

    t_ville.delete_ville(100);
    DBMS_OUTPUT.PUT_LINE('Ville supprimée : ID 100');

    BEGIN
        SELECT VALUE(v) INTO v FROM villes v WHERE v.id_ville = 100;
        DBMS_OUTPUT.PUT_LINE('Erreur : La ville existe toujours.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Vérification réussie : La ville n''existe plus.');
    END;
END;
/

-- Test Bibliotheque
DECLARE
    b t_bibliotheque;
    ville_id NUMBER := 1001;
BEGIN
    b := t_bibliotheque.create_bibliotheque(2030, ville_id, 'Bibliothèque Test', '123 Rue Test');
    DBMS_OUTPUT.PUT_LINE('Bibliothèque créée : ' || b.nom || ', Adresse : ' || b.adresse);

    b.update_bibliotheque('Bibliothèque Mise à Jour', '456 Rue Nouveau');
    DBMS_OUTPUT.PUT_LINE('Bibliothèque mise à jour : ' || b.nom || ', Adresse : ' || b.adresse);

    t_bibliotheque.delete_bibliotheque(2030);
    DBMS_OUTPUT.PUT_LINE('Bibliothèque supprimée : ID 2030');

    DECLARE
        count_ref NUMBER;
    BEGIN
        SELECT COUNT(*) INTO count_ref FROM bibliotheques b WHERE b.id_bibliotheque = 2030;
        IF count_ref = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Vérification réussie : La bibliothèque n''existe plus.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Erreur : La bibliothèque existe toujours.');
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Vérification réussie : La bibliothèque n''existe plus.');
    END;
END;
/

-- Test Livre
DECLARE
    l t_livre;
    bibliotheque_id NUMBER := 2001; 
BEGIN
    l := t_livre.create_livre('L100', bibliotheque_id, 'Titre Initial', 'Auteur Initial', 'Genre Initial');
    DBMS_OUTPUT.PUT_LINE('Livre créé : ' || l.titre || ', Auteur : ' || l.auteur || ', Genre : ' || l.genre);

    l.update_livre('Titre Mis à Jour', 'Auteur Mis à Jour', 'Genre Mis à Jour');
    SELECT VALUE(l) INTO l FROM livres l WHERE l.id_livre = 'L100';
    DBMS_OUTPUT.PUT_LINE('Livre mis à jour : ' || l.titre || ', Auteur : ' || l.auteur || ', Genre : ' || l.genre);

    t_livre.delete_livre('L100');
    DBMS_OUTPUT.PUT_LINE('Livre supprimé : ID L100');

    BEGIN
        SELECT VALUE(l) INTO l FROM livres l WHERE l.id_livre = 'L100';
        DBMS_OUTPUT.PUT_LINE('Erreur : Le livre existe toujours.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Vérification réussie : Le livre n''existe plus.');
    END;
END;
/

-- Adherent
DECLARE
    a t_adherent;
    bibliotheque_id NUMBER := 2001;
BEGIN
    a := t_adherent.create_adherent(3000, bibliotheque_id, 'Nom Initial', 'Prenom Initial');
    DBMS_OUTPUT.PUT_LINE('Adhérent créé : ' || a.nom || ', Prénom : ' || a.prenom);

    a.update_adherent('Nom Mis à Jour', 'Prenom Mis à Jour');
    SELECT VALUE(a) INTO a FROM adherents a WHERE a.id_adherent = 3000;
    DBMS_OUTPUT.PUT_LINE('Adhérent mis à jour : ' || a.nom || ', Prénom : ' || a.prenom);

    t_adherent.delete_adherent(3000);
    DBMS_OUTPUT.PUT_LINE('Adhérent supprimé : ID 3000');

    BEGIN
        SELECT VALUE(a) INTO a FROM adherents a WHERE a.id_adherent = 3000;
        DBMS_OUTPUT.PUT_LINE('Erreur : L''adhérent existe toujours.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Vérification réussie : L''adhérent n''existe plus.');
    END;
END;
/

-- Emprunt
DECLARE
    e t_emprunt;
    livre_id VARCHAR2(50) := 'L001'; 
    adherent_id NUMBER := 3001; 
BEGIN
    e := t_emprunt.create_emprunt(4000, livre_id, adherent_id, SYSDATE, SYSDATE + 7);
    DBMS_OUTPUT.PUT_LINE('Emprunt créé : Livre ID ' || livre_id || ', Adhérent ID ' || adherent_id);

    e.update_emprunt(SYSDATE + 1, SYSDATE + 8);
    SELECT VALUE(e) INTO e FROM emprunts e WHERE e.id_emprunt = 4000;
    DBMS_OUTPUT.PUT_LINE('Emprunt mis à jour : Date d''emprunt ' || e.date_emprunt || ', Date de retour ' || e.date_retour);

    t_emprunt.delete_emprunt(4000);
    DBMS_OUTPUT.PUT_LINE('Emprunt supprimé : ID 4000');

    BEGIN
        SELECT VALUE(e) INTO e FROM emprunts e WHERE e.id_emprunt = 4000;
        DBMS_OUTPUT.PUT_LINE('Erreur : L''emprunt existe toujours.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Vérification réussie : L''emprunt n''existe plus.');
    END;
END;
/


-- Test 

DECLARE
    v t_ville;
    cnt NUMBER;
    rc SYS_REFCURSOR;
    nom_bibliotheque VARCHAR2(100);
BEGIN
    SELECT VALUE(v) INTO v
        FROM villes v
        WHERE v.id_ville = 1001; 

    cnt := v.count_bibliotheques();
    DBMS_OUTPUT.PUT_LINE('Nombre de bibliothèques à ' || v.nom || ': ' || cnt);

    rc := v.list_bibliotheques();
    LOOP
        FETCH rc INTO nom_bibliotheque;
        EXIT WHEN rc%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Bibliothèque: ' || nom_bibliotheque);
    END LOOP;
    CLOSE rc;
END;
/


DECLARE
    b t_bibliotheque;
    cnt NUMBER;
    rc SYS_REFCURSOR;
    titre_livre VARCHAR2(100);
BEGIN
    SELECT VALUE(b) INTO b
        FROM bibliotheques b
        WHERE b.id_bibliotheque = 2001; 

    cnt := b.count_livres();
    DBMS_OUTPUT.PUT_LINE('Nombre de livres dans la bibliothèque: ' || cnt);

    rc := b.list_livres();
    LOOP
        FETCH rc INTO titre_livre;
        EXIT WHEN rc%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Livre: ' || titre_livre);
    END LOOP;
    CLOSE rc;
END;
/

DECLARE
    l t_livre;
    cnt NUMBER;
    rc SYS_REFCURSOR;
    nom_adherent VARCHAR2(100);
    prenom_adherent VARCHAR2(100);
BEGIN
    SELECT VALUE(l) INTO l
        FROM livres l
        WHERE l.id_livre = 'L001'; 

    cnt := l.count_emprunts();
    DBMS_OUTPUT.PUT_LINE('Nombre d''emprunts pour le livre: ' || cnt);

    rc := l.list_adherents_emprunteurs();
    LOOP
        FETCH rc INTO nom_adherent, prenom_adherent;
        EXIT WHEN rc%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Adhérent: ' || nom_adherent || ' ' || prenom_adherent);
    END LOOP;
    CLOSE rc;
END;
/

DECLARE
    a t_adherent;
    cnt NUMBER;
    rc SYS_REFCURSOR;
    titre_livre VARCHAR2(100);
BEGIN
    SELECT VALUE(a) INTO a
        FROM adherents a
        WHERE a.id_adherent = 3001; 

    cnt := a.count_emprunts();
    DBMS_OUTPUT.PUT_LINE('Nombre d''emprunts pour l''adhérent: ' || cnt);

    rc := a.list_livres_empruntes();
    LOOP
        FETCH rc INTO titre_livre;
        EXIT WHEN rc%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Livre emprunté: ' || titre_livre);
    END LOOP;
    CLOSE rc;
END;
/

DECLARE
    e t_emprunt;
    overdue BOOLEAN;
    duration NUMBER;
BEGIN
    SELECT VALUE(e) INTO e
        FROM emprunts e
        WHERE e.id_emprunt = 4001; 

    overdue := e.is_overdue();
    IF overdue THEN
        DBMS_OUTPUT.PUT_LINE('L''emprunt est en retard.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('L''emprunt n''est pas en retard.');
    END IF;

    duration := e.duration_days();
    DBMS_OUTPUT.PUT_LINE('Durée de l''emprunt: ' || duration || ' jours.');
END;
/


-- Test methode ordre 

DECLARE
    rc SYS_REFCURSOR;
    ville_nom VARCHAR2(100);
BEGIN
    rc := t_ville.list_villes_ordered();
    LOOP
        FETCH rc INTO ville_nom; 
        EXIT WHEN rc%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(ville_nom); 
    END LOOP;
    CLOSE rc; 
END;
/

DECLARE
    rc_biblio SYS_REFCURSOR;
    nom_biblio VARCHAR2(100);
BEGIN
    rc_biblio := t_bibliotheque.list_bibliotheques_ordered();
    LOOP
        FETCH rc_biblio INTO nom_biblio;
        EXIT WHEN rc_biblio%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Bibliotheque: ' || nom_biblio);
    END LOOP;
    CLOSE rc_biblio;
END;
/

DECLARE
    rc_livre SYS_REFCURSOR;
    titre_livre VARCHAR2(100);
BEGIN
    rc_livre := t_livre.list_livres_ordered();
    LOOP
        FETCH rc_livre INTO titre_livre;
        EXIT WHEN rc_livre%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Livre: ' || titre_livre);
    END LOOP;
    CLOSE rc_livre;
END;
/

DECLARE
    rc_adherent SYS_REFCURSOR;
    nom_adherent VARCHAR2(100);
BEGIN
    rc_adherent := t_adherent.list_adherents_ordered();
    LOOP
        FETCH rc_adherent INTO nom_adherent;
        EXIT WHEN rc_adherent%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Adherent: ' || nom_adherent);
    END LOOP;
    CLOSE rc_adherent;
END;
/

DECLARE
    rc_emprunt SYS_REFCURSOR;
    date_emprunt DATE;
BEGIN
    rc_emprunt := t_emprunt.list_emprunts_ordered();
    LOOP
        FETCH rc_emprunt INTO date_emprunt;
        EXIT WHEN rc_emprunt%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Date d''emprunt: ' || date_emprunt);
    END LOOP;
    CLOSE rc_emprunt;
END;
/

-- Test les wrappers


DECLARE
    v_id_ville NUMBER;
    v_newNom VARCHAR2(100);
    v_count NUMBER;
    v_rc SYS_REFCURSOR;
    v_nomBibliotheque VARCHAR2(100);
BEGIN
    v_id_ville := 1001; 
    v_newNom := 'NouvelleVille';

    EXECUTE IMMEDIATE 'UPDATE villes SET nom = ''Pam'' WHERE id_ville = ' || v_id_ville;
    DBMS_OUTPUT.PUT_LINE('Avant mise à jour:');
    SELECT nom INTO v_newNom FROM villes WHERE id_ville = v_id_ville;
    DBMS_OUTPUT.PUT_LINE('Nom: ' || v_newNom);

    update_ville_wrapper(v_id_ville, 'Paris');
    DBMS_OUTPUT.PUT_LINE('Après mise à jour:');
    SELECT nom INTO v_newNom FROM villes WHERE id_ville = v_id_ville;
    DBMS_OUTPUT.PUT_LINE('Nom: ' || v_newNom);

    v_count := count_bibliotheques_wrapper(v_id_ville);
    DBMS_OUTPUT.PUT_LINE('Nombre de bibliothèques: ' || v_count);

    list_bibliotheques_wrapper(v_id_ville, v_rc);
    LOOP
        FETCH v_rc INTO v_nomBibliotheque;
        EXIT WHEN v_rc%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Bibliotheque: ' || v_nomBibliotheque);
    END LOOP;
    CLOSE v_rc;
END;
/

DECLARE
    v_id_bibliotheque NUMBER;
    v_newNom VARCHAR2(100);
    v_newAdresse VARCHAR2(200);
    v_count NUMBER;
    v_rc SYS_REFCURSOR;
    v_titreLivre VARCHAR2(100);
BEGIN
    v_id_bibliotheque := 2001; 
    v_newNom := 'Bibliotheque Modifiee';
    v_newAdresse := 'Nouvelle Adresse 123';

    update_bibliotheque_wrapper(v_id_bibliotheque, v_newNom, v_newAdresse);
    DBMS_OUTPUT.PUT_LINE('Bibliothèque mise à jour.');

    v_count := count_livres_wrapper(v_id_bibliotheque);
    DBMS_OUTPUT.PUT_LINE('Nombre de livres dans la bibliothèque: ' || v_count);

    list_livres_wrapper(v_id_bibliotheque, v_rc);
    LOOP
        FETCH v_rc INTO v_titreLivre;
        EXIT WHEN v_rc%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Titre du livre: ' || v_titreLivre);
    END LOOP;
    CLOSE v_rc;
END;
/

DECLARE
    v_id_livre VARCHAR2(50) := 'L001'; 
    v_newTitre VARCHAR2(100) := 'Titre Modifié';
    v_newAuteur VARCHAR2(100) := 'Auteur Modifié';
    v_newGenre VARCHAR2(50) := 'Genre Modifié';
    v_count NUMBER;
    v_cursor SYS_REFCURSOR;
    v_nom_adherent VARCHAR2(100);
    v_prenom_adherent VARCHAR2(100);
BEGIN
    update_livre_wrapper(v_id_livre, v_newTitre, v_newAuteur, v_newGenre);
    DBMS_OUTPUT.PUT_LINE('Livre mis à jour : ' || v_id_livre);

    v_count := count_emprunts_livre_wrapper(v_id_livre);
    DBMS_OUTPUT.PUT_LINE('Nombre d''emprunts pour le livre ' || v_id_livre || ' : ' || v_count);

    list_adherents_emprunteurs_wrapper(v_id_livre, v_cursor);
    LOOP
        FETCH v_cursor INTO v_nom_adherent, v_prenom_adherent;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Adherent: ' || v_nom_adherent || ' ' || v_prenom_adherent);
    END LOOP;
    CLOSE v_cursor;
END;
/

DECLARE
    v_id_emprunt NUMBER := 4001; 
    v_newDateEmprunt DATE := SYSDATE;
    v_newDateRetour DATE := SYSDATE + 30; 
    v_is_overdue BOOLEAN;
    v_duration_days NUMBER;
BEGIN
    update_emprunt_wrapper(v_id_emprunt, v_newDateEmprunt, v_newDateRetour);
    DBMS_OUTPUT.PUT_LINE('Emprunt mis à jour avec les nouvelles dates.');

    v_is_overdue := is_overdue_wrapper(v_id_emprunt);
    DBMS_OUTPUT.PUT_LINE('L''emprunt est en retard: ' || CASE WHEN v_is_overdue THEN 'Oui' ELSE 'Non' END);

    v_duration_days := duration_days_wrapper(v_id_emprunt);
    DBMS_OUTPUT.PUT_LINE('Durée de l''emprunt en jours: ' || v_duration_days);
END;
/
