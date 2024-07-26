/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Exercice MOOCEBFR3 : Ingénierie des Données du Big Data: SGBD Objet relationnel et SQL3 Oracle
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

****************************************************************************************************************
* Exercices Module M3.2 : Notion d''identité et les collections dans SQL3 Oracle
* L'objet des exercices ici est de mettre en oeuvre la notion d'identité sur les lignes des tables objets
* et sur les lignes des tables relationnelles à travers les vues objets.
****************************************************************************************************************
*/

----------------------------------------------------------------------------------------------------------------
-- M3.2.1. notion d'identité (OID et références)
----------------------------------------------------------------------------------------------------------------


-- M3.2.1.1 identité sur les lignes d'une table objet

-- M3.2.1.1.1 Création d'une table objet et insertion de lignes
drop table O_PILOTE2;
drop table R_VOL2;
drop type  Pilote2_t force;
drop type  adresse2_t force;


CREATE OR REPLACE TYPE adresse2_t as object(
			Numero			NUMBER(4),
			Rue				VARCHAR2(20),
			Code_Postal		NUMBER(5),
			Ville			VARCHAR2(20)
);
/


-- M3.1.1.2 Création de la spécification du type PILOTE

CREATE OR REPLACE TYPE Pilote2_t AS OBJECT(
	PL#		NUMBER(4),
	nom		VARCHAR2(12),
	adresse		adresse2_t, -- type abstrait défini préalablement
	Tel			VARCHAR2(12),
	dnaiss		DATE,
	salaire		NUMBER(7,2)
);
/

CREATE TABLE O_PILOTE2 OF PILOTE2_T;

-- Création d'une table relation avec une référence
CREATE TABLE R_VOL2 (
			Vol#	NUMBER(4) PRIMARY KEY,
			VD		VARCHAR2(20),
			VA		VARCHAR2(20),
			Pilote	REF pilote2_t); --type abstrait défini préalablement

-- Insertion en exploitant les astuces du langage SQL
 
INSERT INTO o_pilote2 VALUES ( pilote2_t(2, 'Milou TINTIN',
 adresse2_t(12, 'rue nord', 75000, 'Paris'), '0493825084', to_date('11-08-1963', 'DD-MM-YYYY'), 10000.5));

INSERT INTO R_VOL2 SELECT 300, 'Paris', 'Nice', REF(px)
	from o_pilote2 px  where px.nom = 'Milou TINTIN'; 

---------------------------------------------------------------------------------------------------------------	
-- M3.2.1.1.2 ACTIVITES SUR l' identité dans les tables objets
---------------------------------------------------------------------------------------------------------------	
-- a) Quel est la différence entre ma table r_vol2 et o_pilote2 ?
-- b) Afficher les identifiants de la table o_pilote2
-- c) Insérer le pilote nr 3 et associer 3 vols
-- d) Quels sont les vols assurés par le pilote nr 3. Ecrire la requête qui va
	
	
---------------------------------------------------------------------------------------------------------------	
-- M3.2.1.2 identité sur les lignes d'une relationnelle à travers des vues objets
----------------------------------------------------------------------------------------------------------------

--M3.2.1.2.1  attribution des OID aux lignes d'une table relationnelle à travers les vues par étapes

-- Etape 1 : Création de la table relationnelle POLOTE2
drop view  V_Pilote2;
drop table O_PILOTE2;
drop table R_PILOTE2;
drop table R_VOL2;
drop type  Pilote2_t force;
drop type  adresse2_t force;

CREATE OR REPLACE TYPE adresse2_t as object(
			Numero			NUMBER(4),
			Rue				VARCHAR2(20),
			Code_Postal		NUMBER(5),
			Ville			VARCHAR2(20)
);
/

CREATE table  r_pilote2 (
	PL#			NUMBER(4) CONSTRAINT pk_R_Pilote2 PRIMARY KEY,
	nom			 VARCHAR2(12),
	adresse   	adresse2_t,-- type abstrait défini préalablement
	Tel			VARCHAR2(12), 
	dnaiss	    	DATE,
	salaire		NUMBER(7,2)
);

-- Etape 2 : Insertion des lignes dans la table relationnelle POLOTE1

INSERT INTO r_pilote2 VALUES (5, 'TINTIN', 
adresse2_t(15, 'Av de Mars', 1000, 'BRUXELLES'), '0493825084', '11/08/64', 15000.5);

INSERT INTO r_pilote2 VALUES (6, 'RACKHAM', 
adresse2_t(16, 'Av des épaves', 97137, 'POINTE-A-PITRE'), '+59064938284', '12/08/68', 20000.5);

-- Exemple : attribution des OID à une table relationnelle

-- Etape 3 : création du type Pilote2_t ayant la structure de la table Pilote2

