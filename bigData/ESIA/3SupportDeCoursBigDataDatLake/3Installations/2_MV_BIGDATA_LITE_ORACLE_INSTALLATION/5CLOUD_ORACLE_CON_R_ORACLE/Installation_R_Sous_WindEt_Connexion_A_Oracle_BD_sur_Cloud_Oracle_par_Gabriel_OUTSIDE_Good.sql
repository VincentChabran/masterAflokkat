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
-- Au prochaine connexion faire d'abord 3.1 à 3.5 
-- avant d'envoyer des requêtes
----------------------------------------------------------------------------------------------------------
# 3.1 chargement de la librairie		
> library('ROracle')	

# 3.2 chargement du driver	
> drv <- dbDriver("Oracle")

# Create the connection string


> connect.string  <-"(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = 144.21.67.201)(PORT = 1521))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = pdbm1inf.631174089.oraclecloud.internal)))"


# 3.3 Connexion à la base
> con <- dbConnect(drv, username = "MOPOLOPR2122", password = "xxx",dbname=connect.string) 

# 3.4 Exécution d''une requête SQL
> rs <- dbSendQuery(con, "select * from emp where deptno = 10")

# 3.5 Affichage du résultat
> fetch(rs)
   EMPNO  ENAME       JOB  MGR            HIREDATE  SAL COMM DEPTNO
1  7782  CLARK   MANAGER 7839 1981-06-09 01:00:00 2450   NA     10
2  7839   KING PRESIDENT   NA 1981-11-17 00:00:00 5000   NA     10
3  7934 MILLER     CLERK 7782 1982-01-23 00:00:00 1300   NA     10

#Stockage du résultat dans data.frame
rs <- dbSendQuery(con, "select * from emp where deptno = 10")
> data <- fetch(rs)

## extract all rows
> dim(data)
[1] 3 8
3 lignes résultat 8 colonnes

> print(data);

  EMPNO  ENAME       JOB  MGR            HIREDATE  SAL COMM DEPTNO
1  7782  CLARK   MANAGER 7839 1981-06-09 01:00:00 2450   NA     10
2  7839   KING PRESIDENT   NA 1981-11-17 00:00:00 5000   NA     10
3  7934 MILLER     CLERK 7782 1982-01-23 00:00:00 1300   NA     10

