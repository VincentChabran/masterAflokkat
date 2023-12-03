drop table Pilote1;
drop type Pilote1_t force;

CREATE table  Pilote1 (
PL# NUMBER(4) CONSTRAINT pk_pilote1 PRIMARY KEY,
nom VARCHAR2(12),
adresse   adresse_t,-- type abstrait défini préalablement
Tel VARCHAR2(12),
dnaiss     DATE,
salaire NUMBER(7,2)
);


INSERT INTO pilote1 VALUES (5, 'TINTIN',
adresse_t(15, 'Av de Mars', 1000, 'BRUXELLES'), '0493825084', '11/08/1964', 15000.5);

INSERT INTO pilote1 VALUES (6, 'RACKHAM',
adresse_t(16, 'Av des épaves', 97137, 'POINTE-A-PITRE'), '+59064938284', '12/08/1968', 20000.5);


CREATE OR REPLACE TYPE  Pilote1_t as object(
PL# NUMBER(4),
nom VARCHAR2(12),
adresse  adresse_t,-- type abstrait défini préalablement
Tel VARCHAR2(12),
dnaiss DATE,
salaire NUMBER(7,2));
/

CREATE OR REPLACE VIEW V_PILOTE1 OF Pilote1_t
WITH OBJECT IDENTIFIER(pl#) --PL# mappe la clé primaire de la table PILOTE1
AS SELECT * FROM Pilote1 p;

select ref(p) from pilote_t p;

select ref(p) from V_PILOTE1 p;


--Sutie 

drop type HANGAR;
drop type avion_t force;
drop type TAB_AVIONS_T force;

CREATE TYPE avion_t AS OBJECT(
Av# NUMBER(4),
AvType VARCHAR2(45),
Loc VARCHAR2(20),
Cap NUMBER(4)
);
/


CREATE OR REPLACE TYPE TAB_AVIONS_T  AS VARRAY (5) OF avion_t
/

--Création de la table HANGAR avec une colonne avions de type TAB_AVIONS_T

CREATE TABLE HANGAR (
hangar# NUMBER(2),
avions   TAB_AVIONS_T
);

INSERT INTO HANGAR VALUES (1, TAB_AVIONS_T (avion_t ( 1, 'AIRBUS', 'NICE',300) ));
INSERT INTO HANGAR VALUES (2, TAB_AVIONS_T (avion_t ( 2, 'AIRBUS', 'PARIS',320)));
INSERT INTO HANGAR VALUES (3, TAB_AVIONS_T (avion_t ( 3, 'AIRBUS', 'PARIS',320),  avion_t ( 5, 'AIRBUS',  'PARIS',320))) ;

commit;

select * from hangar;


--Section 3 module 3.2


DROP TABLE O_CURSUS;
DROP TYPE COURS_t;
DROP TYPE CURSUS_T;
DROP TYPE LISTE_DE_COURS_T;



-- Création du type COURS_T
-- Ce type permettra de construire les éléments de la collection
CREATE OR REPLACE  TYPE COURS_T AS OBJECT (
COURS_ID NUMBER(4),
LIBELLE VARCHAR2(100),
RESPONSABLE VARCHAR2(50),
INTERVENANT VARCHAR2(50))
/


CREATE OR REPLACE TYPE LISTE_DE_COURS_T AS TABLE OF COURS_T;
/

-- Création du type CURSUS_T
CREATE OR REPLACE  TYPE CURSUS_T AS OBJECT (
CURSUS_ID NUMBER(4),
TITRE VARCHAR2(50),
DESCRIPTION VARCHAR2(100),
LISTECOURS LISTE_DE_COURS_T )
/



--Création de la table O_CURSUS avec sa table imbriqué LISTECOURS
--Définition du segment storeListeCours (STORE TABLE) pour stocker les objets de la table imbriquée.

--L’accès à la table storeListeCours n’est possible qu’à partir de la table O_CURSUS

CREATE TABLE O_CURSUS OF CURSUS_T(
constraint pk_cursus primary key(cursus_id)
)
NESTED TABLE LISTECOURS STORE AS storeListeCours;

-- Insertion des lignes
INSERT INTO O_CURSUS
VALUES(1,
'M2 MBDS',
'Multimédia Bases de Données et Intégration de Systèmes',
LISTE_DE_COURS_T( COURS_T(100, 'SGBDR', 'Codd', 'Date'),
COURS_T(102, 'XML', 'Jacobson', 'Smirnoff')));

INSERT INTO O_CURSUS
VALUES(2,
'M1 MIAGE',
'Méthodes Informatiques Appliquées à la Gestion',
LISTE_DE_COURS_T( COURS_T(101, 'Java', 'Mc Nelly', 'Buffa')));


INSERT INTO O_CURSUS
VALUES(3,
'M1 INFO',
'Master 1 Informatique',
LISTE_DE_COURS_T( COURS_T(103, 'UML', 'Booch', 'Jackson')));

INSERT INTO O_CURSUS
VALUES(4,
'M2 ISI',
'M2 Ingéniérie des Systèmes Informatques',
LISTE_DE_COURS_T());

--Break section
--
--

Drop table o_cursus cascade constraints;
Drop table o_cours cascade constraints;
Drop type cursus_t force;
Drop type cours_t force;
drop type LISTE_REF_DE_COURS_T force;

-- Création du type incomplet cursus_t
CREATE OR REPLACE TYPE cursus_t;
/
-- Création du type COURS_T
CREATE OR REPLACE  TYPE COURS_T AS OBJECT (
COURS_ID NUMBER(4),
LIBELLE VARCHAR2(100),
RESPONSABLE VARCHAR2(50),
INTERVENANT VARCHAR2(50),
refCursus  REF cursus_t)
/




-- Création du type collection de REF vers les cours
CREATE OR REPLACE TYPE  LISTE_REF_DE_COURS_T
AS TABLE OF REF COURS_T
/
-- Création du type cursus_t
CREATE OR REPLACE  TYPE CURSUS_T AS OBJECT (
CURSUS_ID  NUMBER(4),
TITRE  VARCHAR2(50),
DESCRIPTION  VARCHAR2(100),
ListRefCours    LISTE_REF_DE_COURS_T )
/




-- Création de la table O_CURSUS
CREATE TABLE O_CURSUS OF CURSUS_T(
constraint pk_cursus_cursus_id primary key(cursus_id)
)
NESTED TABLE listRefCours STORE AS storeListRefCours;

-- Création de la table O_COURS 
CREATE TABLE O_COURS OF COURS_T(
constraint pk_cours_cours_id primary key(cours_id));

-- Insertion des lignes dans la table O_CURSUS
-- Les listes sont au départ vides

INSERT INTO O_CURSUS
VALUES(1, 'M2 MBDS', 
'Multimédia Bases de Données et Intégration de Systèmes',
LISTE_REF_DE_COURS_T());

INSERT INTO O_CURSUS
VALUES(2, 'M1 MIAGE', 
'Méthodes Informatiques Appliquées à la Gestion',
LISTE_REF_DE_COURS_T());



-- Insertion des lignes dans la table O_CURSUS
-- Les listes sont au départ vides

INSERT INTO O_CURSUS
VALUES(3, 'M1 INFO', 
'Master 1 Informatique', LISTE_REF_DE_COURS_T());

INSERT INTO O_CURSUS
VALUES(4, 'M2 ISI', 
'M2 Ingéniérie des Systèmes Informatques', LISTE_REF_DE_COURS_T());

-- Insertion des lignes dans la table O_COURS

-- Cours du curus 1
INSERT INTO O_COURS 
Select 100, 'SGBDR', 'Codd', 'Date', 
ref(oc) from o_cursus oc where oc.cursus_id=1 ;

INSERT INTO O_COURS
Select 102, 'XML', 'Jacobson', 'Smirnoff', 
ref(oc) from o_cursus oc where oc.cursus_id=1 ;





-- Insertion des lignes dans la table O_COURS

-- Cours du cursus 2
INSERT INTO O_COURS
Select 101, 'Java', 'Mc Nelly', 'Buffa',
ref(oc) from o_cursus oc where oc.cursus_id=2 ;

-- Cours du cursus 3
INSERT INTO O_COURS
Select 103, 'UML', 'Booch', 'Jackson',
ref(oc) from o_cursus oc where oc.cursus_id=3;



-- Mise à jour des listes

-- Mise à jour de l liste des REF de cours du cursus 1
INSERT INTO 
TABLE(SELECT oc.listRefCours From o_cursus oc 
WHERE oc.cursus_id=1)
SELECT REF(oco) FROM O_COURS oco
WHERE cours_id in (100, 102) ;

-- Mise à jour de l liste des REF de cours du cursus 2
INSERT INTO 
TABLE(SELECT oc.listRefCours From o_cursus oc 
WHERE oc.cursus_id=2)
SELECT REF(oco) FROM O_COURS oco
WHERE cours_id=101 ;

-- Mise à jour de l liste des REF de cours du cursus 3
INSERT INTO 
TABLE(SELECT oc.listRefCours From o_cursus oc WHERE oc.cursus_id=3)
SELECT REF(oco)  FROM O_COURS oco
WHERE cours_id=103 ;
commit;
-- Consultation des références de cours du CURSUS MBDS

SELECT t1.column_value
 FROM table(SELECT ListRefCours 
FROM o_cursus
WHERE cursus_id=1) t1;

SELECT t1.column_value.cours, t1.column_value.libelle
 FROM table(SELECT ListRefCours 
FROM o_cursus
WHERE cursus_id=1) t1; 




select oc.Cours_id, oc.libelle, oc.refcursus.titre
from o_cours oc
where oc.refCursus.Cursus_id=1;


