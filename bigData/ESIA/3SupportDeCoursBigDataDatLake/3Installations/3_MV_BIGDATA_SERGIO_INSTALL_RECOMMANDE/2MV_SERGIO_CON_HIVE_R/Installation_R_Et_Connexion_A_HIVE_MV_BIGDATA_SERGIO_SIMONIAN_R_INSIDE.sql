############################################################################################
# Installation R et connexion à HIVE dans la VM de Sergio SIMONIAN actuellement
# utilisée pour les projets Big Data
# par Sergio Simonian <sergio.simonian@etu.univ-cotedazur.fr>
# Me contacter par mail en de problèmes
# Bonne installation
############################################################################################






############################################################################################
# Etape 1. Etape connexion à HIVE dans la MV, création d''une table et insertion de lignes
############################################################################################

# Example Query Hive table in R

We first connect to Hive with beeline, create a table and insert some data.
Then we install R and the RJDBC R package.
Finally we run a query on the Hive table using RJDBC.

## Connect to Hive with beeline

```bash
beeline -u jdbc:hive2://localhost:10000 vagrant
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
# Etape 2. Installation de R dans la MV de Sergio
############################################################################################

## Install R

```bash
# Installation des dépendances pour compiler R
sudo yum groupinstall -y "Development Tools"
sudo yum install -y gcc-gfortran bzip2-devel pcre2-devel readline-devel gcc-toolset-12-gcc-gfortran
#sudo dnf builddep R

# Télécharger les sources de R et Installer
cd /usr/local/
sudo wget https://pbil.univ-lyon1.fr/CRAN/src/base/R-4/R-4.2.2.tar.gz --no-check-certificate
sudo tar -zxf R-4.2.2.tar.gz
sudo chown vagrant:vagrant -R R-4.2.2
cd R-4.2.2

# récupère la librairy libcurl si elle manque
sudo yum install -y libcurl-devel

#préparare la configuration
./configure --with-x=no

```
# lance la compilation de R
make

# Rend R accessible
sudo make install

# donne les droits au user vagrant sur le dossier R
sudo chown vagrant:vagrant -R /usr/local/lib64/R
```

############################################################################################
# Etape 3. Installation du package RJDBC (DBI, Rjava seront aussi installés) dans la MV de Sergio
############################################################################################

## Install RJDBC RJDBC package
# Lancement de R

R
>
```bash : Installation de RJDBC
> install.packages("RJDBC", repos = "http://cran.us.r-project.org")
```
??? Si windows ????
http://cran.us.r-project.org/bin/windows/contrib/4.2/RJDBC_0.2-10.zip
## Run a query on the dictionary table using RJDBC

Open an R terminal:

```bash
R
```

Run the following in the R terminal:

```R
library(RJDBC)
hive_jdbc_jar <- "/usr/local/hive/jdbc/hive-jdbc-3.1.3-standalone.jar"
hive_driver <- "org.apache.hive.jdbc.HiveDriver"
hive_url <- "jdbc:hive2://localhost:10000"
drv <- JDBC(hive_driver, hive_jdbc_jar)
conn <- dbConnect(drv, hive_url, "vagrant", "")
show_databases <- dbGetQuery(conn, "show databases")
print(show_databases);

  database_name
1         books
2       default


result <- dbGetQuery(conn, "select * from books.dictionary")
print(result)


  dictionary.word dictionary.description
1               a           the letter a
2               b           the letter b
3               c           the letter c



```

 


--






