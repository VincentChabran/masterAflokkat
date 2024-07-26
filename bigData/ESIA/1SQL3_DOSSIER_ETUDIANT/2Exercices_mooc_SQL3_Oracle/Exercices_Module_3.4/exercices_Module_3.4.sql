
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Exercice MOOCEBFR3 : Ingénierie des Données du Big Data: SGBD Objet relationnel et SQL3 Oracle
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

****************************************************************************************************************
* Exercices Module M3.4 : Lien d’héritage et le Mapping objet des tables relationnelles SQL2 via les vues
****************************************************************************************************************


----------------------------------------------------------------------------------------------------------------
-- M3.4.1 Lien d’héritage
----------------------------------------------------------------------------------------------------------------

-- L'Héritage est le mécanisme de transmission des propriétés d’un type vers les types dérivés.
-- Oracle supporte depuis la version 9, l’héritage simple
-- Pour hériter d'un type il doit être défini : NOT FINAL

-- M3.4.1.1 Mise en place d'une hiérarchie de type
drop table o_personne4;
drop type Personne4_t force;
drop type Employeh4_t force;

CREATE OR REPLACE TYPE Personne4_t AS OBJECT(
	numInsee	varchar2(30),
	nom		 	varchar2(20),
	Prenom	 	varchar2(20),
	DateNaiss	date,
	MEMBER  PROCEDURE  afficher 
) NOT FINAL;
/

CREATE OR REPLACE TYPE Employeh4_t UNDER Personne4_t (
	salaire      number(7,2)
);
/

-- Création de la table o_personne4 pour gérer les instances de types dans la hiérarchie
CREATE TABLE o_personne4 of Personne4_t(
constraint pk_o_personne4 primary key(numInsee),
Prenom Constraint nl_o_personne4_prenom not null,
datenaiss Constraint nl_o_personne4_datenaiss not null
);

-- insertion d'une personne
INSERT INTO o_personne4
VALUES(Personne4_t('122222', 'Dong', 'Jing Tong', to_date('10/10/1982', 'DD/MM/YYYY')));

-- insertion d'un employé
INSERT INTO o_personne4
VALUES(Employeh4_t('222222', 'Dong', 'Fei Fei', to_date('10/10/1992', 'DD/MM/YYYY'),10000.0)); 
Select * from o_personne4; 

----------------------------------------------------------------------------------------------------------------
-- M3.4.1.2 Activité supplémentaire sur l'héritage
----------------------------------------------------------------------------------------------------------------

-- a) Insérer 2 nouvelles personnes et deux nouveaux employes 
?

-- b) Afficher toutes les personnes
?

-- c) Afficher tous les Employés avec leurs salaires
?

-- d) Modifier le salaire d'un employé connaissant son numéro
?

-- e)Créer un index sur chacune des colonnes suivantes : nom, salaire
?

-- f)Créer un type Retraite4_t qui hérite de personne avec les champs : DateRetraite et MontantPension

-- g) Afficher toutes les personnes. S'il s'agit d'un Employé, indiquer EMPLOYE, s'il s'agit retraité :
-- indiquer RETRAITE
?

-- h) Créer un index sur chacune des colonnes suivantes : DateRetraite
?

----------------------------------------------------------------------------------------------------------------
-- M3.4.2 Mapping objet des tables relationnelles SQL2 via les vues
----------------------------------------------------------------------------------------------------------------

-- M3.4.2.1 Création des tables relationnelles
CREATE TABLE R_DEPT4(		
DEPTNO	number(4) constraint pk_R_DEPT4_deptno primary key,
DNAME	varchar2(30)constraint chk_R_DEPT4_dname check(dname 
		in('Recherche','RH', 'Marketing','Ventes', 'Finance')),
LOC	varchar2(30),
constraint chk_R_DEPT4_deptno check(deptno between 1000 and 9999)
)
/
CREATE TABLE R_EMPLOYE4(	
EMPNO		number(8) constraint pk_R_EMPLOYE4_empno primary key,
ENAME		varchar2(15)constraint chk_R_EMPLOYE4_ename check (ename =upper(ename)), 
JOB			Varchar2(20) constraint chk_R_EMPLOYE4_job check 
			(job IN ('Ingénieur','Secrétaire', 'Directeur', 'PDG', 'Planton')),	
SAL			number(7,2),		
CV			CLOB,		
DATE_NAISS	date,		
DATE_EMB	date,
deptno		number(4) constraint fk_r_emp_R_DEPT4 references R_DEPT4(deptno),
			constraint chk_r_emp4_date_e_date_n check (date_emb>date_naiss)
)
/


