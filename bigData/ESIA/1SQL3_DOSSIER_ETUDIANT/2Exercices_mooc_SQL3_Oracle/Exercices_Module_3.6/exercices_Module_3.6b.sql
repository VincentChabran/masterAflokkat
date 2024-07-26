

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Exercice MOOCEBFR3 : Ingénierie des Données du Big Data: SGBD Objet relationnel et SQL3 Oracle
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

****************************************************************************************************************
* Exercices Module M3.6 : PLSQL étendu aux objets complexes et Mapping Objet relationnel dans Java/JDBC
****************************************************************************************************************


----------------------------------------------------------------------------------------------------------------
-- Exercices Module M3.6b.1 Mapping Objet relationnel dans Java/JDBC
----------------------------------------------------------------------------------------------------------------

-- Mapping des objets complexes Oracle avec Java/JDBC avec des classes spécialisées

-- Cette approche permet de faire un mapping 1:1 entre un type Oracle et une classe Java de même structure

-- Cette approche nécessite de suivre les étapes   suivantes :
-- Etape 1 : Définir vos types objets dans la base de données Oracle 
-- Etape 2 : Créer dans la base des tables objets ou relationnelles utilisant ces types
-- Etape 3 : Créer sous java des classes correspondantes aux types définis dans l’étape 1
-- Etape 4 : Lier les types Oracle aux classes Java correspondantes et charger les objets de la base 
-- vers les classes java



--Etape 1 : Définir vos types objets dans la base de données Oracle 

-- Suppression des tables et des types
Drop table o_tableau cascade constraints;
Drop table o_artiste cascade constraints;
Drop type tableau_t force;
Drop type artiste_t force;
Drop type arrayPrenoms_t force;
Drop type listRefTableaux_t ;

-- 	Déclaration Forward des Types afin d'éviter l'interblocage dû au reférencement mutuel entre types

CREATE OR REPLACE TYPE artiste_T
/

--Création du type varray (arrayPrenoms_t) pour stocker les prénoms
Create or replace type arrayPrenoms_t as varray(4) of varchar2(30)
/

-- Création du type tableau_t
Create or replace type tableau_t as object(
	taid	 		 number(8),
	tanom	 		 varchar2(200),
	tadateAchat	 date,
	refArtiste  	 	 REF artiste_t)
/
--Création du type table (listRefTableaux_t) : Les éléments de cette liste sont des références vers des tableaux.

CREATE OR REPLACE TYPE listRefTableaux_t  AS TABLE OF REF tableau_t
/
-- Création du type artiste_t
Create or replace type artiste_t as object(
	arid	 		 number(8),
	arnom	 		 varchar2(200),
	arprenoms		 arrayPrenoms_t,
	arcv		        clob,
	listRefTabs  	listRefTableaux_t)
/

-- Création de la table objet o_tableau
Create table O_tableau of tableau_t(
Constraint pk_o_tableau_taid primary key(taid)
)
/

-- Création de la table o_artiste
Create table O_artiste of tartiste_t(
Constraint pk_o_artiste_arid primary key(arid)
)
Nested table listRefTabs store as storeListRefTabs;
/



Etape 2 : Créer dans la base des tables objets ou relationnelles utilisant ces types

declare
	refArt1      REF Artiste_t;
	refArt2      REF Artiste_t;
	refTab1	     REF Tableau_t;
	refTab2	     REF Tableau_t;
	refTab3	     REF Tableau_t;
begin
--  1: Insertion des artistes (liste REF tableaux vide)
insert into o_artiste oa
values(1, 'VAUDIER',ARRAYPRENOMS_T('Benjamin', 'Ben'), 'CV BEN', 
LISTREFTABLEAUX_T() ) returning ref(oa) into refArt1;

insert into o_artiste oa
values(2, 'CEZANNE',ARRAYPRENOMS_T('Paul'), 'CV CEZANNE', 
LISTREFTABLEAUX_T() ) returning ref(oa) into refArt2;

-- 2: Insertion des tableaux avec maj de la Ref vers l'artiste
insert into o_tableau ot values(1, 'Faire le contraire', 
to_date('10-10-2012', 'DD-MM-YYYY'),refArt1 ) 
returning ref(ot) into refTab1;

insert into o_tableau ot values(2, 'Les joueurs de cartes', 
to_date('31-12-1901', 'DD-MM-YYYY'),refArt2) 
returning ref(ot) into refTab2;

-- 2: Insertion des tableaux avec maj de la Ref vers l'artiste (suite)
insert into o_tableau ot
values(3, 'Le garçon au Gilet rouge', 
to_date('10-10-1900', 'DD-MM-YYYY'),refArt2) 
returning ref(ot) into refTab3;

-- 3: Mise à jour de la liste des références vers les artistes
insert into TABLE(select oa.listRefTabs 
from o_artiste oa where oa.arid=1)
values (refTab1);

insert into TABLE(select oa.listRefTabs 
from o_artiste oa where oa.arid=2)
values (refTab2);

insert into TABLE(select oa.listRefTabs 
from o_artiste oa where oa.arid=2)
values (refTab3);

end;
/

-- Etape 3: Mapping objet relationnel sous Java

-- Etape 3.1: Installer un IDE si ce n'est déjà fait

-- Etape 3.2: Créer un projet java

-- Etape 3.3: Sous src, Créer un package appelé : galerie

-- Etape 3.4: ajouter dans le package "galerie" les 3 trois classes disponibles dans 
-- le dossier :classesModule3.6b

-- Etape 3.5: Adapter dans la classe Galerie.java la ligne de connexion (mettre le bon user, le bon pass 
-- et la bonne base Oracle.

-- Etape 3.6: Adapter les lignes de mapping des types Oracles et des classes spécifiques java 
-- si correspondntes si utile

-- Etape 3.7: Compiler, exécuter et analyser le résultat


----------------------------------------------------------------------------------------------------------------
-- M3.6b.2 Activités supplémentaires sur mapping objet relationnel avec java
----------------------------------------------------------------------------------------------------------------

-- a) Dans la classe Galerie.java, définir un statement pour traiter la requête SQL qui répond au
-- au texte suivant :
-- Renvoyer les informations sur les tableaux d'un artite pour lequel on connait le numéro.

-- b) Dans la classe Galerie.java, écrire une fonction qui permet d'insérer un artiste et deux de ses tableaux
-- tester cette fonction et montrer que les informations sont bien dans la base de données.