CREATE OR REPLACE TYPE  Pilote2_t as object(
	PL#	 		NUMBER(4),
	nom	 		VARCHAR2(12),
	adresse	  	adresse2_t,-- type abstrait défini préalablement
	Tel	 		VARCHAR2(12), 
	dnaiss	 	DATE,
	salaire	 	NUMBER(7,2)
);
/

-- Etape 4 : Création de la vue objet V_Pilote2 sur la table relationnelle SQL2 r_Pilote2 

CREATE OR REPLACE VIEW V_Pilote2 OF Pilote2_t 
	WITH OBJECT IDENTIFIER(pl#) --PL# mappe la clé primaire de la table r_Pilote2
	AS SELECT * FROM r_pilote2 p;

-- Etape 5 : Consultation à travers la vue objet V_Pilote2 et vérification de la présence des OID

select REF(V) FROM v_Pilote2 v ;
	
---------------------------------------------------------------------------------------------------------------	
-- M3.2.1.2.2 ACTIVITES A FAIRE SUR l' identité dans les tables relationnelles à travers les vues objets
---------------------------------------------------------------------------------------------------------------	
-- a) Pourquoi les lignes des tables relationnelles ne sont pas identifiées par OID ?
-- b) Comment identifier les lignes des tables relationnelles par les OID ?
-- c) Insérer 2 nouveaux pilotes via la table relationnelle r_pilote2
-- d) Insérer 2 nouveaux pilotes via la vue objet v_Pilote2
-- e) Créer une vue relationnelle sur la vue objet v_Pilote2
	
			
----------------------------------------------------------------------------------------------------------------
-- M3.2.2. Les collections de type VARRAY
----------------------------------------------------------------------------------------------------------------

-- M3.2.2.1 Exemple de Création et de manipulation d'un type VARRAY
drop table r_hangar2;
drop type avion2_t force;
drop type arrayAvion2_t force;

CREATE TYPE avion2_t as object (
			Av#			NUMBER(4),
			AvType		VARCHAR2(45),
			Loc			VARCHAR2(20),
			Cap			NUMBER(4));
/

-- Création du type VARRAY appelé arrayAvion2_t

CREATE OR REPLACE TYPE arrayAvion2_t  AS VARRAY (5) OF avion2_t
/


-- Création d'une table contenant un VARRAY
-- Chaque colonne 'avions' est un tableau de 5 éléments 
-- de type avion2_t

CREATE TABLE r_hangar2 (
hangar2#	NUMBER(2),
avions  	arrayAvion2_t
);

-- Exemple 1: Insertion dans une table avec un VARRAY 

INSERT INTO r_hangar2
           VALUES (1, arrayAvion2_t (avion2_t ( 1, 'AIRBUS', 'NICE',300) )) ;

INSERT INTO r_hangar2
           VALUES (2, arrayAvion2_t (avion2_t ( 2, 'AIRBUS',  'PARIS',320))) ;

INSERT INTO r_hangar2
           VALUES (3, arrayAvion2_t (avion2_t ( 3, 'AIRBUS',  'PARIS',320), avion2_t ( 5, 'AIRBUS',  'PARIS',320))) ;
commit;

-- Exemple 2 : Consultation d'une table avec un VARRAY 

SELECT * FROM r_hangar2; 

SELECT h.hangar2#, tab_avions.* 
FROM r_hangar2 h, TABLE(h.avions) tab_avions; 

SELECT TAV.* 
FROM TABLE (SELECT h.avions FROM r_hangar2 h where h.hangar2#=3)  TAV; 

UPDATE r_hangar2
SET avions =arrayAvion2_t(avion2_t ( 4,  'CARAVELLE','PARIS',320)) 
WHERE hangar2#=2 ;


----------------------------------------------------------------------------------------------------------------
-- M3.2.2.2 ACTIVITES A FAIRE SUR LES VARRAYS
----------------------------------------------------------------------------------------------------------------
-- a) Insérer un hangar et 6 avions dans ce hangar. Que constatez vous ?
-- b) Modifier l'avion Nr 4 et fixer son type à BOEING par programmation
-- c) Ecrire une requête qui permet d'afficher le nombre d'avion par hangar via une requête SQL
-- d) Ecrire un programme PLSQL qui permet d'afficher le nombre d'avion par hangar



----------------------------------------------------------------------------------------------------------------
-- M3.2.3. Les collections de type NESTED sans partage des éléments de la collection
----------------------------------------------------------------------------------------------------------------

-- M3.2.3.1 Exemple de Création et de manipulation d'un type NESTED sans partage

-- M3.2.3.1.1 Cas 1 : Pas de partage des éléments de la collection

DROP TABLE o_cursus2;
DROP TYPE COURS2_t force;
DROP TYPE CURSUS2_T force;
DROP TYPE LISTE_DE_COURS2_t force;


