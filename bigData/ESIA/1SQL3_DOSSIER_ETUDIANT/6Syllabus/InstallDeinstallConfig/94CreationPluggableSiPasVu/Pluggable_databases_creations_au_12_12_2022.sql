/*

Ce script contient les scripts de création et de configurations des BD pluggables
des différentes CDB que je gère.

*/


----------------------------------------------------------------------------------
-- PLUGGABLE SUR LA BASE BDMBDS disponible sur le cloud Oracle
----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- PLUGGABLE PDBM1CI20 sur la CDB BDMBDS sur cloud Gabriel
-----------------------------------------------------------------------------------------

CREATE PLUGGABLE DATABASE PDBSOPHIA
  ADMIN USER PDBADMIN IDENTIFIED BY OracleSysdbaPdbsophia01
  ROLES = (dba);
  
alter pluggable database PDBSOPHIA open;
alter pluggable database PDBSOPHIA save state;

alter session set container=PDBSOPHIA;
select tablespace_name, file_name from dba_data_files;

alter session set container=PDBSOPHIA;
alter user pdbadmin  identified by OracleSysdbaPdbsophia01
select tablespace_name, file_name from dba_data_files;

SYSTEM	/u02/app/oracle/oradata/BDMBDS/PDBSOPHIA/system01.dbf
SYSAUX	/u02/app/oracle/oradata/BDMBDS/PDBSOPHIA/sysaux01.dbf
UNDOTBS1	/u02/app/oracle/oradata/BDMBDS/PDBSOPHIA/undotbs01.dbf
USERS	/u02/app/oracle/oradata/BDMBDS/PDBSOPHIA/PDBSOPHIA_users01.dbf


alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

-----------------------------------------------------------------------------------------
-- Configuration d'une connexion sqldeveloper sur PDBSOPHIA
-----------------------------------------------------------------------------------------
Suite à l''indisponibilité de la base de données sur le cloud UCA,
Veuillez vous créer une connexion sur une base disponible
sur le cloud Oracle avec les informations ci-dessus:

1) Votre nom (exemple de nom : MOPOLO)
2) Nom de connexion : votre nom + 2B20_ON_PDBSOPHIA_ORACLE_CLOUD 
					(MOPOLO2B20_ON_PDBSOPHIA_ORACLE_CLOUD)
3) Nom Utilisateur (Oracle) : votre nom + 2B20 (exemple : MOPOLO2B20)
4) Mot de passe (Oracle) :votre votre Nom + 2B20 +01 (exemple : MOPOLO2B2001 )respecter la casser
5) Nom d''hôte :144.21.67.201
6) Port : 1521
7) Nom de service : PDBSOPHIA.631174089.oraclecloud.internal
8) Vous devez cocher "Enregistrer le mot de passe" et 
cliquer sur "Test" puis "enregistrer" puis "Connexion".

-----------------------------------------------------------------------------------------
-- PLUGGABLE PDBL3MIA sur la CDB BDMBDS sur cloud Gabriel
-----------------------------------------------------------------------------------------

CREATE PLUGGABLE DATABASE PDBL3MIA
  ADMIN USER PDBADMIN IDENTIFIED BY OracleSysdbaPdbl3mia01
  ROLES = (dba);
  
alter pluggable database all open;
alter pluggable database all save state;

alter session set container=pdbl3mia;
Create tablespace users 
Datafile '+DATA/BDMBDS2_UCA/EFA02E0DFA1FF815E0531B00000A6CB8/DATAFILE/users01.dbf' size 500M autoextend on;

Tablespace created.


select tablespace_name, file_name from dba_data_files;
SYSTEM	+DATA/BDMBDS2_UCA/EFA02E0DFA1FF815E0531B00000A6CB8/DATAFILE/system.284.1123238635
SYSAUX	+DATA/BDMBDS2_UCA/EFA02E0DFA1FF815E0531B00000A6CB8/DATAFILE/sysaux.285.1123238635
UNDOTBS1	+DATA/BDMBDS2_UCA/EFA02E0DFA1FF815E0531B00000A6CB8/DATAFILE/undotbs1.283.1123238635
USERS	+DATA/BDMBDS2_UCA/EFA02E0DFA1FF815E0531B00000A6CB8/DATAFILE/users01.dbf


USERS	/u02/app/oracle/oradata/BDMBDS/A0AA449511EA4ABBE0530EDF1D0A2C31/datafile/o1_mf_users_h6nl689c_.dbf

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;
--alter pluggable database default temporary tablespace temp; -- fait automatiquement


-----------------------------------------------------------------------------------------
-- Configuration d'une connexion sqldeveloper sur pdbl3mia
-----------------------------------------------------------------------------------------
Suite à l''indisponibilité de la base de données sur le cloud UCA,
Veuillez vous créer une connexion sur une base disponible
sur le cloud Oracle avec les informations ci-dessus:

1) Votre nom (exemple de nom : MOPOLO)
2) Nom de connexion : votre nom + 2B20_ON_pdbl3mia_ORACLE_CLOUD 
					(MOPOLO2B20_ON_pdbl3mia_ORACLE_CLOUD)
3) Nom Utilisateur (Oracle) : votre nom + 2B20 (exemple : MOPOLO2B20)
4) Mot de passe (Oracle) :votre votre Nom + 2B20 +01 (exemple : MOPOLO2B2001 )respecter la casser
5) Nom d''hôte :144.21.67.201
6) Port : 1521
7) Nom de service : pdbl3mia.631174089.oraclecloud.internal
8) Vous devez cocher "Enregistrer le mot de passe" et 
cliquer sur "Test" puis "enregistrer" puis "Connexion".




-----------------------------------------------------------------------------------------
-- PLUGGABLE PDBMEZA sur la CDB BDMBDS sur cloud Gabriel
-----------------------------------------------------------------------------------------

CREATE PLUGGABLE DATABASE PDBMEZA
  ADMIN USER PDBADMIN IDENTIFIED BY OracleSysdbaPdbm1eza01
  ROLES = (dba);
  
alter pluggable database all open;
alter pluggable database all save state;

alter session set container=PDBMEZA;
select tablespace_name, file_name from dba_data_files;
SYSTEM	+DATA/BDMBDS2_UCA/EFB347537C39FF66E0531B00000AB8BB/DATAFILE/system.289.1123320665
SYSAUX	+DATA/BDMBDS2_UCA/EFB347537C39FF66E0531B00000AB8BB/DATAFILE/sysaux.290.1123320665
UNDOTBS1	+DATA/BDMBDS2_UCA/EFB347537C39FF66E0531B00000AB8BB/DATAFILE/undotbs1.288.1123320665


Create tablespace users 
Datafile '+DATA/BDMBDS2_UCA/EFB347537C39FF66E0531B00000AB8BB/DATAFILE/users01.dbf' size 500M autoextend on;

SYSTEM	+DATA/BDMBDS2_UCA/EFB347537C39FF66E0531B00000AB8BB/DATAFILE/system.289.1123320665
SYSAUX	+DATA/BDMBDS2_UCA/EFB347537C39FF66E0531B00000AB8BB/DATAFILE/sysaux.290.1123320665
UNDOTBS1	+DATA/BDMBDS2_UCA/EFB347537C39FF66E0531B00000AB8BB/DATAFILE/undotbs1.288.1123320665
USERS	+DATA/BDMBDS2_UCA/EFB347537C39FF66E0531B00000AB8BB/DATAFILE/users01.dbf



alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;
--alter pluggable database default temporary tablespace temp; -- fait automatiquement

-----------------------------------------------------------------------------------------
-- Configuration d'une connexion sqldeveloper
-----------------------------------------------------------------------------------------
Suite à l''indisponibilité de la base de données sur le cloud UCA,
Veuillez vous créer une connexion sur une base disponible
sur le cloud Oracle avec les informations ci-dessus:

1) Votre nom (exemple de nom : MOPOLO)
2) Nom de connexion : votre nom + 2B20_ON_PDBM1EZA_ORACLE_CLOUD 
					(MOPOLO2B20_ON_PDBM1EZA_ORACLE_CLOUD)
