
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Exercice MOOCEBFR3 : Ingénierie des Données du Big Data: SGBD Objet relationnel et SQL3 Oracle
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

****************************************************************************************************************
* Exercices Module M3.3 : Les tables objets, les liens d’associations, exercice dirigé
****************************************************************************************************************


----------------------------------------------------------------------------------------------------------------
-- M3.3.1. Mise en oeuvre d'une mini-application pure objet relationnelle avec les liens d’associations
----------------------------------------------------------------------------------------------------------------

/*
Etapes suivis : Revoir le cours

Etape 1 : Définir le schéma conceptuel avec MERISE, UML, Entité/Relation, ...
Etape 2 : Définir le schéma types
Etape 3 : Créer les types
Etape 4 : Créer les tables et définir les contraintes d'intégrités
Etape 5 : Créer les indexes si nécessaire
Etape 6 : Insérer des lignes dans les tables.

Mettre en oeuvre les différentes étapes en exéutant le code ci-dessous.

En M3.3.2 des activités complémentaires sont suggérées

L'exemple ci-dessous consiste à réaliser en objet relationnel, une application de gestion d'une base
de données aérienne.

*/

Drop table o_vol cascade constraints;
Drop table o_pilote cascade constraints;
Drop table o_avion cascade constraints;
Drop type avion_t force;
Drop type pilote_t force;
Drop type vol_t force;
Drop type listRefVols_t ;
Drop type adresse_t force;

-- 	Déclaration Forward des Types afin d'éviter l'interblocage dû au reférencement mutuel entre types

CREATE OR REPLACE TYPE VOL_T
/
--Création de type table (listRefVols_t) : Les éléments de cette liste sont des références vers des vols.

-- Solution 1: avec handle personnalisé
--Create or replace type refVol_t as object(
-- refVol 	 REF  VOL_T)
--/
--CREATE OR REPLACE TYPE listRefVols_t  AS TABLE OF refVol_t
--/

-- Solution 2: avec handle implicite appelé Column_Value
-- Le handle permet d’accéder aux éléments de la liste.
CREATE OR REPLACE TYPE listRefVols_t 
AS TABLE OF REF VOL_T
/
--NOTE : C’est la solution 2 qui a été retenue

--Création du  type PILOTE_T avec un champ multivalué pListRefVols
 
CREATE OR REPLACE TYPE adresse_t as object(
			Numero		NUMBER(4),
			Rue			VARCHAR2(20),
			Code_Postal	NUMBER(5),
			Ville		VARCHAR2(20))
/

CREATE OR REPLACE TYPE Pilote_t AS OBJECT (
	PL#			NUMBER(4),
	plnom			VARCHAR2(12),
	adresse			ADRESSE_T,	
	Telephone		VARCHAR2(12),
	dnaiss			DATE,
	salaire			NUMBER(7,2),
	pListRefVols	listRefVols_t)
/

--Création du  type AVION_T avec un champ multivalué aListRefVols

CREATE OR REPLACE TYPE Avion_t  AS OBJECT(
	Av#			NUMBER(3),
	avtype			VARCHAR2(12),
	localisation		VARCHAR2(20),
	capacite		NUMBER(3),
	remarque		CLOB,
	aListRefVols 	 listRefVols_t)
/


--Création du  type VOL_T avec 2 champs de type REF 

CREATE OR REPLACE  TYPE  Vol_t AS OBJECT(
	Vol#			NUMBER(4),
	VilleDepart		VARCHAR2(20),
	VilleArrivee		VARCHAR2(20),
	refPilote		REF pilote_t,
	refAvion		REF avion_t
)
/	

-- Table o_pilote
CREATE TABLE O_PILOTE OF PILOTE_T(
	CONSTRAINT pk_o_pilote_pl# PRIMARY KEY(pl#),
	CONSTRAINT chk_o_pilote_salaire CHECK (salaire >2000 AND Salaire<70000))
NESTED TABLE pListRefVols STORE AS table_pListRefVols; 
-- table_pListRefVols : table de Ref vers les vols des pilotes

 -- Table o_avion	
