

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Exercice MOOCEBFR3 : Ingénierie des Données du Big Data: SGBD Objet relationnel et SQL3 Oracle
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

****************************************************************************************************************
* Exercices Module M3.6 : PLSQL étendu aux objets complexes et Mapping Objet relationnel dans Java/JDBC
****************************************************************************************************************

----------------------------------------------------------------------------------------------------------------
-- Exercices Module M3.6.1 Mise en œuvre des procédures externes étape par étape
----------------------------------------------------------------------------------------------------------------

-- Vous devez avoir crées une librairie dynamque contenant la fonction qui calcule le factoriel

-- Les CALL OUT de PL/SQL OBJET

-- Mise en œuvre des procédures externes étape par étape

-- Etape 1 : Fixer les variables  d’environnements
-- Etape 2 : Identifier la DLL contenant la procédure externe
-- Etape 3 : Publier la procedure externe
-- Etape 4 : Utiliser la procedure externe

-- Etape 1 : Fixer les variables  d’environnements

-- L’administrateur doit configurer la base pour exécuter les procédures externes écrites en C
-- Configurer l’agent extproc dans les fichiers listener.ora et tnsnames.ora
-- Démarrer un listener EXCLUSIVEMENT pour les procédures externes
-- Le listener doit préciser les variables d’environnement tels que :
-- ORACLE_HOME, 
-- ORACLE_SID, 
-- LD_LIBRARY_PATH

Dans TNSNAMES.ORA
EXTPROC_CONNECTION_DATA =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SID = PLSExtProc)
    )
  )

DANS LISTENER.ORA
   (SID_DESC =
      (SID_NAME = PLSExtProc)
      (ORACLE_HOME = C:\APP\ORACLE\db_1)
      (PROGRAM = extproc)
      (ENVS=
	"EXTPROC_DLLS=ONLY: 'D:\Cours\oracleSql3\callBack\TestCallExternalC\TestCallExternalC.dll "
      )
    )
	
--version C++
'D:\Cours\oracleSql3\callBack\TestCallExternalCPP\TestCallExternalCPP.dll';

-- NOTA : Il faut ensuite arrête et redémarrer le listener


-- Etape 2 : Identifier la DLL contenant la procédure externe

-- Créer un objet library dans la base de données

Sqlplus tpsql3/tpsql3@orcl

-- Avec une dll C
CREATE OR REPLACE LIBRARY  TestCallExternalC
	IS 'D:\Cours\oracleSql3\callBack\TestCallExternalC\TestCallExternalC.dll';

-- Avec une dll C++
CREATE OR REPLACE LIBRARY  TestCallExternalCPP
	IS 'D:\Cours\oracleSql3\callBack\TestCallExternalCPP\TestCallExternalCPP.dll’;

-- Nota : Il est utile de donner le chemin complet vers la librairie

-- Etape 3 : Publier la procedure externe

-- La procédure doit être publiée à travers une procédure PL/SQL qui indique le langage d’'implémentation et la -- signature C: int c_calcFactorial (int n)

CREATE OR REPLACE FUNCTION plsql_c_calcFactorial (n BINARY_INTEGER) 
return BINARY_INTEGER
AS LANGUAGE C
NAME "c_calcFactorial"
LIBRARY TestCallExternalC;
/

-- Etape 4 : Utiliser la procédure externe

Sqlplus tpsql3/tpsql3@orcl

Set serveroutput on

Declare
Fact 	number:=0;
i		number:=5;
Begin
	Fact:= plsql_c_calcFactorial(i);
	Dbms_output.put_line('Factoriel de '|| I || '= '|| fact);
End;
/

-- résultat
?