3) Nom Utilisateur (Oracle) : votre nom + 2B20 (exemple : MOPOLO2B20)
4) Mot de passe (Oracle) :votre votre Nom + 2B20 +01 (exemple : MOPOLO2B2001 )respecter la casser
5) Nom d''hôte :144.21.67.201
6) Port : 1521
7) Nom de service : pdbm1eza.631174089.oraclecloud.internal
8) Vous devez cocher "Enregistrer le mot de passe" et 
cliquer sur "Test" puis "enregistrer" puis "Connexion".


-----------------------------------------------------------------------------------------
-- PLUGGABLE PDBM1ESA sur la CDB BDMBDS sur cloud Gabriel
-----------------------------------------------------------------------------------------
alter session set container=cdb$root;
CREATE PLUGGABLE DATABASE PDBM1ESA
  ADMIN USER PDBADMIN IDENTIFIED BY OracleSysdbaPdbm1esa01
  ROLES = (dba);
  
alter pluggable database PDBM1ESA open;
alter pluggable database PDBM1ESA save state;

alter session set container=PDBM1ESA;
select tablespace_name, file_name from dba_data_files;



--alter pluggable database default temporary tablespace temp; -- fait automatiquement

-----------------------------------------------------------------------------------------
-- Configuration d'une connexion sqldeveloper
-----------------------------------------------------------------------------------------
Suite à l''indisponibilité de la base de données sur le cloud UCA,
Veuillez vous créer une connexion sur une base disponible
sur le cloud Oracle avec les informations ci-dessus:

1) Votre nom (exemple de nom : MOPOLO)
2) Nom de connexion : votre nom + 2B20_ON_PDBM1ESA_ORACLE_CLOUD 
					(MOPOLO2B20_ON_PDBM1ESA_ORACLE_CLOUD)
3) Nom Utilisateur (Oracle) : votre nom + 2B20 (exemple : MOPOLO2B20)
4) Mot de passe (Oracle) :votre votre Nom + 2B20 +01 (exemple : MOPOLO2B2001 )respecter la casser
5) Nom d''hôte :144.21.67.201
6) Port : 1521
7) Nom de service : PDBM1ESA.631174089.oraclecloud.internal
8) Vous devez cocher "Enregistrer le mot de passe" et 
cliquer sur "Test" puis "enregistrer" puis "Connexion".





-----------------------------------------------------------------------------------------
-- PLUGGABLE PDBESTIA sur la CDB BDMBDS sur cloud ORACLE
-----------------------------------------------------------------------------------------
alter session set container=cdb$root;
CREATE PLUGGABLE DATABASE PDBESTIA
  ADMIN USER PDBADMIN IDENTIFIED BY OracleSysdbaPDBESTIA01
  ROLES = (dba);
  
alter pluggable database PDBESTIA open;
alter pluggable database PDBESTIA save state;

alter session set container=PDBESTIA;
select tablespace_name, file_name from dba_data_files;
SYSTEM	/u02/app/oracle/oradata/BDMBDS/AAF2C343129312F9E0534AF61D0A9E57/datafile/o1_mf_system_hkfmoqod_.dbf
SYSAUX	/u02/app/oracle/oradata/BDMBDS/AAF2C343129312F9E0534AF61D0A9E57/datafile/o1_mf_sysaux_hkfmoqqf_.dbf
UNDOTBS1	/u02/app/oracle/oradata/BDMBDS/AAF2C343129312F9E0534AF61D0A9E57/datafile/o1_mf_undotbs1_hkfmoqql_.dbf
USERS	/u02/app/oracle/oradata/BDMBDS/AAF2C343129312F9E0534AF61D0A9E57/datafile/o1_mf_users_hkfmoqqt_.dbf

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;
--alter pluggable database default temporary tablespace temp; -- fait automatiquement

-----------------------------------------------------------------------------------------
-- Configuration d'une connexion sqldeveloper sur PDBESTIA
-----------------------------------------------------------------------------------------
Suite à l''indisponibilité de la base de données sur le cloud UCA,
Veuillez vous créer une connexion sur une base disponible
sur le cloud Oracle avec les informations ci-dessus:

1) Votre nom (exemple de nom : MOPOLO)
2) Nom de connexion : votre nom + 2B20_ON_PDBESTIA_ORACLE_CLOUD 
					(MOPOLO2B20_ON_PDBESTIA_ORACLE_CLOUD)
3) Nom Utilisateur (Oracle) : votre nom + 2B20 (exemple : MOPOLO2B20)
4) Mot de passe (Oracle) :votre votre Nom + 2B20 +01 (exemple : MOPOLO2B2001 )respecter la casser
5) Nom d''hôte :144.21.67.201
6) Port : 1521
7) Nom de service : PDBESTIA.631174089.oraclecloud.internal
8) Vous devez cocher "Enregistrer le mot de passe" et 
cliquer sur "Test" puis "enregistrer" puis "Connexion".




-----------------------------------------------------------------------------------------
-- PLUGGABLE PDBCPROF sur la CDB BDMBDS sur cloud ORACLE
-----------------------------------------------------------------------------------------
alter session set container=cdb$root;
CREATE PLUGGABLE DATABASE PDBCPROF
  ADMIN USER PDBADMIN IDENTIFIED BY OracleSysdbaPdbcprof02
  ROLES = (dba);
  
alter pluggable database PDBCPROF open;
alter pluggable database PDBCPROF save state;

alter session set container=PDBCPROF;
select tablespace_name, file_name from dba_data_files;
SYSTEM	/u02/app/oracle/oradata/BDMBDS/AAF2C343129312F9E0534AF61D0A9E57/datafile/o1_mf_system_hkfmoqod_.dbf
SYSAUX	/u02/app/oracle/oradata/BDMBDS/AAF2C343129312F9E0534AF61D0A9E57/datafile/o1_mf_sysaux_hkfmoqqf_.dbf
UNDOTBS1	/u02/app/oracle/oradata/BDMBDS/AAF2C343129312F9E0534AF61D0A9E57/datafile/o1_mf_undotbs1_hkfmoqql_.dbf
USERS	/u02/app/oracle/oradata/BDMBDS/AAF2C343129312F9E0534AF61D0A9E57/datafile/o1_mf_users_hkfmoqqt_.dbf

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;
--alter pluggable database default temporary tablespace temp; -- fait automatiquement
alter tablespace system
add datafile
'/u04/app/oracle/oradata/BDMBDS/pdbcprof/sysaux_pdbcprof_02.dbf' size 200M autoextend on  next 10M;

-----------------------------------------------------------------------------------------
-- Configuration d'une connexion sqldeveloper sur PDBCPROF
-----------------------------------------------------------------------------------------
Suite à l''indisponibilité de la base de données sur le cloud UCA,
Veuillez vous créer une connexion sur une base disponible
sur le cloud Oracle avec les informations ci-dessus:

1) Votre nom (exemple de nom : MOPOLO)
2) Nom de connexion : votre nom + 2B20_ON_PDBCPROF_ORACLE_CLOUD 
					(MOPOLO2B20_ON_PDBCPROF_ORACLE_CLOUD)
3) Nom Utilisateur (Oracle) : votre nom + 2B20 (exemple : MOPOLO2B20)
4) Mot de passe (Oracle) :votre votre Nom + 2B20 +01 (exemple : MOPOLO2B2001 )respecter la casser
5) Nom d''hôte :144.21.67.201
6) Port : 1521
7) Nom de service : PDBCPROF.631174089.oraclecloud.internal
8) Vous devez cocher "Enregistrer le mot de passe" et 
cliquer sur "Test" puis "enregistrer" puis "Connexion".

-----------------------------------------------------------------------------------------
-- PLUGGABLE PDBITU sur la CDB BDMBDS sur cloud Oracle
-----------------------------------------------------------------------------------------
CREATE PLUGGABLE DATABASE PDBITU
  ADMIN USER PDBADMIN IDENTIFIED BY OracleSysdbaPdbitu01
  ROLES = (dba);
  
alter pluggable database PDBITU open;
alter pluggable database PDBITU save state;

alter session set container=PDBITU;
select tablespace_name, file_name from dba_data_files;

