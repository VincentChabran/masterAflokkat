----------------------------------------------------------------------------------------------------------
-- 1. Installer R
----------------------------------------------------------------------------------------------------------

https://cran.r-project.org/bin/windows/base/old/3.6.0/
cliquer  sur : R-3.6.0-win.exe
Une fois télécharger, double cliquer sur R-3.6.0-win.exe
Choisir le dossier (exemple : D:/1agm05092005/5Logiciels_new/R/) ou vous voulez installer R pendant le dialogue

Une fois installé
Modifier le PATH Windows pour ajouter le chemin suivant :
exemple
D:\1agm05092005\5Logiciels_new\R\R-3.6.0\bin
Mettre ce chemin au début de la variable d''environnement PATH.

Ouvrir un CMD et Lancer R. On obtient le prompt siuivant :
>

2. Se connecter une à une BD : Oracle par exemple
Il faut faire deux chose :
- Télécharger et installer le driver spécifique du SGBD : exemple ROracle, RMysql, ...
Nous allons télécharger ROracle
- Télécharger et installer le driver générique appelé DBI (DataBase Installer).

----------------------------------------------------------------------------------------------------------
-- 2.1 Télécharger et Installer le package (driver) spécifique ROracle
----------------------------------------------------------------------------------------------------------

Télécharger depuis le site Oracle
http://www.oracle.com/technetwork/database/database-technologies/r/roracle/downloads/index.html
Le zip windows le plus récent.
La version R compatible est indiqué. Ce doit être celle que vous avez installée au point 1
Si ce n''est pas le cas,  installer la version R indiqué ici.

Cliquer sur ROracle_1.3-2.zip pour télécharger.

Mettre le zip télécharger par exemple dans le dossier :
D:/1agm05092005/5Logiciels_new/R/R_Oracle_Zip

# Dans R, Fixer le chemin vers le le ZIP téléchargé comme suit :
> setwd('D:/1agm05092005/5Logiciels_new/R/R_Oracle_Zip')   

# Installer le package spécifiqu ROracle comme suit dans R:
> install.packages('ROracle_1.3-2.zip', repos = NULL)

Si le message si dessous apparait c'est que c'est bon.
le package 'ROracle' a été décompressé et les sommes MD5 ont été vérifiées avec succés

# tentez de charger la librairie ROracle comme suit :
> library('ROracle')
Erreur : le package 'DBI' nécessaire pour 'ROracle', mais est introuvable

----------------------------------------------------------------------------------------------------------
-- 2.2. Installer le package DBI
----------------------------------------------------------------------------------------------------------

Télécharger le package DBI (DataBase Interface) ici :
https://cran.biotools.fr/src/contrib/DBI_1.1.3.tar.gz

placez le fichier DBI_1.1.3.tar.gz dans un dossier. Par exmeple :
D:\1agm05092005\5Logiciels_new\R\DBIGZ


You can install the released version of DBI from CRAN with:

> setwd('D:/1agm05092005/5Logiciels_new/R/DBIGZ')   # set to path of download
> install.packages("DBI_1.1.3.tar.gz");

inferring 'repos = NULL' from 'pkgs'
* installing *source* package 'DBI' ...
** package 'DBI' correctement décompressé et sommes MD5 vérifiées
...
* DONE (DBI)
Making 'packages.html' ... fini

Les packages source téléchargés sont dans
        'D:\1agm05092005\5Logiciels_new\R\R-3.6.0\library\DBI'

# chargement de la librairie		
> library('ROracle')	
Le chargement a nécessité le package : DBI

#chargement du driver	
drv <- dbDriver("Oracle")


----------------------------------------------------------------------------------------------------------
-- 3. Connexion et prise en main
-- Au prochaine connexion faire d'abord 3.1 à 3.7 
-- avant d'envoyer des requêtes
----------------------------------------------------------------------------------------------------------
# 3.1 chargement de la librairie		
> library('ROracle')	

# 3.2 chargement du driver	
> drv <- dbDriver("Oracle")

# 3.3 Nom de la chaine de connexion à la base
> ORCL <-"(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = 134.59.152.111)(PORT = 8822))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = orcl)))"
## Port 8822 rédirigé vers 1521 dans la MV

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