-- Création du type COURS2_t
-- Ce type permettra de construire les éléments de la collection
CREATE OR REPLACE  TYPE COURS2_t AS OBJECT (
			COURS_ID			 NUMBER(4),
			LIBELLE				 VARCHAR2(100),
			RESPONSABLE	 VARCHAR2(50),
			INTERVENANT	 VARCHAR2(50))
/
-- Définition du type table : collection illimitée
CREATE OR REPLACE TYPE LISTE_DE_COURS2_t
AS TABLE OF COURS2_t
/
-- Création du type CURSUS2_T
CREATE OR REPLACE  TYPE CURSUS2_T AS OBJECT (
	CURSUS_ID			 NUMBER(4),
	TITRE						 VARCHAR2(50),
	DESCRIPTION			 VARCHAR2(100),
	LISTECOURS			 LISTE_DE_COURS2_t )
/

-- Création de la table o_cursus2 avec sa table imbriqué LISTECOURS
-- Définition du segment storeListeCours (STORE TABLE) pour stocker les objets de la table imbriquée. 

-- Une STORE TABLE est une table dont l'accès aux LIGNES se fait uniquement à travers la table qui la contient

CREATE TABLE o_cursus2 OF CURSUS2_T(
	constraint pk_o_cursus2_cursus_id primary key(cursus_id)
)
NESTED TABLE LISTECOURS STORE AS storeListeCours1;

-- Insertion des lignes

INSERT INTO o_cursus2
VALUES(1, 
'M2 MBDS', 
'Multimédia Bases de Données et Intégration de Systèmes',
LISTE_DE_COURS2_t( COURS2_t(100, 'SGBDR', 'Codd', 'Date'),
COURS2_t(102, 'XML', 'Jacobson', 'Smirnoff')));

-- Insertion des lignes

INSERT INTO o_cursus2
VALUES(2, 
'M1 MIAGE', 
'Méthodes Informatiques Appliquées à la Gestion',
LISTE_DE_COURS2_t( COURS2_t(101, 'Java', 'Mc Nelly', 'Buffa')));


INSERT INTO o_cursus2
VALUES(3, 
'M1 INFO', 
'Master 1 Informatique',
LISTE_DE_COURS2_t( COURS2_t(103, 'UML', 'Booch', 'Jackson')));

INSERT INTO o_cursus2
VALUES(4, 
'M2 ISI', 
'M2 Ingéniérie des Systèmes Informatques',
LISTE_DE_COURS2_t());

commit;
-- consultation des cours du CURSUS MBDS

SELECT t1.*
 FROM table(SELECT listeCours 
FROM o_cursus2 
WHERE cursus_id=1) t1;

--------------------------------------------------------------------------------------------------------------- 
-- M3.2.3.1.1 ACTIVITES A FAIRE AUTOUR DES TYPE NESTED SANS PARTAGE
----------------------------------------------------------------------------------------------------------------

-- a) Insérer le cursus Nr 5 avec 6 cours
-- b) Afficher les cours du cursus nr 5 et du cursus nr 2
-- c) Ecrire un programme PLSQL qui permet d'insérer le cursus nr 6 avec  2 cours
 
 
 
----------------------------------------------------------------------------------------------------------------
-- M3.2.4. Les collections de type NESTED AVEC partage des éléments de la collection
----------------------------------------------------------------------------------------------------------------

-- M3.2.4.1 Exemple de Création et de manipulation d'un type NESTED avec partage des cours

-- M3.2.4.1.1 Cas 2 : Avec partage des éléments (cours) de la collection

Drop table o_cursus2 cascade constraints;
Drop table o_cours2 cascade constraints;
Drop type cursus2_t force;
Drop type cours2_t force;
drop type LISTE_REF_DE_cours2_t force;

-- Création du type incomplet cursus2_t
CREATE OR REPLACE TYPE cursus2_t;
/
-- Création du type cours2_t
CREATE OR REPLACE  TYPE cours2_t AS OBJECT (
			COURS_ID		NUMBER(4),
			LIBELLE			VARCHAR2(100),
			RESPONSABLE	 	VARCHAR2(50),
			INTERVENANT	 	VARCHAR2(50),
			refCursus		REF cursus2_t)
/
-- Création du type collection de REF vers les cours
CREATE OR REPLACE TYPE  LISTE_REF_DE_cours2_t
AS TABLE OF REF cours2_t
/
-- Création du type cursus2_t
CREATE OR REPLACE  TYPE cursus2_t AS OBJECT (
	CURSUS_ID		  	NUMBER(4),
	TITRE				VARCHAR2(50),
	DESCRIPTION		  	VARCHAR2(100),
	ListRefCours	 	LISTE_REF_DE_cours2_t )
/

-- Création de la table o_cursus2

