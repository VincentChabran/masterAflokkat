
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Exercice MOOCEBFR3 : Ingénierie des Données du Big Data: SGBD Objet relationnel et SQL3 Oracle
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

****************************************************************************************************************
* Exercices Module M3.3 : Les tables objets, les liens d’associations, exercice libre
****************************************************************************************************************


----------------------------------------------------------------------------------------------------------------
-- M3.3.2. Mise en oeuvre d'une application objet relationnelle libre de bout en bout
-- avec les liens d’associations et des méthodes
-- Exercices impliquant les Modules 1 à 3
-- Le sujet consiste à développer une application de gestion des employes avec deux entités DEPT et EMPLOYE
----------------------------------------------------------------------------------------------------------------

/*


M3.3.2.1 Objectif des exercices et informations sur les entités DEPT et EMPLOYE

Mettre en œuvre l’approche objet relationnel / sql3 Oracle de bout en bout

Les points que nous visons sont :
Concevoir et créer le schéma d'une base de données objet relationnelle
Consulter les objets du schéma en exploitant entre autre les nouveaux opérateurs tels que TABLE, VALUE, ...
Effectuer des insertions, mises à jour et suppressions dans ce schéma en exit
Manipuler des objets dans PL/SQL.


a) Mise en place de l'application par étapes

	Etape 1. Création de types
	
		. Créer les types FORWARD ou INCOMPLETS appropriés si nnécessaire. Il n'est pas nécessaire de définir tous les types en FORWARD
		. Créer le type ARRAY tab_prenoms_t nécessaire pour gérer la liste des PRENOMs
		. Créer le Type Table (liste) nécessaire : ces éléments seront des références vers des EMPLOYE_t
		. Définir les types EMPLOYE_T, DEPT_T,…
		Vous devez y déclarer les champs ou attributs des types, les méthodes.

	Etape 2. Créer des tables objets et des indexes
	
	Etape 3. Insérer les lignes dans les tables via un programme PLSQL
	
	Etape 4. Mise à jour des objets dans les tables objets
	
	Etape 5. Consultation des objets dans les tables objets
	
	Etape 6. Implémentation des méthodes définis sur les types

*/

-- b) Informations nécessaires pour construire les types et tables

-- L'application à créer consiste à gérer des départements et leurs employés
-- Un département peut avoir 0 ou plusieurs Employés. Un Employé est lié à 1 et 1 seul département.

-- b.1) Propriétés de l'entité département à prendre en compte au niveau type et table

/*
Nom entité	: DEPT
                                        	
			Nom des champs	type			Libellé

			DEPTNO	number(4)		Nr. de département doit	être entre 1000 et 9999. Identifiant et Non null
			DNAME	varchar2(30) 	Nom du département {Recherche, RH, Marketing, Ventes, Finance}. Non null
			LOC		varchar2(30)	Localisation du département. Non null
			Définir un champ pour Prendre en compte le lien N (un département peut avoir 0 ou plusieurs employés)
			
			Méthodes à définir sur l'entité DEPT

				i. Les méthodes de consultation

				Définir une méthode de classe qui renvoie des informations (, ...) 
				sur un DEPT connaissant son numéro. Procéder à l’affichage des 
				ces informations
				
				static function getDept (deptno1 IN number) return dept_t

				Définir une méthode de classe qui renvoie la collection d’employées d’un DEPT donné. Afficher ensuite le nom et le pronom de chaque employé. La collection setEmployes_t est à définir
				
				Static function getInfoEmp(deptno1 IN number) return setEmployes_t

				ii. Définir une méthode d'ordre de type MAP pour ordonner les instances du type dept_t

				iii. Les méthodes de gestion de la collection des références vers les employés d'un département

					Introduire pour chaque colonne de type Nested les procédures suivantes :
						. addLinkListeEmployes(RefEmp1 REF Employe_t); -- pour ajouter dans la liste
						. deleteLinkListeEmployes (RefEmp1 REF Employe_t);	-- suppression dans un lien
						. updateLinkListeEmployes(RefEmp1 REF Employe_t,RefEmp2 REF Employe_t);--modification du lien	 


-- b.2) Propriétés de l'entité Employé à prendre en compte au niveau type et table

Nom entité : EMPLOYE	
			Nom des champs	type			Libellé

			EMPNO			number(8)		Numéro Employé. Champs identifiant et Non null
			ENAME		 	varchar2(15) 	Nom EMPLOYE : En lettre capitales et non null
			PRENOMS			varray			tableau de 4 prénom  max
			JOB				Varchar2(20)	Métier de l’employé {Ingénieur,Secrétaire, Directeur, Planton, PDG}
											et non null
			SAL				number(7,2)		Salaire entre 1500 et 15000. Non null	
			CV				CLOB			CV 
			DATE_NAISS		date			Date de Naissance. Non null
			DATE_EMB		date			Date embauche : Non null et doit être supérieure Date_Naiss
			Définir un champ pour prendre en compte le lien 1 (un Employé est dans 1 et 1 seul département)
			
			Méthode à définir sur l'entité EMPLOYE
				i. Définir une méthode d'ordre de type ORDER pour ordonner les instances du type Employe_t
				selon règle suivante: Les employés seront classés du plus puissant au moins puissant.

*/			

----------------------------------------------------------------------------------------------------------------
-- Etape 1. Création de types
----------------------------------------------------------------------------------------------------------------


drop table employe_o cascade constraints;
drop table dept_o cascade constraints;
drop type dept_t force;
drop type employe_t force;
drop type  listRefEmployes_t force;
drop type  setEmployes_t force;
drop type  tabPrenoms_t;
create or replace type dept_t
/

create or replace type tabPrenoms_t as varray(4) of varchar2(40)
/

