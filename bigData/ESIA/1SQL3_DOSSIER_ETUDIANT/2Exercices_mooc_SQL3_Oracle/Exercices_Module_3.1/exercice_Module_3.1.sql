/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Exercice MOOCEBFR3 : Ingénierie des Données du Big Data: SGBD Objet relationnel et SQL3 Oracle
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

****************************************************************************************************************
* Exercices Module M3.1 : Introduction, les types de base, les types abstraits, les pointeurs REFs 
* et les collections dans SQL3
* L'objectif ici est de mettre en oeuvre par la pratage notion de type (création, modification, suppression,
* méthodes d'ordre, méthodes applicatives) dans SQL3 
****************************************************************************************************************
*/

----------------------------------------------------------------------------------------------------------------
-- M3.1.1. Créer la spécification et le corps du type Pilote2 
----------------------------------------------------------------------------------------------------------------

-- M3.1.1.1 Création du type adresse1_t
drop type  pilote1_t force;
drop type adresse1_t force;

CREATE OR REPLACE TYPE adresse1_t as object(
			Numero			NUMBER(4),
			Rue			VARCHAR2(20),
			Code_Postal		NUMBER(5),
			Ville			VARCHAR2(20),
			quartier		VARCHAR2(20)
);
/


-- M3.1.1.2 Création de la spécification du type PILOTE

CREATE OR REPLACE TYPE pilote1_t AS OBJECT(
	PL#		NUMBER(4),
	nom		VARCHAR2(12),
	adresse		adresse1_t, -- type abstrait défini préalablement
	Tel			VARCHAR2(12),
	dnaiss		DATE,
	salaire		NUMBER(7,2),
MEMBER FUNCTION getPiloteSalaire RETURN NUMBER,
MEMBER FUNCTION setPiloteSalaire(SELF IN OUT pilote1_t, 
	plNum IN NUMBER, 
	newSalaire	IN NUMBER) RETURN BOOLEAN,
MEMBER PROCEDURE testSetSalaire( plnum IN number, newSalaire IN number),
PRAGMA RESTRICT_REFERENCES(getPiloteSalaire, WNDS),
PRAGMA RESTRICT_REFERENCES(setPiloteSalaire,RNPS)
);
/

-- M3.1.1.3 Création du corps du type PILOTE

CREATE OR REPLACE TYPE BODY pilote1_t  IS
MEMBER FUNCTION getPiloteSalaire RETURN NUMBER IS
	BEGIN
		RETURN salaire;
	END;
MEMBER FUNCTION setPiloteSalaire (SELF IN OUT pilote1_t, 
plNum IN NUMBER, newSalaire IN NUMBER) RETURN BOOLEAN IS
	BEGIN
		IF pl# = plNum THEN
			salaire := newSalaire;
			return true;
		ELSE
			return false;
		END IF;
	END;
MEMBER PROCEDURE testSetSalaire( plnum IN number, newSalaire IN number) IS
		retour	BOOLEAN;
	BEGIN
	 	retour := Self.setPiloteSalaire(plnum, plnum);
	END;
END;
/

-- M3.1.1.4 Activités sur la spécification et le corps du type pilote1_t
-- Ecrire un programme PLSQL qui permet :
-- a) créer 3 pilotes
-- b) Modifier le salaire de chaque pilote en utilisant les fonctions appropriées
-- c) afficher les nouveaux salaires

----------------------------------------------------------------------------------------------------------------
-- M3.1.2. Créer la spécification et le corps du type 
----------------------------------------------------------------------------------------------------------------

-- M3.1.2.1 Création de la spécification du type complex

CREATE TYPE Complex AS OBJECT ( 
   rpart REAL,
   ipart REAL,
   MEMBER FUNCTION plus (x Complex) RETURN Complex,
   MEMBER FUNCTION less (x Complex) RETURN Complex,
   MEMBER FUNCTION times (x Complex) RETURN Complex,
   MEMBER FUNCTION divby (x Complex) RETURN Complex
);
/

-- M3.1.2.2 Création de la spécification du type complex