?
SYSTEM	/u02/app/oracle/oradata/BDMBDS/AB5B287B18D505A6E0534AF61D0A6EE6/datafile/o1_mf_system_hkv9kl9r_.dbf
SYSAUX	/u02/app/oracle/oradata/BDMBDS/AB5B287B18D505A6E0534AF61D0A6EE6/datafile/o1_mf_sysaux_hkv9kl9y_.dbf
UNDOTBS1	/u02/app/oracle/oradata/BDMBDS/AB5B287B18D505A6E0534AF61D0A6EE6/datafile/o1_mf_undotbs1_hkv9klb3_.dbf
USERS	/u02/app/oracle/oradata/BDMBDS/AB5B287B18D505A6E0534AF61D0A6EE6/datafile/o1_mf_users_hkv9klbd_.dbf

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;
--alter pluggable database default temporary tablespace temp; -- fait automatiquement

-----------------------------------------------------------------------------------------
-- Configuration d'une connexion sqldeveloper sur PDBITU
-----------------------------------------------------------------------------------------
Suite à l''indisponibilité de la base de données sur le cloud UCA,
Veuillez vous créer une connexion sur une base disponible
sur le cloud Oracle avec les informations ci-dessus:

1) Votre nom (exemple de nom : MOPOLO)
2) Nom de connexion : votre nom + 2B20_ON_PDBITU_ORACLE_CLOUD 
					(MOPOLO2B20_ON_PDBITU_ORACLE_CLOUD)
3) Nom Utilisateur (Oracle) : votre nom + 2B20 (exemple : MOPOLO2B20)
4) Mot de passe (Oracle) :votre votre Nom + 2B20 +01 (exemple : MOPOLO2B2001 )respecter la casser
5) Nom d''hôte :144.21.67.201
6) Port : 1521
7) Nom de service : PDBITU.631174089.oraclecloud.internal
8) Vous devez cocher "Enregistrer le mot de passe" et 
cliquer sur "Test" puis "enregistrer" puis "Connexion".

-----------------------------------------------------------------------------------------
-- PLUGGABLE PDBCASA sur la CDB BDMBDS sur cloud Oracle
-----------------------------------------------------------------------------------------
CREATE PLUGGABLE DATABASE PDBCASA
  ADMIN USER PDBADMIN IDENTIFIED BY OracleSysdbaPDBCASA01
  ROLES = (dba);
  
alter pluggable database PDBCASA open;
alter pluggable database PDBCASA save state;


alter session set container=PDBCASA;
select tablespace_name, file_name from dba_data_files;

SYSTEM	/u02/app/oracle/oradata/BDMBDS/AB5B46A60C8A0EEBE0534AF61D0A6866/datafile/o1_mf_system_hkvb10hf_.dbf
SYSAUX	/u02/app/oracle/oradata/BDMBDS/AB5B46A60C8A0EEBE0534AF61D0A6866/datafile/o1_mf_sysaux_hkvb10ho_.dbf
UNDOTBS1 /u02/app/oracle/oradata/BDMBDS/AB5B46A60C8A0EEBE0534AF61D0A6866/datafile/o1_mf_undotbs1_hkvb10ht_.dbf
USERS	/u02/app/oracle/oradata/BDMBDS/AB5B46A60C8A0EEBE0534AF61D0A6866/datafile/o1_mf_users_hkvb10j8_.dbf

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;
--alter pluggable database default temporary tablespace temp; -- fait automatiquement

-----------------------------------------------------------------------------------------
-- Configuration d'une connexion sqldeveloper sur PDBCASA
-----------------------------------------------------------------------------------------
Suite à l''indisponibilité de la base de données sur le cloud UCA,
Veuillez vous créer une connexion sur une base disponible
sur le cloud Oracle avec les informations ci-dessus:

1) Votre nom (exemple de nom : MOPOLO)
2) Nom de connexion : votre nom + 2B20_ON_PDBCASA_ORACLE_CLOUD 
					(MOPOLO2B20_ON_PDBCASA_ORACLE_CLOUD)
3) Nom Utilisateur (Oracle) : votre nom + 2B20 (exemple : MOPOLO2B20)
4) Mot de passe (Oracle) :votre votre Nom + 2B20 +01 (exemple : MOPOLO2B2001 )respecter la casser
5) Nom d''hôte :144.21.67.201
6) Port : 1521
7) Nom de service : PDBCASA.631174089.oraclecloud.internal
8) Vous devez cocher "Enregistrer le mot de passe" et 
cliquer sur "Test" puis "enregistrer" puis "Connexion".

-----------------------------------------------------------------------------------------
-- PLUGGABLE PDBATLAS sur la CDB BDMBDS sur cloud Oracle
-----------------------------------------------------------------------------------------

CREATE PLUGGABLE DATABASE PDBATLAS
  ADMIN USER PDBADMIN IDENTIFIED BY OracleSysdbaPDBATLAS01
  ROLES = (dba);
  
alter pluggable database PDBATLAS open;
alter pluggable database PDBATLAS save state;

alter session set container=PDBATLAS;

select tablespace_name, file_name from dba_data_files;



alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;
alter session set container=CDB$ROOT;

alter pluggable database default tablespace users;
--alter pluggable database default temporary tablespace temp; -- fait automatiquement

-----------------------------------------------------------------------------------------
-- Configuration d'une connexion sqldeveloper sur PDBATLAS
-----------------------------------------------------------------------------------------
Suite à l''indisponibilité de la base de données sur le cloud UCA,
Veuillez vous créer une connexion sur une base disponible
sur le cloud Oracle avec les informations ci-dessus:

1) Votre nom (exemple de nom : MOPOLO)
2) Nom de connexion : votre nom + 2B20_ON_PDBATLAS_ORACLE_CLOUD 
					(MOPOLO2B20_ON_PDBATLAS_ORACLE_CLOUD)
3) Nom Utilisateur (Oracle) : votre nom + 2B20 (exemple : MOPOLO2B20)
4) Mot de passe (Oracle) :votre votre Nom + 2B20 +01 (exemple : MOPOLO2B2001 )respecter la casser
5) Nom d''hôte :144.21.67.201
6) Port : 1521
7) Nom de service : PDBATLAS.631174089.oraclecloud.internal
8) Vous devez cocher "Enregistrer le mot de passe" et 
cliquer sur "Test" puis "enregistrer" puis "Connexion".

-----------------------------------------------------------------------------------------
-- PLUGGABLE PDBM1INF sur la CDB BDMBDS sur cloud Oracle
-----------------------------------------------------------------------------------------
CREATE PLUGGABLE DATABASE PDBM1INF
  ADMIN USER PDBADMIN IDENTIFIED BY OracleSysdbaPDBM1INF01
  ROLES = (dba);
  
alter pluggable database PDBM1INF open;
alter pluggable database PDBM1INF save state;


alter session set container=PDBM1INF;

select tablespace_name, file_name from dba_data_files;

SYSTEM	/u02/app/oracle/oradata/BDMBDS/AB5B46A60C8D0EEBE0534AF61D0A6866/datafile/o1_mf_system_hkvb7r6h_.dbf
SYSAUX	/u02/app/oracle/oradata/BDMBDS/AB5B46A60C8D0EEBE0534AF61D0A6866/datafile/o1_mf_sysaux_hkvb7r72_.dbf
UNDOTBS1	/u02/app/oracle/oradata/BDMBDS/AB5B46A60C8D0EEBE0534AF61D0A6866/datafile/o1_mf_undotbs1_hkvb7r77_.dbf
USERS	/u02/app/oracle/oradata/BDMBDS/AB5B46A60C8D0EEBE0534AF61D0A6866/datafile/o1_mf_users_hkvb7r7q_.dbf

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter session set container=CDB$ROOT;

alter pluggable database default tablespace users;
--alter pluggable database default temporary tablespace temp; -- fait automatiquement

-----------------------------------------------------------------------------------------
-- Configuration d'une connexion sqldeveloper sur PDBM1INF
-----------------------------------------------------------------------------------------
Suite à l''indisponibilité de la base de données sur le cloud UCA,
Veuillez vous créer une connexion sur une base disponible
sur le cloud Oracle avec les informations ci-dessus:

1) Votre nom (exemple de nom : MOPOLO)
2) Nom de connexion : votre nom + 2B20_ON_PDBM1INF_ORACLE_CLOUD 
					(MOPOLO2B20_ON_PDBM1INF_ORACLE_CLOUD)
