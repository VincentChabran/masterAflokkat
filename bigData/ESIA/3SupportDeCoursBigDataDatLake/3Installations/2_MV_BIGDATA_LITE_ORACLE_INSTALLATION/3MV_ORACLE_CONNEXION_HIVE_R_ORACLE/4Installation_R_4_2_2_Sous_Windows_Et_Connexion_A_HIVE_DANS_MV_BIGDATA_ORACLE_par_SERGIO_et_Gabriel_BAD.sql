############################################################################################
# Installation R et connexion à HIVE dans la VM de Sergio SIMONIAN actuellement
# utilisée pour les projets Big Data
# par Sergio Simonian <sergio.simonian@etu.univ-cotedazur.fr>
# Me contacter par mail en de problèmes
# Bonne installation
############################################################################################






############################################################################################
# Etape 1. Etape connexion à HIVE dans la MV ORACLE, création d''une table et insertion de lignes
############################################################################################

# Example Query Hive table in R

We first connect to Hive with beeline, create a table and insert some data.
Then we install R and the RJDBC R package.
Finally we run a query on the Hive table using RJDBC.

## Connect to Hive with beeline

beeline
```bash
0: jdbc:hive2://localhost:10000>!connect jdbc:hive2://localhost:10000 

scan complete in 2ms
Connecting to jdbc:hive2://localhost:10000
Enter username for jdbc:hive2://localhost:10000: oracle
Enter password for jdbc:hive2://localhost:10000: ********
password : welcome1

Connected to: Apache Hive (version 1.1.0-cdh5.13.1)
Driver: Hive JDBC (version 1.1.0-cdh5.13.1)
Transaction isolation: TRANSACTION_REPEATABLE_READ
0: jdbc:hive2://localhost:10000>
```
## Create a Hive table in Beeline and insert some data

```SQL
-- Create a database and a table
CREATE DATABASE IF NOT EXISTS books;
USE books;
CREATE TABLE IF NOT EXISTS dictionary (word STRING, description STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

-- Insert data into the table
INSERT INTO dictionary VALUES ("a", "the letter a");
INSERT INTO dictionary VALUES ("b", "the letter b");
INSERT INTO dictionary VALUES ("c", "the letter c");

-- Use Ctrl + C to exit
```

############################################################################################
# Etape 2. Installation de R DANS WINDOWS
############################################################################################

https://cran.r-project.org/bin/windows/base/R-4.2.2-win.exe
placer R-4.2.2-win.exe
dans le dossier D:/1agm05092005/5Logiciels_new/R422
cliquer  sur : R-4.2.2-win.exe
Une fois télécharger, double cliquer sur R-4.2.2-win.exe
Choisir le dossier (exemple : D:/1agm05092005/5Logiciels_new/R422/) ou vous voulez installer R pendant le dialogue

Une fois installé
Modifier le PATH Windows pour ajouter le chemin suivant :
exemple
D:\1agm05092005\5Logiciels_new\R422\R-4.2.2\bin
Mettre ce chemin au début de la variable d''environnement PATH.

Ouvrir un CMD et Lancer R. On obtient le prompt siuivant :
>




############################################################################################
# Etape 3. Installation du package RJDBC (DBI, Rjava seront aussi installés) dans la MV O
############################################################################################

## Install RJDBC RJDBC package
# Lancement de R

R
>

??? Si windows ????
télécharger les binaires RJDB pour windows

http://cran.us.r-project.org/bin/windows/contrib/4.2/RJDBC_0.2-10.zip
## Run a query on the dictionary table using RJDBC

placer le zip dans le dossier
D:\1agm05092005\5Logiciels_new\R422\
RJDBC_0.2-10.zip

```bash : Installation de RJDBC
> setwd('D:/1agm05092005/5Logiciels_new/R422') 
> install.packages("RJDBC_0.2-10.zip")
```

Open an R terminal:

```bash
R
```

Run the following in the R terminal:

```R
library(RJDBC)
hive_jdbc_jar <- "D:/1agm05092005/5Logiciels_new/R422/hive-jdbc-1.1.0-cdh5.13.1-standalone.jar"
hive_driver <- "org.apache.hive.jdbc.HiveDriver"
hive_url <- "jdbc:hive2://134.59.152.111:1040" # Le port 1040 pointe vers 10000
drv <- JDBC(hive_driver, hive_jdbc_jar)
conn <- dbConnect(drv, hive_url, "oracle", "")

Erreur dans dbConnect(drv, hive_url, "oracle", "") : 
  Unable to connect JDBC to jdbc:hive2://134.59.152.111:1040
  JDBC ERROR: org/apache/hadoop/util/VersionInfo
> 


# vérifier le port: 
# souw windows activation telnet par recherche et cochage

show_databases <- dbGetQuery(conn, "show databases")
print(show_databases);
result <- dbGetQuery(conn, "select * from books.dictionary")
print(result)
```

 


--