CREATE TYPE BODY Complex AS 
   MEMBER FUNCTION plus (x Complex) RETURN Complex IS 
   BEGIN
         RETURN Complex(rpart + x.rpart, ipart + x.ipart);
   END plus;
   MEMBER FUNCTION less (x Complex) RETURN Complex IS
   BEGIN
      RETURN Complex(rpart - x.rpart, ipart - x.ipart);
   END less;
-- Suite
MEMBER FUNCTION times (x Complex) RETURN Complex IS
   BEGIN
      RETURN Complex(rpart * x.rpart - ipart * x.ipart, 
                     rpart * x.ipart + ipart * x.rpart);
   END times;
   MEMBER FUNCTION divby (x Complex) RETURN Complex IS
      z REAL := x.rpart**2 + x.ipart**2;
   BEGIN
      RETURN Complex((rpart * x.rpart + ipart * x.ipart) / z, 
                     (ipart * x.rpart - rpart * x.ipart) / z);
   END divby;
END;
/

-- M3.1.2.3 Activités sur : la création de la spécification du type complex

-- a) Tester chaque méthode du type Complex
-- b) Dans le système de nombres vous avez les type ENTIER, REEL, etc. Comprenez vous 
-- l'intérêt du  type complexe ici? 

----------------------------------------------------------------------------------------------------------------
-- M3.1.3. Implémentation des méthodes d'ordre de type MAP ou ORDER
----------------------------------------------------------------------------------------------------------------

-- M3.1.3.1 Exemple SANS les  méthodes MAP et ORDER
drop table adresse1_table;
drop type adresse1_t force;

CREATE OR REPLACE TYPE adresse1_t as object(
			Numero			NUMBER(4),
			Rue				VARCHAR2(20),
			Code_Postal		NUMBER(5),
			Ville			VARCHAR2(20),
			quartier		VARCHAR2(20)
);
/
CREATE TABLE adresse1_table(adr adresse1_t );

INSERT INTO adresse1_table VALUES (
	adresse1_t(1, 'rue du congres', 6000, 'Nice', 'Centre'));
INSERT INTO adresse1_table VALUES (
	adresse1_t(3, 'rue du congres', 6000, 'Nice', 'Centre'));
INSERT INTO adresse1_table VALUES(
	adresse1_t(2, 'rue des garages', 6100, 'Nice', 'Nord'));
INSERT INTO adresse1_table VALUES(
	adresse1_t(2, 'rue du port', 6300, 'Nice', 'Ouest'));

select * from adresse1_table; 

SELECT * FROM adresse1_table  ORDER BY adr;
?



-- M3.1.3.2 Méthode d'ordre de type MAP

-- M3.1.3.2.1  Exemple avec une méthode d'ordre de type MAP

drop table adresse1_table;
drop type adresse1_t force;

CREATE OR REPLACE TYPE adresse1_t as object(
			Numero			NUMBER(4),
			Rue				VARCHAR2(20),
			Code_Postal		NUMBER(5),
			Ville			VARCHAR2(20),
			quartier		VARCHAR2(20),
			MAP MEMBER FUNCTION compAdresse RETURN VARCHAR2,
			PRAGMA RESTRICT_REFERENCES (compAdresse, WNDS, WNPS, RNPS, RNDS)
);
/

CREATE OR REPLACE TYPE BODY adresse1_t IS 
	MAP MEMBER FUNCTION compAdresse RETURN VARCHAR2 IS
	BEGIN
		  RETURN ville||rue||numero;
	END;
END;
/

-- NOTE : La valeur de Comparaison des instance de de adresse1_t
-- sera : ville||rue||numero. Ce qui réduit la comparaison à celle d ’un type scalaire Oracle

-- création de la table 
CREATE TABLE adresse1_table(adr adresse1_t );

INSERT INTO adresse1_table VALUES (
	adresse1_t(1, 'rue du congres', 6000, 'Nice', 'Centre'));
INSERT INTO adresse1_table VALUES (
	adresse1_t(3, 'rue du congres', 6000, 'Nice', 'Centre'));