3) Nom Utilisateur (Oracle) : votre nom + 2B20 (exemple : MOPOLO2B20)
4) Mot de passe (Oracle) :votre votre Nom + 2B20 +01 (exemple : MOPOLO2B2001 )respecter la casser
5) Nom d''hôte :144.21.67.201
6) Port : 1521
7) Nom de service : PDBM1INF.631174089.oraclecloud.internal
8) Vous devez cocher "Enregistrer le mot de passe" et 
cliquer sur "Test" puis "enregistrer" puis "Connexion".


-----------------------------------------------------------------------------------------
-- PLUGGABLE PDBM1MIA sur la CDB BDMBDS sur cloud Oracle
-----------------------------------------------------------------------------------------
alter session set container=CDB$ROOT;
CREATE PLUGGABLE DATABASE PDBM1MIA
  ADMIN USER PDBADMIN IDENTIFIED BY OracleSysdbaPDBM1MIA01
  ROLES = (dba);
  
alter pluggable database PDBM1MIA open;
alter pluggable database PDBM1MIA save state;


alter session set container=PDBM1MIA;

select tablespace_name, file_name from dba_data_files;
SYSTEM	/u02/app/oracle/oradata/BDMBDS/AB5B46A60C900EEBE0534AF61D0A6866/datafile/o1_mf_system_hkvbswo2_.dbf
SYSAUX	/u02/app/oracle/oradata/BDMBDS/AB5B46A60C900EEBE0534AF61D0A6866/datafile/o1_mf_sysaux_hkvbswo9_.dbf
UNDOTBS1 /u02/app/oracle/oradata/BDMBDS/AB5B46A60C900EEBE0534AF61D0A6866/datafile/o1_mf_undotbs1_hkvbswof_.dbf
USERS	/u02/app/oracle/oradata/BDMBDS/AB5B46A60C900EEBE0534AF61D0A6866/datafile/o1_mf_users_hkvbswor_.dbf


alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;
--alter pluggable database default temporary tablespace temp; -- fait automatiquement

-----------------------------------------------------------------------------------------
-- Configuration d'une connexion sqldeveloper sur PDBM1MIA
-----------------------------------------------------------------------------------------
Suite à l''indisponibilité de la base de données sur le cloud UCA,
Veuillez vous créer une connexion sur une base disponible
sur le cloud Oracle avec les informations ci-dessus:

1) Votre nom (exemple de nom : MOPOLO)
2) Nom de connexion : votre nom + 2B20_ON_PDBM1MIA_ORACLE_CLOUD 
					(MOPOLO2B20_ON_PDBSOPHIA_ORACLE_CLOUD)
3) Nom Utilisateur (Oracle) : votre nom + 2B20 (exemple : MOPOLO2B20)
4) Mot de passe (Oracle) :votre votre Nom + 2B20 +01 (exemple : MOPOLO2B2001 )respecter la casser
5) Nom d''hôte :144.21.67.201
6) Port : 1521
7) Nom de service : PDBSOPHIA.631174089.oraclecloud.internal
8) Vous devez cocher "Enregistrer le mot de passe" et 
cliquer sur "Test" puis "enregistrer" puis "Connexion".


-----------------------------------------------------------------------------------------
-- PLUGGABLE PDBBIHAR sur la CDB BDMBDS sur cloud Oracle
-----------------------------------------------------------------------------------------
CREATE PLUGGABLE DATABASE PDBBIHAR
  ADMIN USER PDBADMIN IDENTIFIED BY OracleSysdbaPdbbihar01
  ROLES = (dba);
  
alter pluggable database PDBBIHAR open;
alter pluggable database PDBBIHAR save state;

alter session set container=PDBBIHAR;
select tablespace_name, file_name from dba_data_files;
SYSTEM	/u02/app/oracle/oradata/BDMBDS/A0AA449511EA4ABBE0530EDF1D0A2C31/datafile/o1_mf_system_h6nl6871_.dbf
SYSAUX	/u02/app/oracle/oradata/BDMBDS/A0AA449511EA4ABBE0530EDF1D0A2C31/datafile/o1_mf_sysaux_h6nl6891_.dbf
UNDOTBS1	/u02/app/oracle/oradata/BDMBDS/A0AA449511EA4ABBE0530EDF1D0A2C31/datafile/o1_mf_undotbs1_h6nl6895_.dbf
USERS	/u02/app/oracle/oradata/BDMBDS/A0AA449511EA4ABBE0530EDF1D0A2C31/datafile/o1_mf_users_h6nl689c_.dbf

TABLESPACE_NAME
------------------------------
FILE_NAME
--------------------------------------------------------------------------------
SYSTEM	/u02/app/oracle/oradata/BDMBDS/B0EAFC0E5967384EE0534AF61D0A9A9D/datafile/o1_mf_system_hqoxj8ln_.dbf
SYSAUX	/u02/app/oracle/oradata/BDMBDS/B0EAFC0E5967384EE0534AF61D0A9A9D/datafile/o1_mf_sysaux_hqoxj8om_.dbf
UNDOTBS1 /u02/app/oracle/oradata/BDMBDS/B0EAFC0E5967384EE0534AF61D0A9A9D/datafile/o1_mf_undotbs1_hqoxj8ot_.dbf
USERS	/u02/app/oracle/oradata/BDMBDS/B0EAFC0E5967384EE0534AF61D0A9A9D/datafile/o1_mf_users_hqoxj8p4_.dbf

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;
--alter pluggable database default temporary tablespace temp; -- fait automatiquement

-----------------------------------------------------------------------------------------
-- Configuration d'une connexion sqldeveloper sur PDBBIHAR
-----------------------------------------------------------------------------------------
Suite à l''indisponibilité de la base de données sur le cloud UCA,
Veuillez vous créer une connexion sur une base disponible
sur le cloud Oracle avec les informations ci-dessus:

1) Votre nom (exemple de nom : MOPOLO)
2) Nom de connexion : votre nom + BH20_ON_PDBBIHAR_ORACLE_CLOUD 
					(MOPOLO2B20_ON_PDBBIHAR_ORACLE_CLOUD)
3) Nom Utilisateur (Oracle) : votre nom + BH20 (exemple : MOPOLO2B20)
4) Mot de passe (Oracle) :votre votre Nom + BH20 +01 (exemple : MOPOLO2B2001 )respecter la casser
5) Nom d''hôte :144.21.67.201
6) Port : 1521
7) Nom de service : PDBBIHAR.631174089.oraclecloud.internal
8) Vous devez cocher "Enregistrer le mot de passe" et 
cliquer sur "Test" puis "enregistrer" puis "Connexion".




-----------------------------------------------------------------------------------------
-- PLUGGABLE PDBHAITI sur la CDB BDMBDS sur cloud Oracle
-----------------------------------------------------------------------------------------
CREATE PLUGGABLE DATABASE PDBHAITI
  ADMIN USER PDBADMIN IDENTIFIED BY OracleSysdbaPDBHAITI01
  ROLES = (dba);
  
alter pluggable database PDBHAITI open;
alter pluggable database PDBHAITI save state;

alter session set container=PDBHAITI;
select tablespace_name, file_name from dba_data_files;
SYSTEM	/u02/app/oracle/oradata/BDMBDS/A0AA449511EA4ABBE0530EDF1D0A2C31/datafile/o1_mf_system_h6nl6871_.dbf
SYSAUX	/u02/app/oracle/oradata/BDMBDS/A0AA449511EA4ABBE0530EDF1D0A2C31/datafile/o1_mf_sysaux_h6nl6891_.dbf
UNDOTBS1	/u02/app/oracle/oradata/BDMBDS/A0AA449511EA4ABBE0530EDF1D0A2C31/datafile/o1_mf_undotbs1_h6nl6895_.dbf
USERS	/u02/app/oracle/oradata/BDMBDS/A0AA449511EA4ABBE0530EDF1D0A2C31/datafile/o1_mf_users_h6nl689c_.dbf

