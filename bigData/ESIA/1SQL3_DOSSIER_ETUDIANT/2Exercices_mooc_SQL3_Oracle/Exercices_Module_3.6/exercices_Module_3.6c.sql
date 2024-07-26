

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Exercice MOOCEBFR3 : Ingénierie des Données du Big Data: SGBD Objet relationnel et SQL3 Oracle
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

****************************************************************************************************************
* Exercices Module M3.6 : PLSQL étendu aux objets complexes et Mapping Objet relationnel dans Java/JDBC
****************************************************************************************************************


----------------------------------------------------------------------------------------------------------------
-- Exercices Module M3.6c.1 Mapping Objet relationnel dans Java/JDBC, exemple libre
----------------------------------------------------------------------------------------------------------------

-- Considérons l'application objet relationnelle Employé/Département définie dans les exercices du module 3.3
-- Vous devez pour cette application rendre accessible depuis java. Pour cela vous devez coder les classes
-- suivantes (package rh) :
--		. Employe.java (classes spécifiques)
-- 		. Dept.java (classes spécifiques)
-- 		. RessourcesHumaines.java (classe contenant le main, y traiter 3 requêtes SQL d'accès aux données 
--        de la bases)

-- Compiler et exécuter
 

----------------------------------------------------------------------------------------------------------------
-- M3.6c.2 Activités supplémentaires sur le Mapping Objet relationnel dans Java/JDBC et utilisateur des
-- fonctions des classes java
----------------------------------------------------------------------------------------------------------------

-- a) Analyser le résultat si la compilation et l'exécution ont réussi

-- b) Dans la classe RessourcesHumaines.java, appeler les fonctons getDept et getInfoEmp 
-- du type Dept_t

-- c) Dans la classe RessourcesHumaines.java, écrire une fonction qui permet d'insérer un département 
-- et deux employés. tester cette fonction et montrer que les informations sont bien dans la base de données.