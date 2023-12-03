


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
	EMPNO			number(8),
	ENAME		 	varchar2(15),
	PRENOMS		tabPrenoms_t,
	JOB			Varchar2(20),
	SAL			number(7,2),
	CV				CLOB,
	DATE_NAISS	date,
	DATE_EMB		date,
	refdept		REF dept_t,
	order member function match(emp IN Employe_t) return number
);
/

create or replace type listRefEmployes_t as table of REF employe_t
/

create or replace type setEmployes_t as table of employe_t
/	

create or replace type DEPT_T AS OBJECT(	
	DEPTNO	number(4),
	DNAME		varchar2(30),
	LOC		varchar2(30),
	listRefEmps	listRefEmployes_t,
	map member function match return varchar2,
	static 	function getDept (deptno1 IN number) return dept_t,
	Static 	function getInfoEmp(deptno1 IN number) return setEmployes_t,
	member 	procedure addLinkListeEmployes(RefEmp1 REF Employe_t),
	member 	procedure deleteLinkListeEmployes (RefEmp1 REF Employe_t),
	member 	procedure updateLinkListeEmployes(RefEmp1 REF Employe_t,RefEmp2 REF Employe_t)
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

-- LOC		varchar2(30)	Localisation du département. Non null
DROP table dept_o;

CREATE TABLE  dept_o of dept_t (
    CONSTRAINT pk_dept_o_deptno PRIMARY KEY (DEPTNO),
    CONSTRAINT chk_dept_o_DEPTNO CHECK (DEPTNO BETWEEN 1000 AND 9999),
    CONSTRAINT chk_dept_o_DNAME CHECK (DNAME IN ('Recherche', 'RH', 'Marketing', 'Ventes', 'Finance')),
    DNAME CONSTRAINT nnl_dept_o_DNAME NOT NULL,
    LOC CONSTRAINT nnl_dept_o_LOC NOT NULL
)
NESTED TABLE listRefEmps STORE AS liste_employes_tab
/

DROP table employe_o;

CREATE TABLE employe_o of employe_t (
   CONSTRAINT pk_employe_o_EMPNO PRIMARY KEY (EMPNO),
	CONSTRAINT chk_employe_o_ENAME CHECK (ENAME = UPPER(ENAME)),
	ENAME CONSTRAINT nnl_employe_o_ENAME NOT NULL,
	CONSTRAINT chk_employe_o_JOB CHECK (JOB IN ('Ingenieur','Secretaire', 'Directeur', 'Planton', 'PDG')),
	JOB CONSTRAINT nnl_employe_o_JOB NOT NULL,
	CONSTRAINT chk_employe_o_SAL CHECK (SAL BETWEEN 1500 AND 15000),
	SAL CONSTRAINT nnl_employe_o_SAL NOT NULL,
	DATE_NAISS CONSTRAINT nnl_employe_o_DATE_NAISS NOT NULL,
	DATE_EMB CONSTRAINT nnl_employe_o_DATE_EMB NOT NULL,
	CONSTRAINT chk_employe_o_DATE_EMB CHECK (DATE_EMB > DATE_NAISS)
)
LOB (CV) STORE AS storeCV(PCTVERSION 30)
/



-- b) Création d'indexes

-- Créer un index unique sur la colonne dname de DEPT_o

CREATE UNIQUE INDEX idx_unique_dname ON dept_o (DNAME);
/

-- Créer un index sur la colonne implicite Nested_table_id de la 
-- Nested Table. Que constatez vous ? Peut - il être unique ?

CREATE INDEX idx_nested_table_id ON liste_employes_tab (Nested_table_id);
/


-- Créer un index unique concatené sur la table tableNomColonneNested avec les colonnes Nested_table_id 
-- et Column_value afin d’éviter l’ajout deux fois de la référence d’un employé dans la liste des 
-- références des employés d’un même département 

ALTER TABLE liste_employes_tab
	ADD (SCOPE FOR (Column_value) IS employe_o);

CREATE UNIQUE INDEX idx_liste_employes_tab_Nested_table_id_Column_value 
	ON liste_employes_tab (Nested_table_id, Column_value);


-- Créer un index sur la référence vers un département dans la table employe_o

ALTER TABLE employe_o
	ADD (SCOPE FOR (refdept) IS dept_o);

CREATE INDEX idx_employe_o_refdept on employe_o (refdept);


----------------------------------------------------------------------------------------------------------------
-- Etape 3. Insérer les lignes dans les tables via un programme PLSQL
----------------------------------------------------------------------------------------------------------------

-- Insérer 2 Départements et 3 Employés. Un des département aura 2 employés, l'autre 1 employé.
-- L'intégrité des objets doit être assurée

desc dept_o;


desc employe_o;



declare
   refDept1       REF dept_t;
   refDept2       REF dept_t;
   refEmp1           REF Employe_t;
   refEmp2           REF Employe_t;
   refEmp3           REF Employe_t;
    