TABLESPACE_NAME
------------------------------
FILE_NAME
--------------------------------------------------------------------------------
SYSTEM	/u02/app/oracle/oradata/BDMBDS/B0EAFC0E5967384EE0534AF61D0A9A9D/datafile/o1_mf_system_hqoxj8ln_.dbf
SYSAUX	/u02/app/oracle/oradata/BDMBDS/B0EAFC0E5967384EE0534AF61D0A9A9D/datafile/o1_mf_sysaux_hqoxj8om_.dbf
UNDOTBS1 /u02/app/oracle/oradata/BDMBDS/B0EAFC0E5967384EE0534AF61D0A9A9D/datafile/o1_mf_undotbs1_hqoxj8ot_.dbf
USERS	/u02/app/oracle/oradata/BDMBDS/B0EAFC0E5967384EE0534AF61D0A9A9D/datafile/o1_mf_users_hqoxj8p4_.dbf

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;
--alter pluggable database default temporary tablespace temp; -- fait automatiquement

-----------------------------------------------------------------------------------------
-- Configuration d'une connexion sqldeveloper sur PDBHAITI
-----------------------------------------------------------------------------------------
Suite à l''indisponibilité de la base de données sur le cloud UCA,
Veuillez vous créer une connexion sur une base disponible
sur le cloud Oracle avec les informations ci-dessus:

1) Votre nom (exemple de nom : MOPOLO)
2) Nom de connexion : votre nom + BH20_ON_PDBHAITI_ORACLE_CLOUD 
					(MOPOLO2B20_ON_PDBHAITI_ORACLE_CLOUD)
3) Nom Utilisateur (Oracle) : votre nom + BH20 (exemple : MOPOLO2B20)
4) Mot de passe (Oracle) :votre votre Nom + BH20 +01 (exemple : MOPOLO2B2001 )respecter la casser
5) Nom d''hôte :144.21.67.201
6) Port : 1521
7) Nom de service : PDBHAITI.631174089.oraclecloud.internal
8) Vous devez cocher "Enregistrer le mot de passe" et 
cliquer sur "Test" puis "enregistrer" puis "Connexion".


-----------------------------------------------------------------------------------------
-- Activation des WALLETS DES PDBS de la CDB BDMBDS
-----------------------------------------------------------------------------------------
Knowledge

wallet status shown as "open_no_master_key" for newly created PDB.

Follow solution provided in below document and check the wallet status of PDBs ,it should show OPEN in all PDBs

--Query to check wallet status in PDB

SQL>alter session set container='<PDB>';

alter session set container=pdbm1eza;

SQL>select * from v$encryption_wallet;
==
 

FILE		OPEN_NO_MASTER_KEY	AUTOLOGIN	SINGLE	UNITED	UNDEFINED	7


[OCI-C]: Newly Created PDB Inside The Container Database Shows Wallet Error "OPEN_NO_MASTER_KEY" ( Doc ID 2443398.1 )

If wallet status OPEN then create tablespace
 
Copyright (c) 2020, Oracle. All rights reserved. Oracle Confidential.
 
 

 	[OCI-C]: Newly Created PDB Inside The Container Database Shows Wallet Error "OPEN_NO_MASTER_KEY" (Doc ID 2443398.1)	 To Bottom
 
________________________________________
Modified:	Jan 13, 2020	 	Type:	PROBLEM	 

	
 
In this Document
	Symptoms

	Cause

	Solution

________________________________________

APPLIES TO:
Oracle Cloud Infrastructure - Database Service - Version N/A and later
Oracle Database Cloud Service - Version N/A and later
Information in this document applies to any platform.

SYMPTOMS
For an existing container database in OCI Classic, create a new PDB in container database, the wallet status for newly created PDB shows "OPEN_NO_MASTER_KEY"
===================
set linesize 200
set pagesize 100
col WRL_PARAMETER format A20
col status format A6
col WRL_TYPE format A9
col Wallet_TYPE format A9
col  KEYSTORE format a10
col FULLY_BACKED_UP format a10

SQL> select * from v$encryption_wallet;



FILE	/opt/oracle/dcs/commonstore/wallets/BDMBDS2_UCA/tde/tde/tde/	OPEN	PASSWORD	SINGLE	NONE	NO	1
FILE		CLOSED	UNKNOWN	SINGLE	UNITED	UNDEFINED	2
FILE		CLOSED	UNKNOWN	SINGLE	UNITED	UNDEFINED	3
FILE		OPEN	PASSWORD	SINGLE	UNITED	NO	4
FILE		OPEN	PASSWORD	SINGLE	UNITED	NO	5
FILE		CLOSED	UNKNOWN	SINGLE	UNITED	UNDEFINED	6
FILE		CLOSED	UNKNOWN	SINGLE	UNITED	UNDEFINED	7
FILE		CLOSED	UNKNOWN	SINGLE	UNITED	UNDEFINED	8
FILE		CLOSED	UNKNOWN	SINGLE	UNITED	UNDEFINED	9
FILE		CLOSED	UNKNOWN	SINGLE	UNITED	UNDEFINED	10
FILE		CLOSED	UNKNOWN	SINGLE	UNITED	UNDEFINED	11
FILE		CLOSED	UNKNOWN	SINGLE	UNITED	UNDEFINED	12
FILE		CLOSED	UNKNOWN	SINGLE	UNITED	UNDEFINED	13
FILE		CLOSED	UNKNOWN	SINGLE	UNITED	UNDEFINED	14
FILE		CLOSED	UNKNOWN	SINGLE	UNITED	UNDEFINED	15<


13 rows selected.


===================
CAUSE
As per the documentation, after creating or plugging in a new PDB, you must create and activate a master encryption key for the PDB. In a multitenant environment, each PDB has its own master encryption key which is stored in a single keystore used by all containers.
Reference:
https://docs.oracle.com/en/cloud/paas/database-dbaas-cloud/csdbi/create-master-encryption-key-pdb.html
Section: Creating and Activating a Master Encryption Key for a PDB
SOLUTION
After a new pluggable database is created, it is expected to create and activate a master encryption key for the PDB. Follow the below steps to create and activate the key for PDB:

-------------------------------------------------------------------------------------------------
-- 1. Verify the wallet status in container database:
-------------------------------------------------------------------------------------------------

	gm
alter session set container=cdb$root;

SQL> 
set linesize 200
set pagesize 20
col wrl_parameter format a50
SELECT con_id, wrl_parameter, status, wallet_type FROM v$encryption_wallet;

1	/opt/oracle/dcs/commonstore/wallets/BDMBDS2_UCA/tde/tde/tde/	OPEN	PASSWORD
2		CLOSED	UNKNOWN
3		CLOSED	UNKNOWN
4		OPEN	PASSWORD
5		OPEN	PASSWORD
6		CLOSED	UNKNOWN
7		CLOSED	UNKNOWN
8		CLOSED	UNKNOWN
9		CLOSED	UNKNOWN
10		CLOSED	UNKNOWN
11		CLOSED	UNKNOWN
12		CLOSED	UNKNOWN
13		CLOSED	UNKNOWN
14		CLOSED	UNKNOWN
15		CLOSED	UNKNOWN


-------------------------------------------------------------------------------------------------
-- 2. Disable the Auto-login option by moving cwallet.sso from TDE wallet directory.
-------------------------------------------------------------------------------------------------

  Example:
  $ cd /u01/app/oracle/admin/ORCL/tde_wallet
  sudo -su oracle
$ cd /u01/app/oracle/admin/BDMBDS/tde_wallet
  $ mv bak_cwallet bak_cwallet_old4
  $ mkdir bak_cwallet
  $ mv cwallet.sso bak_cwallet/

Verify there is no cwallet.sso file in /u01/app/oracle/admin/ORCL/tde_wallet.
Opening an autologin wallet gives following error, so need to rename the cwallet.sso to change the wallet type from autologin to password. As per the following note, the issue is addressed in  a bug 22826718  fix for 12.2 database version:
     Note 1944507.1 -TDE Wallet Problem in 12c: Cannot do a Set Key operation when an auto-login wallet is present

------------------------------------------------------------------------------------------------- 
-- 3. Close and reopen the wallet in container database:
-------------------------------------------------------------------------------------------------

[oracle@MbdsDBONCLOUD tde_wallet]$ 
sqlplus sys as sysdba

sqlplus sys as sysdba

SQL*Plus: Release 18.0.0.0.0 - Production on Sat Jul 25 20:25:05 2020
Version 18.3.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Enter password:

Connected to:
Oracle Database 18c Enterprise Edition Release 18.0.0.0.0 - Production
Version 18.3.0.0.0

