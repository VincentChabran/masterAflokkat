----------------------------------------------------------------------------------------------------------
-- 1. Installer R dans le VM Oracle
----------------------------------------------------------------------------------------------------------

Déjà installé.
Rien à faire

----------------------------------------------------------------------------------------------------------
-- 2.1 Télécharger et Installer le package (driver) spécifique ROracle
----------------------------------------------------------------------------------------------------------

Déjà installé 
Rien à faire

----------------------------------------------------------------------------------------------------------
-- 2.2. Installer le package DBI
----------------------------------------------------------------------------------------------------------

Déjà installé 
Rien à faire

----------------------------------------------------------------------------------------------------------
-- 3. Connexion et prise en main
-- Au prochaine connexion faire d'abord 3.1 à 3.4
-- avant d'envoyer des requêtes
----------------------------------------------------------------------------------------------------------
# 3.1 chargement de la librairie		
> library('ROracle')	

# 3.2 chargement du driver	
> drv <- dbDriver("Oracle")

# 3.3 Nom de la chaine de connexion à la base
> ORCL <-"(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = orcl)))"

# 3.4 Connexion à la base
> con <- dbConnect(drv, username = "MOPOLO", password = "xxx",dbname=ORCL) 

# Exécution d''une requête SQL
> rs <- dbSendQuery(con, "SELECT name, address, dnaiss FROM userProfile_hive_ext UNION ALL SELECT name, address, dnaiss FROM emp_hive_hadoop_ext")

# Affichage du résultat
> fetch(rs)
    NAME                              ADDRESS      DNAISS
1 Kasadi          5 rue des pretres a Mougins  11/09/1980
2    joe         12 rue du Congres a Valbonne  11/11/1960
3   jack       11 rue du Begonias a Vallauris  13/11/1955
4  Alumu 60 Traverse des escaliers a Valbonne  11/08/1948
5   john      13 Avenue de Marseille a Cassis  11/11/1962
6 Malula        61 Avenue du port a Vallauris  06/11/1957
7  KING                                PARIS   11/11/1989
8  KONG                             YONGKONG   11/11/1995
9 BLECK                              BRISTOl   12/12/2000