begin
    -- Etape 1: Insertion des départements 1000 et 1001
   insert into dept_o od 
      values(1000, 'Recherche', 'Ajaccio', LISTREFEMPLOYES_T())
      RETURNING ref(od) into refDept1
	;
    
   insert into dept_o od 
      values(1001, 'RH', 'Bastia', LISTREFEMPLOYES_T())
      RETURNING ref(od) into refDept2
	;

    -- Etape 2: Insertion des employés du département 1000

   insert into employe_o oe 
      values(employe_t(
         1,
         'NAPOLEON',
         TABPRENOMS_T('Bonapart', 'Empereur'),
         'PDG',
         15000,
         EMPTY_CLOB(),
         TO_DATE('15/08/1769', 'DD-MM-YYYY'),
         TO_DATE('18/05/1804', 'DD-MM-YYYY'),
         refdept1
      )) RETURNING ref(oe) into refEmp1
	;

   insert into employe_o oe 
      values(employe_t(
         2,
         'PAOLI',
         TABPRENOMS_T('Pascal', 'Ange'),
         'Directeur',
         8500,
         EMPTY_CLOB(),
         TO_DATE('06/04/1725', 'DD-MM-YYYY'),
         TO_DATE('12/03/1753', 'DD-MM-YYYY'),
         refdept1
      )) RETURNING ref(oe) into refEmp2
	;

   insert into employe_o oe 
	   values(employe_t(
         3,
         'ORNANO',
         TABPRENOMS_T('Charles'),
         'Ingenieur',
         4200,
         EMPTY_CLOB(),
         TO_DATE('05/05/1919', 'DD-MM-YYYY'),
         TO_DATE('19/02/1994', 'DD-MM-YYYY'),
         refDept2
      )) RETURNING ref(oe) into refEmp3
	;

    -- Etape 3: MAJ de la liste des ref vers les employés du département 1000

	insert into	
	TABLE(select od.listRefEmps
	from dept_o od
	where od.deptno = 1000) lre
	VALUES (refEmp1);

	insert into
	TABLE(select od.listRefEmps
	from dept_o od
	where od.deptno = 1000) lre
	VALUES (refEmp2);

	insert into
	TABLE(select od.listRefEmps
	from dept_o od
	where od.deptno = 1001) lre
	VALUES (refEmp3); 

end;
/
commit;

-- vérifications
select * from dept_o;

?

select * from employe_o;
?

select ename, oe.refdept.dname
from employe_o oe;
?



----------------------------------------------------------------------------------------------------------------
-- Etape 4. Mise à jour des objets dans les tables objets
----------------------------------------------------------------------------------------------------------------

-- 4.1 Modifier la localité d'un département connaissant son nom

UPDATE dept_o do
	SET do.LOC = 'Bonifaccio'
	WHERE do.DNAME = 'Recherche';


-- 4.2 Modifier la date d'embauche d'un Employé connaissant son nom sachant qu'il doit travailler dans 
-- l'un des départements suivants : 'Recherche', 'Finance' ou  'RH'

UPDATE employe_o eo
	SET eo.DATE_EMB = to_date('18/05/1755', 'DD-MM-YYYY')
	WHERE eo.ENAME = 'PAOLI'
	AND eo.refdept.DNAME IN ('Recherche', 'Finance', 'RH');


-- 4.3 Supprimer un DEPT et mettre la référence vers le département à null  dans la table employe_o


declare 
	refDepth1 REF dept_t;

BEGIN
	DELETE FROM dept_o od
	WHERE oe.deptno = 1000
	RETURN ref(od) into refDepth1;

	UPDATE employe_o oe
	SET oe.refdept = NULL
	WHERE oe.refdept = refDepth1;
END;
/

-- Solition 4

declare
	listRefEmps1 LISTREFEMPLOYES_T;

begin
	DELETE FROM dept_o od
	WHERE od.deptno = 1000
	RETURN od.listRefEmps into listRefEmps1;


	for i in listRefEmps1.first .. listRefEmps1.last 
	loop 
		UPDATE employe_o oe
		SET oe.refdept = NULL
		WHERE ref(oe) = listRefEmps1(i);
	end loop;
end;
/


----------------------------------------------------------------------------------------------------------------
-- Etape 5. Consultation des objets dans les tables objets
----------------------------------------------------------------------------------------------------------------

-- 5.1 Faire un Listing des DEPTs triés par nom

SELECT d.DEPTNO, d.DNAME, d.LOC
	FROM dept_o do
	ORDER BY do.DNAME;


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

drop type body EMPLOYE_T;

create or replace type BODY EMPLOYE_T AS     

order member function MATCH (Emp IN EMploye_t) return number IS
	posSelf NUMBER :=0;
	posEmp NUMBER :=0;
	concatSelf VARCHAR2(60) := SELF.ENAME||SELF.EMPNO;
	concatEmp VARCHAR2(60) := Emp.ENAME||Emp.EMPNO;