SQL> ADMINISTER KEY MANAGEMENT SET KEYSTORE close;
ADMINISTER KEY MANAGEMENT SET KEYSTORE close;

  Verify the wallet status is closed:
           SQL> SELECT wrl_parameter, status, wallet_type FROM v$encryption_wallet;
set linesize 200
set pagesize 20
col wrl_parameter format a50
SELECT con_id, wrl_parameter, status, wallet_type FROM v$encryption_wallet;


    CON_ID WRL_PARAMETER                                      STATUS                         WALLET_TYPE
---------- -------------------------------------------------- ------------------------------ --------------------
         1 /u01/app/oracle/admin/BDMBDS/tde_wallet/           CLOSED                         UNKNOWN
         2                                                    CLOSED                         UNKNOWN
         3                                                    CLOSED                         UNKNOWN
         4                                                    CLOSED                         UNKNOWN
         5                                                    CLOSED                         UNKNOWN
         6                                                    CLOSED                         UNKNOWN
         7                                                    CLOSED                         UNKNOWN
         8                                                    CLOSED                         UNKNOWN
         9                                                    CLOSED                         UNKNOWN
        10                                                    CLOSED                         UNKNOWN
        11                                                    CLOSED                         UNKNOWN
        12                                                    CLOSED                         UNKNOWN

12 rows selected.

au 15/10/2020


    CON_ID WRL_PARAMETER                                      STATUS                         WALLET_TYPE
---------- -------------------------------------------------- ------------------------------ --------------------
         1 /u01/app/oracle/admin/BDMBDS/tde_wallet/           CLOSED                         UNKNOWN
         2                                                    CLOSED                         UNKNOWN
         3                                                    CLOSED                         UNKNOWN
         4                                                    CLOSED                         UNKNOWN
         5                                                    CLOSED                         UNKNOWN
         6                                                    CLOSED                         UNKNOWN
         7                                                    CLOSED                         UNKNOWN
         8                                                    CLOSED                         UNKNOWN
         9                                                    CLOSED                         UNKNOWN
        10                                                    CLOSED                         UNKNOWN
        11                                                    CLOSED                         UNKNOWN
        12                                                    CLOSED                         UNKNOWN
        13                                                    CLOSED                         UNKNOWN

13 rows selected.



  Reopen the wallet using password:
           SQL> ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  <wallet password>;

// GM :
Wallet password for DBMBDS:Ach1z0#d

ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;

Keystore altered


set linesize 200
set pagesize 20
col wrl_parameter format a50
SELECT con_id, wrl_parameter, status, wallet_type FROM v$encryption_wallet;
    CON_ID WRL_PARAMETER                                      STATUS                         WALLET_TYPE
---------- -------------------------------------------------- ------------------------------ --------------------
         1 /u01/app/oracle/admin/BDMBDS/tde_wallet/           OPEN                           PASSWORD
         2                                                    CLOSED                         UNKNOWN
         3                                                    CLOSED                         UNKNOWN
         4                                                    CLOSED                         UNKNOWN
         5                                                    CLOSED                         UNKNOWN
         6                                                    CLOSED                         UNKNOWN
         7                                                    CLOSED                         UNKNOWN
         8                                                    CLOSED                         UNKNOWN
         9                                                    CLOSED                         UNKNOWN
        10                                                    CLOSED                         UNKNOWN
        11                                                    CLOSED                         UNKNOWN
        12                                                    CLOSED                         UNKNOWN

12 rows selected.

    CON_ID WRL_PARAMETER                                      STATUS                         WALLET_TYPE
---------- -------------------------------------------------- ------------------------------ --------------------
         1 /u01/app/oracle/admin/BDMBDS/tde_wallet/           OPEN                           PASSWORD
         2                                                    CLOSED                         UNKNOWN
         3                                                    CLOSED                         UNKNOWN
         4                                                    CLOSED                         UNKNOWN
         5                                                    CLOSED                         UNKNOWN
         6                                                    CLOSED                         UNKNOWN
         7                                                    CLOSED                         UNKNOWN
         8                                                    CLOSED                         UNKNOWN
         9                                                    CLOSED                         UNKNOWN
        10                                                    CLOSED                         UNKNOWN
        11                                                    CLOSED                         UNKNOWN
        12                                                    CLOSED                         UNKNOWN
        13                                                    CLOSED                         UNKNOWN

13 rows selected.




-------------------------------------------------------------------------------------------------
-- 4. Switch to the newly created container to set the key and verify the wallet status:
-------------------------------------------------------------------------------------------------

select con_id, pdb_name from cdb_pdbs order by con_id;

3	PDBSOPHIA
2	PDB$SEED
4	PDBL3MIA
5	PDBCPROF
6	PDBM1ESA
7	PDBM1EZA
8	PDBESTIA
9	PDBITU
10	PDBCASA
11	PDBATLAS
12	PDBM1MIA

SQL> alter session set container=<new pdb name>;
		   



-- Activation de la clé de cryptagage pour la pdb : pdbm1eza
alter session set container=CDB$ROOT;
alter session set container=pdbmeza;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;
administer key management set key identified by  Ach1z0#d with backup;
-- Verify the wallet status of pdb:
set linesize 200
col wrl_parameter format A40
SELECT wrl_parameter, status, wallet_type FROM v$encryption_wallet;
WRL_PARAMETER                            STATUS                         WALLET_TYPE
---------------------------------------- ------------------------------ --------------------
                                         OPEN                           PASSWORD

alter session set container=CDB$ROOT;

-- Activation de la clé de cryptagage pour la pdb : PDBSOPHIA
alter session set container=PDBSOPHIA;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;
administer key management set key identified by  Ach1z0#d with backup;
-- Verify the wallet status of pdb:
set linesize 200
col wrl_parameter format A40
SELECT wrl_parameter, status, wallet_type FROM v$encryption_wallet;
WRL_PARAMETER                            STATUS                         WALLET_TYPE
---------------------------------------- ------------------------------ --------------------
                                         OPEN                           PASSWORD

alter session set container=CDB$ROOT;

-- Activation de la clé de cryptagage pour la pdb : PDBL3MIA
alter session set container=PDBL3MIA;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;
administer key management set key identified by  Ach1z0#d with backup;
-- Verify the wallet status of pdb:
set linesize 200
col wrl_parameter format A40
SELECT wrl_parameter, status, wallet_type FROM v$encryption_wallet;
WRL_PARAMETER                            STATUS                         WALLET_TYPE
---------------------------------------- ------------------------------ -------------------- 
                             OPEN                           PASSWORD



alter session set container=CDB$ROOT;

-- Activation de la clé de cryptagage pour la pdb : PDBCPROF
alter session set container=PDBCPROF;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;
administer key management set key identified by  Ach1z0#d with backup;
-- Verify the wallet status of pdb:
set linesize 200
col wrl_parameter format A40
SELECT wrl_parameter, status, wallet_type FROM v$encryption_wallet;
WRL_PARAMETER                            STATUS                         WALLET_TYPE
---------------------------------------- ------------------------------ --------------------
                                         OPEN                           PASSWORD

alter session set container=CDB$ROOT;

-- Activation de la clé de cryptagage pour la pdb : PDBM1ESA
alter session set container=PDBM1ESA;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;
administer key management set key identified by  Ach1z0#d with backup;
-- Verify the wallet status of pdb:
set linesize 200
col wrl_parameter format A40
SELECT wrl_parameter, status, wallet_type FROM v$encryption_wallet;
WRL_PARAMETER                            STATUS                         WALLET_TYPE
---------------------------------------- ------------------------------ --------------------
                                         OPEN                           PASSWORD

alter session set container=CDB$ROOT;

-- Activation de la clé de cryptagage pour la pdb : PDBESTIA
alter session set container=PDBESTIA;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;
administer key management set key identified by  Ach1z0#d with backup;
-- Verify the wallet status of pdb:
set linesize 200
col wrl_parameter format A40
SELECT wrl_parameter, status, wallet_type FROM v$encryption_wallet;
WRL_PARAMETER                            STATUS                         WALLET_TYPE
---------------------------------------- ------------------------------ --------------------
                                         OPEN                           PASSWORD

alter session set container=CDB$ROOT;