-- M3.4.2.2 Insérer 2 départements et 3 employés dans les tables relationnelles

-- Copier les lignes disponibles les tables objets dept_o et employe_o
-- voir les exercices Module M3.3 : Les tables objets, les liens d’associations, exercice libre
-- ou insérer directement des lignes dans les 2 tables relationnelles


-- M3.4.2.3 Création des types pour les vues objets

DROP TYPE EMPLOYE4_T FORCE
/
DROP TYPE DEPT4_T FORCE
/
DROP TYPE tabPrenoms4_t 
/
drop TYPE listRefEmployes4_t
/
CREATE OR REPLACE TYPE EMPLOYE4_T
/
CREATE OR REPLACE TYPE tabPrenoms4_t AS VARRAY(4) OF varchar2(20)
/
create or replace type listRefEmployes4_t as table of ref EMPLOYE4_T
/
CREATE OR REPLACE TYPE DEPT4_T AS OBJECT(		
DEPTNO			number(4),
DNAME			varchar2(30),
LOC				varchar2(30),
listEmployes	listRefEmployes4_t
)
/

CREATE OR REPLACE TYPE EMPLOYE4_T AS OBJECT(	
EMPNO			number(8),	
ENAME			varchar2(15), 
JOB				Varchar2(20),	
SAL				number(7,2),		
CV				CLOB,		
DATE_NAISS		date,		
DATE_EMB		date,
deptno			number(4),
refDept			REF DEPT4_T	
)
/	

-- M3.4.2.3 Création des vues objets

-- création des vues v_dept4 et v_employe4
-- Ces 2 vues ont des références circulaires. La création se fait en trois étapes:
-- Etape 1 : Créer la vue v_employe4 sans référence vers les lignes accessibles via la vue v_dept4 
-- Etape 2. Créer la vue v_dept4 avec référence à v_employe4
-- Etape 3. Recréer la vue v_employe4 avec référence vers les lignes accessibles via la vue v_dept4 


-- Etape 1 : Créer la vue v_employe4 sans référence vers les lignes accessibles via la vue v_dept4 
CREATE OR REPLACE  VIEW v_employe4 OF EMPLOYE4_T
WITH OBJECT IDENTIFIER(empno) AS
SELECT rv.empno, rv.ename, rv.job, rv.sal,
rv.cv, rv.DATE_NAISS, rv.date_emb, rv.deptno, null
FROM R_EMPLOYE4 rv;

-- Etape 2. Créer la vue v_dept4 avec référence à v_employe4

CREATE OR REPLACE  VIEW v_dept4 OF DEPT4_T
WITH OBJECT IDENTIFIER(deptno) AS
SELECT rp.deptno, rp.dname, rp.loc, 
CAST(MULTISET(select ref(v) 
from v_employe4 v 
where v.deptno=rp.deptno) AS listRefEmployes4_t)
FROM R_DEPT4 rp;

-- Etape 3. Recréer la vue v_employe4 avec référence vers les lignes accessibles via la vue v_dept4 
CREATE OR REPLACE  VIEW v_employe4 OF EMPLOYE4_T
WITH OBJECT IDENTIFIER(empno) AS
SELECT rv.empno, rv.ename, rv.job, rv.sal,
rv.cv, rv.DATE_NAISS, rv.date_emb, rv.deptno,
MAKE_REF(v_dept4, rv.deptno)
FROM R_EMPLOYE4 rv;

----------------------------------------------------------------------------------------------------------------
-- M3.4.2.4 Activités supplémentaires à faire sur les vues objets sur les tables relationnelles
----------------------------------------------------------------------------------------------------------------


-- Consulter à travers ses vues. Utiliser les liens
?

-- Insérer un département et un employé à travers 
-- les vues. Vérifier qu’ils s’auto-référencent
?

-- Créer un trigger INSTEAD OF permettant d’insérer un 
-- département dans les tables R_DEPT4 et o_dept

?