BEGIN
	CASE SELF.JOB
		WHEN 'PDG' THEN posSelf := 1;
		WHEN 'Directeur' THEN posSelf := 2;
		WHEN 'Ingenieur' THEN posSelf := 3;
		WHEN 'Secretaire' THEN posSelf := 4;
		WHEN 'Planton' THEN posSelf := 5;
	END CASE;

	CASE EMP.JOB
		WHEN 'PDG' THEN posEmp := 1;
		WHEN 'Directeur' THEN posEmp := 2;
		WHEN 'Ingenieur' THEN posEmp := 3;
		WHEN 'Secretaire' THEN posEmp := 4;
		WHEN 'Planton' THEN posEmp := 5;
	END CASE;
		concatSelf := posSelf||concatSelf;
		concatEmp := posEmp|| concatEmp;
		IF concatSelf = concatEmp THEN return 0;
			ELSIF concatSelf > concatEmp THEN return 1;
			ELSIF concatSelf < concatEmp THEN return -1;
		END IF;
END;
 
end;
/



-- 6.2 Implémentation des méthodes du type DEPT_T

create or replace type BODY DEPT_T AS 	

static function getDept (deptno1 IN number) 
	return dept_t IS

	dept1 dept_t;
BEGIN
	select value(od) into dept1
		from dept_o od
		where od.deptno = deptno1;

	return dept1;

	exception 
		WHEN no_data_found then
			raise;
		WHEN others then 
			raise;
END;


Static function getInfoEmp(deptno1 IN number)
	return setEmployes_t IS
	setemp1 setEmployes_t;

BEGIN
-- SELECT  CAST (COLLECT(titre) AS LISTNOMCOURS_T ) FROM O_CURSUS;

	select cast (collect(deref(lre.column_value)) as setEmployes_t) INTO setemp1
	from
		table(select od.listRefEmps
			from dept_o od where od.deptno=deptno1
		)lre;
	return setemp1;

	exception 
		WHEN no_data_found then
			raise;
		WHEN others then 
			raise;
END;


member procedure addLinkListeEmployes(RefEmp1 REF Employe_t) IS
BEGIN
	insert into
		TABLE(select od.listRefEmps
			from dept_o od
			where od.deptno = self.deptno
		) lre
		VALUES (RefEmp1); 

	exception 
		WHEN no_data_found then
			raise;
		WHEN others then 
			raise;
END;

member procedure deleteLinkListeEmployes (RefEmp1 REF Employe_t) IS
BEGIN
	delete from
		TABLE(select od.listRefEmps
			from dept_o od
			where od.deptno = self.deptno
		) lre
		where lre.column_value = RefEmp1; 

	exception 
		WHEN no_data_found then
			raise;
		WHEN others then 
			raise;
END;

member procedure updateLinkListeEmployes (RefEmp1 REF Employe_t, 
	RefEmp2 REF Employe_t) IS
BEGIN
	UPDATE
		TABLE(select od.listRefEmps
			from dept_o od
			where od.deptno = self.deptno
		) lre
		set lre.column_value = RefEmp2
		where lre.column_value = RefEmp1; 

	exception 
		WHEN no_data_found then
			raise;
		WHEN others then 
			raise;
END;

map member function match return varchar2 IS
BEGIN
	return loc || dname || deptno;
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

set serveroutput on
declare 
    dept1 dept_t;
    deptno1 dept_o.deptno%type :=1000;
begin
    dept1 := dept_t.getDept(deptno1);
    dbms_output.put_line('nr dept :' || dept1.deptno);
    dbms_output.put_line('nom dept :' || dept1.dname);
    dbms_output.put_line('loc dept :' || dept1.loc);
    
    exception
    when no_data_found then 
        dbms_output.put_line('Le departement nr ' || deptno1 || 'n''existe pas');
        dbms_output.put_line('sqlcode' || sqlcode);
        dbms_output.put_line('sqlerrm' || sqlerrm);
end;
/





declare 
	refDept1000 ref dept_t;
	dept1000 dept_t;
	emp4 employe_t:= employe_t(
         4,
         'MONSTRE',
         TABPRENOMS_T('Dracula', 'Givaudon'),
         'Planton',
         1500,
         EMPTY_CLOB(),
         TO_DATE('05/05/1919', 'DD-MM-YYYY'),
         TO_DATE('19/02/1994', 'DD-MM-YYYY'),
         null
      );
	refEmp4 ref employe_t;


begin 
	select value(od), ref(od) into dept1000, refDept1000
		from dept_o od
		where od.deptno = 1000;

	emp4.refDept:= refDept1000;

	insert into employe_o oe values (emp4) RETURNING ref(oe) into refEmp4;
	dept1000.addLinkListeEmployes(refEmp4);
end;
/
commit;