-- Activation de la clé de cryptagage pour la pdb : PDBITU
alter session set container=PDBITU;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;
administer key management set key identified by  Ach1z0#d with backup;
-- Verify the wallet status of pdb:
set linesize 200
col wrl_parameter format A40
SELECT wrl_parameter, status, wallet_type FROM v$encryption_wallet;
WRL_PARAMETER                            STATUS                         WALLET_TYPE
---------------------------------------- ------------------------------ --------------------
                                         OPEN                           PASSWORD

alter session set container=CDB$ROOT;

-- Activation de la clé de cryptagage pour la pdb : PDBCASA
alter session set container=PDBCASA;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;
administer key management set key identified by  Ach1z0#d with backup;
-- Verify the wallet status of pdb:
set linesize 200
col wrl_parameter format A40
SELECT wrl_parameter, status, wallet_type FROM v$encryption_wallet;
WRL_PARAMETER                            STATUS                         WALLET_TYPE
---------------------------------------- ------------------------------ --------------------
                                         OPEN                           PASSWORD

alter session set container=CDB$ROOT;

-- Activation de la clé de cryptagage pour la pdb : PDBM1MIA
alter session set container=PDBM1MIA;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;
administer key management set key identified by  Ach1z0#d with backup;
-- Verify the wallet status of pdb:
set linesize 200
col wrl_parameter format A40
SELECT wrl_parameter, status, wallet_type FROM v$encryption_wallet;
WRL_PARAMETER                            STATUS                         WALLET_TYPE
---------------------------------------- ------------------------------ --------------------
                                         OPEN                           PASSWORD

alter session set container=CDB$ROOT;

-- Activation de la clé de cryptagage pour la pdb : PDBATLAS
alter session set container=PDBATLAS;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;
administer key management set key identified by  Ach1z0#d with backup;
-- Verify the wallet status of pdb:
set linesize 200
col wrl_parameter format A40
SELECT con_id, wrl_parameter, status, wallet_type FROM v$encryption_wallet;

WRL_PARAMETER                            STATUS                         WALLET_TYPE
---------------------------------------- ------------------------------ --------------------
                                         OPEN                           PASSWORD

alter session set container=CDB$ROOT;

-- Activation de la clé de cryptagage pour la pdb : PDBBIHAR
alter session set container=PDBBIHAR;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;
administer key management set key identified by  Ach1z0#d with backup;
-- Verify the wallet status of pdb:
set linesize 200
col wrl_parameter format A40
SELECT wrl_parameter, status, wallet_type FROM v$encryption_wallet;

WRL_PARAMETER                            STATUS                         WALLET_TYPE
---------------------------------------- ------------------------------ --------------------
                                         OPEN                           PASSWORD


-- Activation de la clé de cryptagage pour la pdb : PDBBIHAR
alter session set container=CDB$ROOT;
alter session set container=PDBHAITI;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;
administer key management set key identified by  Ach1z0#d with backup;
-- Verify the wallet status of pdb:
set linesize 200
col wrl_parameter format A40
SELECT wrl_parameter, status, wallet_type FROM v$encryption_wallet;

-- Activation de la clé de cryptagage pour la pdb : PDBBIHAR
alter session set container=CDB$ROOT;
alter session set container=PDBM1INF;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;
administer key management set key identified by  Ach1z0#d with backup;
-- Verify the wallet status of pdb:
set linesize 200
col wrl_parameter format A40
SELECT wrl_parameter, status, wallet_type FROM v$encryption_wallet;



-- Activation de la clé de cryptagage pour la pdb : PDBM1ESA
alter session set container=CDB$ROOT;

-- Activation de la clé de cryptagage pour la pdb : PDBCPROF
alter session set container=PDBM1ESA;
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY  Ach1z0#d;
administer key management set key identified by  Ach1z0#d with backup;
-- Verify the wallet status of pdb:
set linesize 200
col wrl_parameter format A40
SELECT wrl_parameter, status, wallet_type FROM v$encryption_wallet;

-------------------------------------------------------------------------------------------------
-- 5. Switch to container database to enable autologin:
-------------------------------------------------------------------------------------------------

SQL> alter session set container=CDB$ROOT;

alter session set container=CDB$ROOT;
SELECT con_id, wrl_parameter, status, wallet_type FROM v$encryption_wallet;

1	/opt/oracle/dcs/commonstore/wallets/BDMBDS2_UCA/tde/tde/tde/	OPEN	PASSWORD
2		CLOSED	UNKNOWN
3		CLOSED	UNKNOWN
4		OPEN	PASSWORD
5		OPEN	PASSWORD
6		OPEN	PASSWORD
7		OPEN	PASSWORD
8		OPEN	PASSWORD
9		OPEN	PASSWORD
10		OPEN	PASSWORD
11		OPEN	PASSWORD
12		OPEN	PASSWORD
13		OPEN	PASSWORD
14		OPEN	PASSWORD
15		OPEN	PASSWORD
16		OPEN	PASSWORD

13 rows selected.

alter session set container=CDB$ROOT;

show pdbs;


Session modifié(e).


Session modifié(e).


    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO        
         3 PDBMBDS                        MOUNTED              
         4 PDBL3MIA                       READ WRITE NO        
         5 PDBMEZA                        READ WRITE NO        
         6 PDBM1ESA                       READ WRITE NO        
         7 PDBESTIA                       READ WRITE NO        
         8 PDBCPROF                       READ WRITE NO        
         9 PDBITU                         READ WRITE NO        
        10 PDBCASA                        READ WRITE NO        
        11 PDBATLAS                       READ WRITE NO        
        12 PDBM1INF                       READ WRITE NO        
        13 PDBM1MIA                       READ WRITE NO        
        14 PDBBIHAR                       READ WRITE NO        
        15 PDBHAITI                       READ WRITE NO        
        16 PDBSOPHIA                      READ WRITE NO        




SQL> administer key management create AUTO_LOGIN keystore from keystore '<TDE Wallet Location>' identified by <password of wallet> ;

administer key management create AUTO_LOGIN keystore from keystore '/u01/app/oracle/admin/BDMBDS/tde_wallet' identified by Ach1z0#d;


Restart the database for changes to take effect:
SQL> shut immediate
SQL> startup
It is required to reflect the wallet type from password to Autologin. Refer below note for more details:
Note 1251597.1 - Quick TDE Setup and FAQ
Section: How to make the wallet auto login in 12c?

Verify the wallet type, it will be autologin:
SQL> SELECT con_id, wrl_parameter, status, wallet_type FROM v$encryption_wallet;

SQL> 

set linesize 200
set pagesize 20
col wrl_parameter format a50
SELECT con_id, wrl_parameter, status, wallet_type FROM v$encryption_wallet;

    CON_ID WRL_PARAMETER                                      STATUS                         WALLET_TYPE
---------- -------------------------------------------------- ------------------------------ --------------------
         1 /u01/app/oracle/admin/BDMBDS/tde_wallet/           OPEN                           AUTOLOGIN
         2                                                    OPEN                           AUTOLOGIN
         3                                                    OPEN                           AUTOLOGIN
         4                                                    OPEN                           AUTOLOGIN
         5                                                    OPEN                           AUTOLOGIN
         6                                                    OPEN                           AUTOLOGIN
         7                                                    OPEN                           AUTOLOGIN
         8                                                    OPEN                           AUTOLOGIN
         9                                                    OPEN                           AUTOLOGIN
        10                                                    OPEN                           AUTOLOGIN
        11                                                    OPEN                           AUTOLOGIN
        12                                                    OPEN                           AUTOLOGIN

12 rows selected.



SELECT con_id, wrl_parameter, status, wallet_type FROM v$encryption_wallet;SQL> SQL> SQL>

    CON_ID WRL_PARAMETER                                      STATUS                         WALLET_TYPE
---------- -------------------------------------------------- ------------------------------ --------------------
         1 /u01/app/oracle/admin/BDMBDS/tde_wallet/           OPEN                           AUTOLOGIN
         2                                                    OPEN                           AUTOLOGIN
         3                                                    OPEN                           AUTOLOGIN
         4                                                    OPEN                           AUTOLOGIN
         5                                                    OPEN                           AUTOLOGIN
         6                                                    OPEN                           AUTOLOGIN
         7                                                    OPEN                           AUTOLOGIN
         8                                                    OPEN                           AUTOLOGIN
         9                                                    OPEN                           AUTOLOGIN
        10                                                    OPEN                           AUTOLOGIN
        11                                                    OPEN                           AUTOLOGIN
        12                                                    OPEN                           AUTOLOGIN
        13                                                    OPEN                           AUTOLOGIN