CREATE TABLE O_AVION OF AVION_T(
	CONSTRAINT pk_o_avion_av# PRIMARY KEY(AV#))
NESTED TABLE aListRefVols STORE AS table_aListRefVols;
-- table_aListRefVols : table de Ref vers les vols des avions

-- Table o_vol
CREATE TABLE O_VOL OF VOL_T(
	CONSTRAINT pk_o_vol_vol# PRIMARY KEY(vol#));

-- Le mot clé SCOPE FOR permet de limiter la visibilité des 
-- références à une table particulière. On peut aussi parler 
-- d'intégrité de REFERENCE sur les REFs

ALTER TABLE table_pListRefVols
	ADD (SCOPE FOR (column_value) IS O_VOL);

ALTER TABLE table_aListRefVols
	ADD (SCOPE FOR (column_value) IS O_VOL);

ALTER TABLE O_VOL
	ADD (SCOPE FOR (refPilote) IS O_PILOTE);
ALTER TABLE O_VOL
	ADD (SCOPE FOR (refAvion) IS O_AVION);

-- Cet index est nécessaire pour accélérer l’accès aux éléments 
-- d’une NESTED TABLE attaché à une MEME LIGNE dans la table « MAITRE »

--Création d’un index sur la Nested table table_pListRefVols :
	CREATE INDEX idx_tprv_nested_table_id on table_pListRefVols(NESTED_TABLE_ID)
	TABLESPACE USERS;

--Création d’un index sur la Nested table table_aListRefVols :
	CREATE INDEX idx_tarv_nested_table_id on table_aListRefVols(NESTED_TABLE_ID)
	TABLESPACE USERS;
/*
--	Exemple de création d’indexes sur les colonnes refPilote et refAvion 
-- de la table O_VOL
*/
--Création d’un index sur la colonne refPilote
	CREATE INDEX idx_o_vol_refPilote on O_VOL(refPilote)
	TABLESPACE USERS;

-- Création d’un index sur la colonne refPilote
	CREATE INDEX idx_o_vol_refAvion on O_VOL(refAvion)
	TABLESPACE USERS;

declare
refavion1	REF avion_t:=NULL;
refavion2	REF avion_t:=NULL;
refpilote1	REF pilote_t:=NULL;
refpilote2	REF pilote_t:=NULL;
refVol1	REF vol_t:=NULL;
refVol2	REF vol_t:=NULL;

BEGIN
--Etape 1: Insertion des lignes dans les tables 
--O_PILOTE et O_AVION avec des listes vides

-- insertion dans O_PILOTE
INSERT INTO O_PILOTE OP VALUES ( 
	pilote_t(1, 'ZEMBLA',
                adresse_t(1, 'rue des Miracle',6000, 'NICE'), 
		'0622732123', to_date('01/01/1982', 'DD/MM/YYYY'), 
		30000.00, listRefVols_t()))
		returning ref(op) into refPilote1;
		
INSERT INTO O_PILOTE OP VALUES ( 
	pilote_t(2, 'ZORRO',
                adresse_t(80, 'Avenue Felix Faure',6000, 'Bruxelles'), 
		'0622711111', 
		to_date('25/12/1973','DD/MM/YYYY'), 
		40000.00, listRefVols_t()) )
		returning ref(op) into refPilote2;

-- Insertion à travers les liens par programmation (conseillée)

--Etape 1: Insertion des lignes dans les tables 
--O_PILOTE et O_AVION avec des listes vides

-- Insertion dans la table objet O_AVION

INSERT INTO O_AVION oa VALUES ( 
AVION_T(1,'A320', 'Nice',350, 'En Service', listRefVols_t())) 
returning ref(oa) into refAvion1 ;

INSERT INTO O_AVION  oa VALUES ( 
AVION_T(2,'A310', 'Toulouse',300, 'En Service', listRefVols_t())) 
returning ref(oa) into refAvion2 ;

--Etape 2 : Insertion des lignes dans la table O_VOL
-- avec mise à jour des références

INSERT INTO O_VOL ov 
Values(100, 'Nice', 'Lyon', refPilote1, refAvion1)
Returning ref(ov) INTO refVol1;
INSERT INTO O_VOL OV
Values(110, 'Paris', 'Toulouse', refPilote1, refAvion2)
Returning ref(ov) INTO refVol2;
-- Etape 3 : Mise à jour indirecte des tables imbriquées
-- table_pListRefVols et table_aListRefVols contenant les

-- Insertion indirecte dans table_pListRefVols 
INSERT INTO  TABLE(SELECT p.pListRefVols  FROM o_pilote p
WHERE p.pl# = 1)   values (refVol1);

INSERT INTO  TABLE(SELECT p.pListRefVols  FROM o_pilote p
WHERE p.pl# = 1)   values (refVol2);


-- Insertion indirecte dans table_aListRefVols 
INSERT INTO 
TABLE(SELECT a.aListRefVols  FROM o_avion a WHERE a.av#=1)
values (refVol1);

INSERT INTO 
TABLE(SELECT a.aListRefVols  FROM o_avion a WHERE a.av#=2)
values (refVol2);

END;
/



commit;

-- vérifications
select * from o_pillote;
select * from o_avion;
select * from o_vol;



----------------------------------------------------------------------------------------------------------------
-- M3.3.1. ACITVITES COMPLEMENTAIRES A FAIRE autour de la Mise en oeuvre d'une mini-application pure 
-- objet relationnelle avec les liens d’associations
----------------------------------------------------------------------------------------------------------------

--
-- a) quel est le nom du pilote, le type d''avion et ville de départ
--liés au vol nr 100;

?

-- b) Donner les informations sur les vols
-- assurés par le pilote nr 1

?

--c) Donner le numéro du vol, le nom du pilote et le  
--type d'avion du Vol 100 avec déréférencement implicite. 
--Opérateur .
	
?

	
-- d) Informations sur l'avion participant au VOL 100 
-- avec déréférencement explicite. Opréteur DEREF

?

-- e)Donner les les informations sur les vols assurés
-- par le pilote nr 1
?

-- f) Ecrire un programme PLSQL qui permet d'ajouter deux VOLS qui seront seront liés à l'avion nr 1
-- et au pilote nr 2   

?

-- g)  Ecrire un programme PLSQL qui permet d'ajouter un PILOTE et un AVION, associés à ce pilote cet
-- avion deux nouveaux vols   

?

