create or replace type EMPLOYE_T AS OBJECT(	
?
);
/

create or replace type listRefEmployes_t as table of REF employe_t
/

create or replace type setEmployes_t as table of employe_t
/	
create or replace type DEPT_T AS OBJECT(	
?
);
/


/*

----------------------------------------------------------------------------------------------------------------
-- Etape 2. Créer des tables objets et des indexes
----------------------------------------------------------------------------------------------------------------

a) Créer les tables EMPLOYE_O, DEPT_O comme étant des tables objets

Les contraintes d'intégrités
Définir les contraintes d'intégrités d'entités sur chacune des tables (Primary Key)
Définir les contraintes d'intégrités de domaine (cf. les informations en M3.3.2.1 b)

Les Nested Tables
Donner les noms de segments à toutes vos Nested Tables
Format du nom : tableNomColonneNested (le mot table suivi du nom de la colonne nested)

Les LOB internes PCTVERSION doit être à 30 (nous donnons la syntaxe lors de la création de table Employe)
Donner les noms de segments à tous vos LOB internes.
Format du nom : storeNomColonneLOBInterne (le mot store suivi du nom de la colonne LOB interne)

Création des tables
Localisation des objets dans le tablespace par défaut.

*/

create table dept_o of dept_t(
?
)
/


create table employe_o of employe_t(
?
)
LOB (nomLob) STORE AS storeNomLob(PCTVERSION 30)
/



-- b) Création d'indexes

-- Créer un index unique sur la colonne dname de DEPT_o

?
-- Créer un index sur la colonne implicite Nested_table_id de la 
-- Nested Table. Que constatez vous ? Peut - il être unique ?

?

-- Créer un index unique concatené sur la table tableNomColonneNested avec les colonnes Nested_table_id 
-- et Column_value afin d’éviter l’ajout deux fois de la référence d’un employé dans la liste des 
-- références des employés d’un même département 
?

-- Créer un index sur la référence vers un département dans la table employe_o
?



----------------------------------------------------------------------------------------------------------------
-- Etape 3. Insérer les lignes dans les tables via un programme PLSQL
----------------------------------------------------------------------------------------------------------------

-- Insérer 2 Départements et 3 Employés. Un des département aura 2 employés, l'autre 1 employé.
-- L'intégrité des objets doit être assurée

declare
	refDept1	   REF dept_t;
	refDept2	   REF dept_t;
	refEmp1		   REF Employe_t;
	refEmp2		   REF Employe_t;
	refEmp3		   REF Employe_t;
	
begin
?	
end;
/
commit;

-- vérifications
select * from dept_o;

?

select * from employe_o:
?

select ename, oe.refdept.dname
from employe_o oe;
?



----------------------------------------------------------------------------------------------------------------
-- Etape 4. Mise à jour des objets dans les tables objets
----------------------------------------------------------------------------------------------------------------

-- 4.1 Modifier la localité d'un département connaissant son nom

?

-- 4.2 Modifier la date d'embauche d'un Employé connaissant son nom sachant qu'il doit travailler dans 
-- l'un des départements suivants : 'Recherche', 'Finance' ou  'RH'

?

-- 4.3 Supprimer un DEPT et mettre la référence vers le département à null  dans la table employe_o

?

----------------------------------------------------------------------------------------------------------------
-- Etape 5. Consultation des objets dans les tables objets
----------------------------------------------------------------------------------------------------------------

-- 5.1 Faire un Listing des DEPTs triés par nom

?

-- 5.2 Pour un DEPT donné, lister tous les EMPLOYEs qui y travaillent PL/SQL et Procédures stockées
?


----------------------------------------------------------------------------------------------------------------
-- Etape 6. Implémentation des méthodes définis sur les types 
----------------------------------------------------------------------------------------------------------------

-- Implémenter les méthodes décrites plus haut au niveau des types DEPT_T et EMPLOYE_T tester les méthodes  
-- Ci-dessous une implémentation à vide des méthiodes à compléter en remplaçant null par du vrai code. 
-- Le code null permet une implémentation incrémentatale. En effet PLSQL toutes les fonctions d'un package
-- doivent être toutes codées avant d'être testez Les prototypes des fonctions doivent être identiques à la
-- spécification.

-- 6.1 Implémentation des méthodes du type EMPLOYE_T
create or replace type BODY EMPLOYE_T AS 	

order member function compEmp (Emp IN EMploye_t) return number IS
BEGIN
	null;
END;
 
end;
/



-- 6.2 Implémentation des méthodes du type DEPT_T

create or replace type BODY DEPT_T AS 	

static function getDept (deptno1 IN number) 
	return dept_t IS
BEGIN
	null;
END;
Static function getInfoEmp(deptno1 IN number)
	return setEmployes_t IS
BEGIN
	null;
END;
member procedure addLinkListeEmployes(RefEmp1 REF Employe_t) IS
BEGIN
	null;
END;
member procedure deleteLinkListeEmployes (RefEmp1 REF Employe_t) IS
BEGIN
	null;
END;
member procedure updateLinkListeEmployes (RefEmp1 REF Employe_t, 
	RefEmp2 REF Employe_t) IS
BEGIN
	null;
END;
map member function compDept return varchar2 IS
BEGIN
	null;
END;

end;
/

----------------------------------------------------------------------------------------------------------------
-- M3.3.2. ACITVITES COMPLEMENTAIRES A FAIRE autour de la Mise en oeuvre d'une mini-application pure 
-- objet relationnelle avec les liens d’associations
----------------------------------------------------------------------------------------------------------------

-- Tester chaque méthode du type EMPLOYE_T

?
-- Tester chaque méthode du type DEPT_T
?






