CREATE TABLE o_cursus2 OF cursus2_t(
	constraint pk_cursus_cursus_id primary key(cursus_id)
)
NESTED TABLE listRefCours STORE AS storeListRefCours;


-- Création de la table o_cours2 

CREATE TABLE o_cours2 OF cours2_t(
constraint pk_cours_cours_id primary key(cours_id));

-- Insertion des lignes dans la table o_cursus2
-- Les listes sont au départ vides

INSERT INTO o_cursus2
VALUES(1, 'M2 MBDS', 
'Multimédia Bases de Données et Intégration de Systèmes',
LISTE_REF_DE_cours2_t());

INSERT INTO o_cursus2
VALUES(2, 'M1 MIAGE', 
'Méthodes Informatiques Appliquées à la Gestion',
LISTE_REF_DE_cours2_t());

INSERT INTO o_cursus2
VALUES(3, 'M1 INFO', 
'Master 1 Informatique', LISTE_REF_DE_cours2_t());

INSERT INTO o_cursus2
VALUES(4, 'M2 ISI', 
'M2 Ingéniérie des Systèmes Informatques', LISTE_REF_DE_cours2_t());


-- Insertion des lignes dans la table o_cours2

-- Cours du curus 1
INSERT INTO o_cours2 
Select 100, 'SGBDR', 'Codd', 'Date', 
ref(oc) from o_cursus2 oc where oc.cursus_id=1 ;


INSERT INTO o_cours2
Select 102, 'XML', 'Jacobson', 'Smirnoff', 
ref(oc) from o_cursus2 oc where oc.cursus_id=1 ;

-- Cours du cursus 2
INSERT INTO o_cours2
Select 101, 'Java', 'Mc Nelly', 'Buffa',
ref(oc) from o_cursus2 oc where oc.cursus_id=2 ;


-- Cours du cursus 3
INSERT INTO o_cours2
Select 103, 'UML', 'Booch', 'Jackson',
ref(oc) from o_cursus2 oc where oc.cursus_id=3;

-- Mise à jour des listes

-- Mise à jour de l liste des REF de cours du cursus 1
INSERT INTO 
TABLE(SELECT oc.listRefCours From o_cursus2 oc 
WHERE oc.cursus_id=1)
SELECT REF(oco) FROM o_cours2 oco
WHERE cours_id in (100, 102) ;

-- Mise à jour de l liste des REF de cours du cursus 2
INSERT INTO 
TABLE(SELECT oc.listRefCours From o_cursus2 oc 
WHERE oc.cursus_id=2)
SELECT REF(oco) FROM o_cours2 oco
WHERE cours_id=101 ;

-- Mise à jour de l liste des REF de cours du cursus 3
INSERT INTO 
TABLE(SELECT oc.listRefCours From o_cursus2 oc WHERE oc.cursus_id=3)
SELECT REF(oco)  FROM o_cours2 oco
WHERE cours_id=103 ;

-- La colonne COLUMN_VALUE

-- Rappel de la commande ayant permis de définir la collection
-- TYPE LISTE_DE_cours2_t.
--CREATE OR REPLACE TYPE LISTE_REF_DE_cours2_t
--AS TABLE OF REF cours2_t
--/
-- Lors de la définition d'une collection, le HANDLE permettant d'accéder implicitement à chaque élément de la -- Collection s' appelle COLUMN_VALUE.
-- Dans le cas de la collection LISTE_REF_DE_cours2_t. COLUMN_VALUE contient des pointeurs ou références vers -- des lignes de table o_cours2. COLUMN_VALUE EST UTILISE PAR ORACLE CHAQUE FOIS QUE LES ELEMENTS D'UNE -- 
-- COLLECTIONS NE SONT PAS UNE STRUCTURE.

-- Consultation des références de cours du CURSUS MBDS

SELECT t1.column_value
 FROM table(SELECT ListRefCours 
FROM o_cursus2
WHERE cursus_id=1) t1;
-- La colonne COLUMN_VALUE

-- Consultation des références de cours du CURSUS MBDS
Col LIBELLE format a20
Col TITRE format A20
SELECT 
t1.column_value.cours_id  cours_id, 
t1.column_value.libelle libelle, 
t1.column_value.RefCursus.titre titre
 FROM table(SELECT listRefCours 
FROM o_cursus2
WHERE cursus_id=1) t1;

----------------------------------------------------------------------------------------------------------------
-- M3.2.4.1.2 ACTIVITES A FAIRE AUTOUR DES TYPE NESTED AVEC PARTAGE 
----------------------------------------------------------------------------------------------------------------

-- a) Insérer le cursus Nr 5 avec 6 cours
-- b) Afficher les cours du cursus nr 5 et du cursus nr 2
-- c) Ecrire un programme PLSQL qui permet d'insérer le cursus nr 6 avec  2 cours
-- d) Afficher les pointeurs vers les cours du cursus Nr 5