13 rows selected.


Sql> show pdbs


    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 PDBSOPHIA                        READ WRITE NO
         4 PDBL3MIA                       READ WRITE NO
         5 PDBCPROF                       READ WRITE NO
         6 PDBM1ESA                       READ WRITE NO
         7 PDBM1EZA                       READ WRITE NO
         8 PDBESTIA                       READ WRITE NO
         9 PDBITU                         READ WRITE NO
        10 PDBCASA                       READ WRITE NO
        11 PDBATLAS                        READ WRITE NO
        12 PDBM1MIA                        READ WRITE NO


Sql> alter session set container=pdbmeza ;

Sql> create tablespace ts_employe2
datafile
'/u02/app/oracle/oradata/BDMBDS/AA2677A06C5505DDE0534AF61D0A6F36/datafile/ts_employe2_1.dbf' size 20M;

 	▼
	Related		
	 
 		Products		
	 
•	Oracle Cloud > Oracle Platform Cloud > Oracle Cloud Infrastructure - Database Service > Oracle Cloud Infrastructure - Database Service > Core Database > DB Security
•	Oracle Cloud > Oracle Platform Cloud > Oracle Database Cloud Service > Oracle Database Cloud Service > DB Admin > General issues
 
 Back to Top



-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-- CREATION DE PLUGGABLE SUR LA BASE BDSECOURS disponible chez Gabriel
-------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- PLUGGABLE SUR LA BASE BDMBDS disponible chez OVH sur la machine Big Data Lite
----------------------------------------------------------------------------------


------------------------------------------------------------------------------------
-- Ajout du tablespace Users sur pdbl3mia
-------------------------------------------------------------------------------------
alter session set container=pdbl3mia;
Create tablespace users 
Datafile '+DATA/BDMBDS2_UCA/EFA02E0DFA1FF815E0531B00000A6CB8/DATAFILE/users01.dbf' size 500M autoextend on;



select tablespace_name, file_name from dba_data_files;

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;


------------------------------------------------------------------------------------
-- Ajout du tablespace Users sur PDBMEZA
-------------------------------------------------------------------------------------
alter session set container=PDBMEZA;
Create tablespace users 
Datafile '????+DATA/BDMBDS2_UCA/EFA02E0DFA1FF815E0531B00000A6CB8/DATAFILE/users01.dbf' size 500M autoextend on;



select tablespace_name, file_name from dba_data_files;

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;




------------------------------------------------------------------------------------
-- Ajout du tablespace Users sur PDBSOPHIA
-------------------------------------------------------------------------------------
alter session set container=PDBSOPHIA;
Create tablespace users 
Datafile '+DATA/BDMBDS2_UCA/EFB347537C5CFF66E0531B00000AB8BB/DATAFILE/users01.dbf' size 500M autoextend on;



select tablespace_name, file_name from dba_data_files;

TABLESPACE_NAME
------------------------------
FILE_NAME
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SYSTEM
+DATA/BDMBDS2_UCA/EFB347537C5CFF66E0531B00000AB8BB/DATAFILE/system.334.1123325395

SYSAUX
+DATA/BDMBDS2_UCA/EFB347537C5CFF66E0531B00000AB8BB/DATAFILE/sysaux.335.1123325395

UNDOTBS1
+DATA/BDMBDS2_UCA/EFB347537C5CFF66E0531B00000AB8BB/DATAFILE/undotbs1.333.1123325395

USERS
+DATA/BDMBDS2_UCA/EFB347537C5CFF66E0531B00000AB8BB/DATAFILE/users01.dbf



alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;




------------------------------------------------------------------------------------
-- Ajout du tablespace Users sur PDBESTIA
-------------------------------------------------------------------------------------
alter session set container=PDBESTIA;
Create tablespace users 
Datafile '+DATA/BDMBDS2_UCA/EFB347537C41FF66E0531B00000AB8BB/DATAFILE/users01.dbf' size 500M autoextend on;



select tablespace_name, file_name from dba_data_files;

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;


------------------------------------------------------------------------------------
-- Ajout du tablespace Users sur PDBCPROF
-------------------------------------------------------------------------------------
alter session set container=PDBCPROF;
Create tablespace users 
Datafile '+DATA/BDMBDS2_UCA/EFB347537C44FF66E0531B00000AB8BB/DATAFILE/users01.dbf' size 500M autoextend on;



select tablespace_name, file_name from dba_data_files;

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;



------------------------------------------------------------------------------------
-- Ajout du tablespace Users sur PDBITU
-------------------------------------------------------------------------------------
alter session set container=PDBITU;
Create tablespace users 
Datafile '+DATA/BDMBDS2_UCA/EFB347537C46FF66E0531B00000AB8BB/DATAFILE/users01.dbf' size 500M autoextend on;



select tablespace_name, file_name from dba_data_files;

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;



------------------------------------------------------------------------------------
-- Ajout du tablespace Users sur PDBCASA
-------------------------------------------------------------------------------------
alter session set container=PDBCASA;
Create tablespace users 
Datafile '+DATA/BDMBDS2_UCA/EFB347537C4AFF66E0531B00000AB8BB/DATAFILE/users01.dbf' size 500M autoextend on;



select tablespace_name, file_name from dba_data_files;

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;



------------------------------------------------------------------------------------
-- Ajout du tablespace Users sur PDBATLAS
-------------------------------------------------------------------------------------
alter session set container=PDBATLAS;
Create tablespace users 
Datafile '+DATA/BDMBDS2_UCA/EFB347537C4DFF66E0531B00000AB8BB/DATAFILE/users01.dbf' size 500M autoextend on;



select tablespace_name, file_name from dba_data_files;

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;



------------------------------------------------------------------------------------
-- Ajout du tablespace Users sur PDBBIHAR
-------------------------------------------------------------------------------------
alter session set container=PDBBIHAR;
Create tablespace users 
Datafile '+DATA/BDMBDS2_UCA/EFB347537C56FF66E0531B00000AB8BB/DATAFILE/users01.dbf' size 500M autoextend on;



select tablespace_name, file_name from dba_data_files;

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;



------------------------------------------------------------------------------------
-- Ajout du tablespace Users sur PDBM1MIA
-------------------------------------------------------------------------------------
alter session set container=PDBM1MIA;
Create tablespace users 
Datafile '+DATA/BDMBDS2_UCA/EFB347537C53FF66E0531B00000AB8BB/DATAFILE/users01.dbf' size 500M autoextend on;



select tablespace_name, file_name from dba_data_files;

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;



------------------------------------------------------------------------------------
-- Ajout du tablespace Users sur PDBHAITI
-------------------------------------------------------------------------------------
alter session set container=PDBHAITI;
Create tablespace users 
Datafile '+DATA/BDMBDS2_UCA/EFB347537C59FF66E0531B00000AB8BB/DATAFILE/users01.dbf' size 500M autoextend on;



select tablespace_name, file_name from dba_data_files;

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;


------------------------------------------------------------------------------------
-- Ajout du tablespace Users sur PDBHAITI
-------------------------------------------------------------------------------------
alter session set container=CDB$ROOT;
alter session set container=PDBM1ESA;
Create tablespace users 
Datafile '+DATA/BDMBDS2_UCA/EFB347537C3DFF66E0531B00000AB8BB/DATAFILE/users01.dbf' size 500M autoextend on;



select tablespace_name, file_name from dba_data_files;

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;

------------------------------------------------------------------------------------
-- Ajout du tablespace Users sur PDBM1INF
-------------------------------------------------------------------------------------
alter session set container=CDB$ROOT;
alter session set container=PDBM1INF;
Create tablespace users 
Datafile '+DATA/BDMBDS2_UCA/EFB347537C4FFF66E0531B00000AB8BB/DATAFILE/users01.dbf' size 500M autoextend on;



select tablespace_name, file_name from dba_data_files;

alter user pdbadmin default tablespace users;

alter user pdbadmin quota unlimited on users;

alter pluggable database default tablespace users;