INSERT INTO adresse1_table VALUES(
	adresse1_t(2, 'rue des garages', 6100, 'Nice', 'Nord'));
INSERT INTO adresse1_table VALUES(
	adresse1_t(2, 'rue du port', 6300, 'Nice', 'Ouest'));

select * from adresse1_table; 

SELECT * FROM adresse1_table  ORDER BY adr;



-- M3.1.3.3 Méthode d'ordre de type ORDER

-- M3.1.3.3.1  Exemple avec une méthode d'ordre de type ORDER

-- Nous souhaitons classer les adresses selon leur position géographique. Nord, Centre, Sud, Est et enfin 
-- Ouest. MAP MEMBER ne suffit plus.

drop table adresse1_table;
drop type adresse1_t force;

CREATE OR REPLACE TYPE adresse1_t as object(
		Numero			NUMBER(4),
		Rue				VARCHAR2(20),
		Code_Postal		NUMBER(5),
		Ville			VARCHAR2(20),
		quartier		VARCHAR2(20),
		ORDER MEMBER FUNCTION compAdresse (adr IN  adresse1_t) RETURN NUMBER,
		PRAGMA RESTRICT_REFERENCES (compAdresse, WNDS, WNPS, RNPS, RNDS)
);


CREATE OR REPLACE TYPE BODY adresse1_t AS 
ORDER MEMBER FUNCTION compAdresse (adr IN  adresse1_t ) RETURN NUMBER IS
	position1 NUMBER :=0;	
	position2 NUMBER :=0;	
	concAdr1 VARCHAR2(60) := SELF.ville||SELF.rue||SELF.numero;
	concAdr2 VARCHAR2(60) := adr.ville|| adr.rue|| adr.numero;


BEGIN	
	CASE SELF.quartier 
			WHEN 'Nord' THEN position1 := 1;
			WHEN 'Centre' THEN position1 := 2;
			WHEN 'Sud' THEN position1 := 3;
			WHEN 'Est' THEN position1 := 4;
			WHEN 'Ouest' THEN position1 := 5;
	END CASE;
	CASE adr.quartier 
			WHEN 'Nord' THEN position2 := 1;
			WHEN 'Centre' THEN position2 := 2;
			WHEN 'Sud' THEN position2 := 3;
			WHEN 'Est' THEN position2 := 4;
			WHEN  'Ouest' THEN position2 := 5;
	END CASE;

	 concAdr1 :=  position1||concAdr1;
	 concAdr2 := position2|| concAdr2;

	IF concAdr1 = ConcAdr2 	THEN return 0;
	ELSIF concAdr1 > ConcAdr2 	THEN return 1; 
	ELSIF concAdr1 < ConcAdr2 	THEN return -1; 
	END IF;

END;
END;
/

CREATE TABLE adresse1_table(adr adresse1_t );

INSERT INTO adresse1_table VALUES (
	adresse1_t(1, 'rue du congres', 6000, 'Nice', 'Centre'));
INSERT INTO adresse1_table VALUES (
	adresse1_t(3, 'rue du congres', 6000, 'Nice', 'Centre'));
INSERT INTO adresse1_table VALUES(
	adresse1_t(2, 'rue des garages', 6100, 'Nice', 'Nord'));
INSERT INTO adresse1_table VALUES(
	adresse1_t(2, 'rue du port', 6300, 'Nice', 'Ouest'));

select * from adresse1_table; 

SELECT * FROM adresse1_table  ORDER BY adr;




-- M3.1.3.3.2  Activités sur la méthode d'ordre de type ORDER et MAP

-- a) quel est la différence entre une méthode d''ordre de type ORDER ou de type MAP

-- b) quel est la méthode la plus rapide. Faites des mésures

-- c) quand utilise une méthode d''ordre de type MAP

-- d) quand utilise une méthode d''ordre de type MAP

-- c) Ecrire un programme PLSQL qui permet de comparer deux du typeComplex. 
-- S'il manque une méthode d'ordre à ce type ajouter là et réexécutez votre programme.
https://fr.wikipedia.org/wiki/Nombre_complexe
