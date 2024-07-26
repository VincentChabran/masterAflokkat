/*-
 *
 *  This file is part of Oracle NoSQL Database
 *  Copyright (C) 2011, 2013 Oracle and/or its affiliates.  All rights reserved.
 *
 *  Oracle NoSQL Database is free software: you can redistribute it and/or
 *  modify it under the terms of the GNU Affero General Public License
 *  as published by the Free Software Foundation, version 3.
 *
 *  Oracle NoSQL Database is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public
 *  License in the LICENSE file along with Oracle NoSQL Database.  If not,
 *  see <http://www.gnu.org/licenses/>.
 *
 *  An active Oracle commercial licensing agreement for this product
 *  supercedes this license.
 *
 *  For more information please contact:
 *
 *  Vice President Legal, Development
 *  Oracle America, Inc.
 *  5OP-10
 *  500 Oracle Parkway
 *  Redwood Shores, CA 94065
 *
 *  or
 *
 *  berkeleydb-info_us@oracle.com
 *
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  EOF
 *
 */

package exoCours;

import oracle.kv.KVStore;
import java.util.List;
import java.util.Iterator;
import oracle.kv.KVStoreConfig;
import oracle.kv.KVStoreFactory;
import oracle.kv.FaultException;
import oracle.kv.StatementResult;
import oracle.kv.table.TableAPI;
import oracle.kv.table.Table;
import oracle.kv.table.Row;
import oracle.kv.table.PrimaryKey;
import oracle.kv.ConsistencyException;
import oracle.kv.RequestTimeoutException;
import java.lang.Integer;
import oracle.kv.table.TableIterator;


/**
 * An extremely simple KVStore client application that writes and reads a
 * single record.  It can be used to validate an installation.
 *
 * Before running this example program, start a KVStore instance.  The simplest
 * way to do that is to run KV Lite as described in the INSTALL document.  Use
 * the KVStore instance name, host and port for running this program, as
 * follows:
 *
 */
 
/** 
* Cette classe fournit les méthodes nécessaires pour gérer les pilotes. Il s'agit des fonctions suivantes:
 * createTablePilote : créé la table pilote
 * alterTablePiloteAddColumnAge : ajouter une colonne dans la table pilote
 * dropColumnAgeFromPiloteTable: suppression de la colonne age
 * dropTablePilote : suprime la table pilote
 * createIndexOnPilote : crée un index sur la colonne plnom de la table pilote
 * dropIndexOnPilte : supprime l'index créé précédemment
 * insertPiloteRows : Insère de nouvelles lignes dans la table pilote
 * deletePiloteRow : supprime le pilote inséré connaissant le clé primaire
 * multiDeletePiloteRows: supprime les pilotes ayant une même partie de la clé primaire
 * getPiloteByKey: charge un pilote connaissant sa clé primaire (pk) * multiGetPiloteByPartialKey
 * multiGetTableIteratorOnPiloteRows : accès aux pilotes avec une même shard key
 */
 
 
 /**
 
-- REMPLACER LE CHEMIN DE LA VM (C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0) 
-- CI-DESSOUS ET PARTOUT PAR LE VOTRE
cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

-- Créer la variable d'environnement VAGRANT_HOME qui servira plus tard
set VAGRANT_HOME=C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

-- vérifier si la vm tourne
vagrant status

Current machine states:

oracle-21c-vagrant        poweroff (virtualbox)

The VM is powered off. To restart the VM, simply run `vagrant up`

-- vérifier le status global
vagrant global-status

The above shows information about all known Vagrant environments
on this machine. This data is cached and may not be completely
up-to-date (use "vagrant global-status --prune" to prune invalid
entries). To interact with any of the machines, you can go to that
directory and run Vagrant, or you can use the ID directly with
Vagrant commands from any directory. For example:
"vagrant destroy 1a2b3c4d"



-- Arrêter si nécfessaire puis Activer la machine virtuelle Big Data
vagrant halt

vagrant up

-- S'il des erreurs veuillez contacter l'administreur de la VM

-- Pour lancer des composants, se connecter à la VM via SSH en lançant
cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

vagrant ssh

----------------------------------------------------------------------------------------------------------------
-- Oracle NOSQL sur vagrant 
-- démarrage du serveur oracle nosql au premier lancement de la VM en mode non secure
----------------------------------------------------------------------------------------------------------------

nohup java -Xmx64m -Xms64m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT &
-- 

----------------------------------------------------------------------------------------------------------------
-- Démarrage de Hadoop
----------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------
-- Démarrage de Hadoop HDFS
----------------------------------------------------------------------------------------------------------------

start-dfs.sh

----------------------------------------------------------------------------------------------------------------
-- Démarrage de Hadoop YARN
----------------------------------------------------------------------------------------------------------------

start-yarn.sh


----------------------------------------------------------------------------------------------------------------
-- Démarrage du serveur Hadoop HIVE
----------------------------------------------------------------------------------------------------------------


nohup hive --service metastore > /dev/null &
nohup hiveserver2 > /dev/null &


-- Ouvrir un CMD pour lancer la compilation et l'exécution avec java
export MYTPHOME=/vagrant/TpBigData

-- Sous MYTPHOME on trouvera:
tpnosql/exoCours/Pilote.java



-- Etape 3 : Compiler et executer la classe Pilote.java

-- compilation
javac -g -cp $KVHOME/lib/kvclient.jar:$MYTPHOME/tpnosql $MYTPHOME/tpnosql/exoCours/Pilote.java  

-- Exécution
java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYTPHOME/tpnosql exoCours.Pilote 


 */
 
public class Pilote {
    private final KVStore store;
    /**
     * Runs the Pilote command line program.
     */
    public static void main(String args[]) {
        try {
            	Pilote unPilote= new Pilote(args);
	Pilote.testDdlCommandOnPilote(unPilote);
	Pilote.testMajPilote(unPilote);
	Pilote.testLectureLignesPilote(unPilote, "Baron",8,"Milo, Haïti");
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
    }


	/**
		 * Parses command line args and opens the KVStore
	 */
	Pilote(String[] argv) {
		String storeName = "kvstore";
		String hostName = "localhost";
		String hostPort = "5000";
		final int nArgs = argv.length;
		int argc = 0;
		store = KVStoreFactory.getStore
		(new KVStoreConfig(storeName, hostName + ":" + 	hostPort));
	}


    private void usage(String message) {
        System.out.println("\n" + message + "\n");
        System.out.println("usage: " + getClass().getName());
        System.out.println("\t-store <instance name> (default: kvstore) " +
                           "-host <host name> (default: localhost) " +
                           "-port <port number> (default: 5000)");
        System.exit(1);
    }

    /**
     * Performs example operations and closes the KVStore.
     */
    // void runExample() {

        // final String keyString = "Hello";
        // final String valueString = "Big Data World!";

        // store.put(Key.createKey(keyString),
                  // Value.createValue(valueString.getBytes()));

        // final ValueVersion valueVersion = store.get(Key.createKey(keyString));

        // System.out.println(keyString + " " +
                           // new String(valueVersion.getValue().getValue()));

        // store.close();
    // }
	
	/**
	* Affichage du résultat pour les commandes DDL (CREATE, ALTER, DROP)
	*/
	private void displayResult(StatementResult result, String statement) {
		System.out.println("===========================");
		if (result.isSuccessful()) {
			System.out.println("Statement was successful:\n\t" +statement);
			System.out.println("Results:\n\t" + result.getInfo());
		} else if (result.isCancelled()) {
			System.out.println("Statement was cancelled:\n\t" +statement);
		} 
	
		else {
	/**
	* statement was not successful: may be in error, or may still
	* be in progress.
	*/
	if (result.isDone()) {
		System.out.println("Statement failed:\n\t" + statement);
		System.out.println("Problem:\n\t" 			+result.getErrorMessage());
	}
	else {
		System.out.println("Statement in progress:\n\t" 	+statement);
		System.out.println("Status:\n\t" + result.getInfo());
	}
	  }
	}



	public void createPilote() {
		StatementResult result = null;
		String statement = null;
		System.out.println("****** Dans : createPilote ********" );
		try {
		/*
		* Add a table to the database.
		* Execute this statement asynchronously.
		*/
		statement ="create table pilote("+"plnum    INTEGER,"+  
		"plnom  STRING,"+"dnaiss STRING,"+ "adr    STRING,"+ 
		"tel    STRING,"+ "sal    FLOAT,"+ 
		"PRIMARY KEY (shard(plnom, adr), plnum)";

			result = store.executeSync(statement);
			displayResult(result, statement);
		} catch (IllegalArgumentException e) {
			System.out.println("Invalid statement:\n" + 			e.getMessage());
		} catch (FaultException e) {
			System.out.println("Statement couldn't be executed, 		please retry: " + e);
		}
	}
		
	
	/**
		* createIndexOnPilote : crée un index sur la colonne plnom de la table pilote
	*/
		public void createIndexOnPilote() {
			StatementResult result = null;
			String statement = null;
			try {	/*
				* Création d'un index sur la colonne PLNOM de la table pilote.
				* Execute this statement asynchronously.
				*/
				statement ="create index idx_pilote_plnom on pilote(plnom)";
				result = store.executeSync(statement);
				displayResult(result, statement);
			} catch (IllegalArgumentException e) {
				System.out.println("Invalid statement:\n" + e.getMessage());
			} catch (FaultException e) {
				System.out.println("Statement couldn't be executed, please retry: " + e);
			}
		}
		

	/**
	 * alterTablePiloteAddColumnAge : ajouter une colonne dans la table pilote
	*/
		public void alterTablePiloteAddColumnAge() {
			StatementResult result = null;
			String statement = null;
			try {	/*
				* Ajout d'une colonne à la table pilote.
				* Execute this statement asynchronously.
				*/
				statement ="alter table pilote (add age INTEGER)";
				result = store.executeSync(statement);
				displayResult(result, statement);
			} catch (IllegalArgumentException e) { System.out.println("Invalid statement:\n" + e.getMessage());
			} catch (FaultException e) { System.out.println("Statement couldn't be executed, please retry: " + e);
			}
		}


	/**
		 * dropColumnAgeFromPiloteTable: suppression de la colonne age
	*/
		public void dropColumnAgeFromPiloteTable() {
			StatementResult result = null;
			String statement = null;
			try {
				/*
				* Suppression d'une colonne à la table pilote.
				* Execute this statement asynchronously.
				*/
				statement ="alter table pilote (drop age)";

				result = store.executeSync(statement);
				displayResult(result, statement);
			} catch (IllegalArgumentException e) {
				System.out.println("Invalid statement:\n" + e.getMessage());
			} catch (FaultException e) {
				System.out.println("Statement couldn't be executed, please retry: " + e);
			}
		}
		


	
		/**
		* dropIndexOnPilte : supprime l'index créé précédemment
		*/
		public void dropIndexOnPilte() {
			StatementResult result = null;
			String statement = null;
			try {
				/*
				* Suppression d'un index sur la colonne PLNOM de la table pilote.
				* Execute this statement asynchronously.
				*/
				statement ="drop index idx_pilote_plnom on pilote";

				result = store.executeSync(statement);
				displayResult(result, statement);
			} catch (IllegalArgumentException e) {System.out.println("Invalid statement:\n" + e.getMessage());
			} catch (FaultException e) {System.out.println("Statement couldn't be executed, please retry: " + e);
			}
		}

	/**
		* dropTablePilote : suprime la table pilote
	*/

		public void dropTablePilote() {
			StatementResult result = null;
			String statement = null;
			try {
				/*
				* Suppression de la table pilote.
				*/
				statement ="drop table pilote";

				result = store.executeSync(statement);
				displayResult(result, statement);
			} catch (IllegalArgumentException e) {System.out.println("Invalid statement:\n" + e.getMessage());
			} catch (FaultException e) {System.out.println("Statement couldn't be executed, please retry: " + e);
			}
		}


	/**
	* insertAPiloteRow : Insère une nouvelle ligne dans la table pilote
	*/
	private void insertAPiloteRow (int plnum, String plnom, String dnaiss, String adr, String tel, float sal){
	StatementResult result = null;
	String statement = null;
	try {
		TableAPI tableH = store.getTableAPI();

	// The name you give to getTable() must be identical to the name that you gave the table when you created the table using 
	// the CREATE TABLE DDL statement.
	Table tablePilote = tableH.getTable("pilote");

	// Get a Row instance
	Row piloteRow = tablePilote.createRow();

	// Now put all of the cells in the row. This does NOT actually write the data to  the store. Create one row
	piloteRow.put("plnum", plnum);
	piloteRow.put("plnom", plnom);
	piloteRow.put("dnaiss", dnaiss);
	piloteRow.put("adr", adr);
	piloteRow.put("tel", tel);
	piloteRow.put("sal", sal);

	// Now write the table to the store.
	// "item" is the row's primary key. If we had not set that value,
	// this operation will throw an IllegalArgumentException.
	tableH.put(piloteRow, null, null);
	} 
	catch (IllegalArgumentException e) {
		System.out.println("Invalid statement:\n" + e.getMessage());
	} 
	catch (FaultException e) {
		System.out.println("Statement couldn't be executed, please retry: " + e);
	}

	}


	/**
		* insertPiloteRows : Insère de nouvelles lignes dans la table pilote en appelant la fonction insertAPiloteRow
	*/
		public void insertPiloteRows() {
			try {
				this.insertAPiloteRow(1, "Gagarin", "09/03/1934", "Klouchino, Russie", "0071122334455", 10000.75F);
				this.insertAPiloteRow(2, "Jähn Sigmund", "13/02/1937", "Morgenröthe-Rautenkranz, Allemagne", "0049199999999", 12000.5F);
				this.insertAPiloteRow(3, "Icare", "13/02/1947", "Athène, Grèce", "00300623344556", 8000.5F);
				this.insertAPiloteRow(3, "Icare", "13/02/1000", "Olympe, Grèce", "00300623344577", 8500.5F);
				this.insertAPiloteRow(3, "Icare", "14/02/1900", "Le Pirée, Grèce", "00300623344588", 8600.5F);
				this.insertAPiloteRow(4, "Zorro", "14/02/1880", "Los Angeles, USA", "0010623344588", 8600.5F);
				this.insertAPiloteRow(4, "Pagnol", "14/02/1980", "Marseille, France", "00330623344589", 8700.5F);
				this.insertAPiloteRow(5, "Bleck", "14/02/2010", "Marseille, France", "00330623344589", 8700.5F);
				this.insertAPiloteRow(6, "Erzulie", "13/02/1804", "Port-au-Prince, Haïti", "005090623344557", 13000.5F);
				this.insertAPiloteRow(7, "Erzulie", "14/04/1804", "Les Cayes, Haïti", "0050906233445607", 14000.5F);
				this.insertAPiloteRow(8, "Baron", "15/01/1809", "Milo, Haïti", "0050906233445607", 14000.5F);
				this.insertAPiloteRow(8, "Baron", "16/04/1812", "Cap, Haïti", "0050906233445607", 14000.5F);
				this.insertAPiloteRow(9, "Baron", "14/04/1890", "Port-à-Piment, Haïti", "0050906233445607", 14000.5F);
			} catch (IllegalArgumentException e) {
				System.out.println("Invalid statement:\n" + e.getMessage());
			} catch (FaultException e) {
				System.out.println("Statement couldn't be executed, please retry: " + e);
			}
		}

	/**
	* deletePiloteRow : supprime un pilote connaissant la clé entièrement renseignée
	*/
	public void deletePiloteRow(String plnom, int plnum, String adr){
	StatementResult result = null;
	String statement = null;
	try {
	TableAPI tableH = store.getTableAPI();
	// The name you give to getTable() must be identical
	// to the name that you gave the table when you created
	// the table using the CREATE TABLE DDL statement.
	Table tablePilote = tableH.getTable("pilote");
	// Get the primary key for the row that we want to delete
	PrimaryKey pilotePrimaryKey = tablePilote.createPrimaryKey();
	pilotePrimaryKey.put("plnom", plnom);
	pilotePrimaryKey.put("plnum", plnum);
	pilotePrimaryKey.put("adr", adr);

	// Now delete rows with the same name.
	// this operation will throw an IllegalArgumentException.
	tableH.delete(pilotePrimaryKey, null, null);
	} catch (IllegalArgumentException e) {
	System.out.println("Invalid statement:\n" + e.getMessage());
	} catch (FaultException e) {
	System.out.println("Statement couldn't be executed, please retry: " + e);
	}
	}

	public void multiDeletePiloteRows(String plnom, String adr) {
		StatementResult result = null;
		String statement = null;
		try {
		TableAPI tableH = store.getTableAPI();

		// The name you give to getTable() must be identical
		// to the name that you gave the table when you created
		// the table using the CREATE TABLE DDL statement.
		Table tablePilote = tableH.getTable("pilote");

		// Get the partial primary key for the row that we want to delete
		PrimaryKey pilotePrimaryKey = tablePilote.createPrimaryKey();

	// Supprimer tous les pilotes ayant le nom Icare
	// La PK composé (plnom, plnum, adr) sera renseigné
	// partiellement(plnome et plnum uniquement).
	pilotePrimaryKey.put("plnom", plnom);
	pilotePrimaryKey.put("adr", adr);

	// Now delete the table rows in the store.
	// "item" is the row's primary key. If we had not set that value,
	// this operation will throw an IllegalArgumentException.
	tableH.multiDelete(pilotePrimaryKey, null, null);
	} catch (IllegalArgumentException e) {
		System.out.println("Invalid statement:\n" + e.getMessage());
	} catch (FaultException e) {
		System.out.println("Statement couldn't be executed, please 	retry: " + e);
	}
	}	


	/**
	* displayPiloteRow : Affichage d’une ligne de la table PILOTE
	*/

	private void displayPiloteRow (Row piloteRow) {
	System.out.println("===========================");
	Integer plnum1 = piloteRow.get("plnum").asInteger().get();
	String plnom1 = piloteRow.get("plnom").asString().get();
	String dnaiss1 = piloteRow.get("dnaiss").asString().get();
	String adr1 = piloteRow.get("adr").asString().get();
	String tel1= piloteRow.get("tel").asString().get();
	Float sal1= piloteRow.get("sal").asFloat().get();
	System.out.println("Pilote row :{ plnum=" + plnum1 + " plnom="+plnom1 +" dnaiss="+dnaiss1+" adr="+adr1+
	" tel="+tel1+ "salaire="+sal1+"}");
	}

	/**
	* getPiloteByKey : Lecture d'un pilote connaissant sa clé primaire
	* entièrement renseignée
	*/
	private void getPiloteByKey(String plnom,  int plnum, String adr){
	StatementResult result = null;
	String statement = null;
	try { 
	TableAPI tableH = store.getTableAPI();

	// The name you give to getTable() must be identical
	// to the name that you gave the table when you created
	// the table using the CREATE TABLE DDL statement.
	Table tablePilote = tableH.getTable("pilote");

	PrimaryKey key=tablePilote.createPrimaryKey();
	key.put("plnom", plnom);
	key.put("adr", adr);
	key.put("plnum", plnum);
	// Retrieve the row. This performs a store read operation.
	// Exception handling is skipped for this trivial example.
	Row row = tableH.get(key, null);

	// Now retrieve the individual fields from the row.
	displayPiloteRow(row);
	} catch (IllegalArgumentException e) {
		System.out.println("Invalid statement:\n" + e.getMessage());
	} catch (FaultException e) {
		System.out.println("Statement couldn't be executed, please retry: " + e);
	}
	}

	/**
	* multiGetPiloteByPartialKey : Lecture des pilotes ayant une même shard key(même nom et même adresse). La PK partiellement renseignée
	*/
	private void multiGetPiloteByPartialKey(String plnom, String adr){
		StatementResult result = null;
		String statement = null;
		try {
		TableAPI tableH = store.getTableAPI();

		// The name you give to getTable() must be identical
		// to the name that you gave the table when you created
		// the table using the CREATE TABLE DDL statement.
		Table tablePilote = tableH.getTable("pilote");
		PrimaryKey key = tablePilote.createPrimaryKey();
		key.put("plnom", plnom);
		key.put("adr", adr);

		// Retrieve the rows. This performs a store read operation.
		// Exception handling is skipped for this trivial example.
		List<Row> myPiloteRows = null;
		try {
		myPiloteRows = tableH.multiGet(key, null, null);
		} catch (ConsistencyException ce) {
			// The consistency guarantee was not met
		} catch (RequestTimeoutException re) {
		// The operation was not completed within the
		// timeout value
		}

		for (Row piloteRow: myPiloteRows) {
					displayPiloteRow(piloteRow);
				}
			} 
			catch (IllegalArgumentException e) {
				System.out.println("Invalid statement:\n" + 	e.getMessage());
			} 
			catch (FaultException e) {
				System.out.println("Statement couldn't be executed, 	please retry: " + e);
			}

	}


	/**
	* multiGetIteratorOnPiloteRows : Lecture des pilotes ayant une même shard  key(même nom et même adresse). La PK partiellement renseignée
	*/
	private void multiGetTableIteratorOnPiloteRows(String plnom, String adr){
	StatementResult result = null;
	String statement = null;
	try {
	TableAPI tableH = store.getTableAPI();

	// The name you give to getTable() must be identical
	// to the name that you gave the table when you created
	// the table using the CREATE TABLE DDL statement.

	Table tablePilote = tableH.getTable("pilote");
				
	PrimaryKey key = tablePilote.createPrimaryKey();
	key.put("plnom", plnom);
	key.put("adr", adr);

	// Exception handling is omitted, but in production code
	// ConsistencyException, RequestTimeException, and FaultException
	// would have to be handled.

	TableIterator<Row> iter = tableH.tableIterator(key, null, null);

	try {	
				while (iter.hasNext()) {
						Row piloteRow = iter.next();
						displayPiloteRow(piloteRow);
				}
				} finally {
					if (iter != null) { iter.close();}
				}
			} 
			catch (IllegalArgumentException e) {
				System.out.println("Invalid statement:\n" + e.getMessage());
			} 
			catch (FaultException e) {
				System.out.println("Statement couldn't be executed, please retry: " + e);
			}
	}

	/**
	* displayCheckupRow : Affichage d’une ligne de la table CHECKUP
	*/
	private void displayCheckupRow (Row checkupRow) {
	// Now retrieve the individaul fields from the row.
	Integer plnum1 = checkupRow.get("plnum").asInteger().get();
	String plnom1 = checkupRow.get("plnom").asString().get();
	String adr1 = checkupRow.get("adr").asString().get();
	Integer cunum1= checkupRow.get("cunum").asInteger().get();
	String cudate1= checkupRow.get("cudate").asString().get();
	String  curesultat1= checkupRow.get("curesultat").asString().get();
	System.out.println("checkup row :{ plnum="+ plnum1 + "plnom"+plnom1 +" adr="+adr1+" cunum ="+ cunum1 +" cudate1 ="+ cudate1+"curesultat="+curesultat1+"}");
	}

	/**
	* getCheckupByKey : Lecture du checkup d’un pilote connaissant sa clé primaire entièrement renseignée
	*/
	private void getCheckupByKey(String plnom,  int plnum, String adr,  int cunum){
	StatementResult result = null;
	String statement = null;
	try {
	TableAPI tableH = store.getTableAPI();

	// The name you give to getTable() must be identical
	// to the name that you gave the table when you created
	// the table using the CREATE TABLE DDL statement.
	Table tableCheckup = tableH.getTable("pilote.checkup");

	PrimaryKey key=tableCheckup.createPrimaryKey();
	key.put("plnom", plnom);
	key.put("adr", adr);
	key.put("plnum", plnum);
	key.put("cunum", cunum);

				
	// Retrieve the row. This performs a store read operation.
	// Exception handling is skipped for this trivial example.
	Row row = tableH.get(key, null);

				// Now retrieve the individual fields from the row.
				 displayCheckupRow (row);
			} 
			catch (ConsistencyException ce) {
				System.out.println("Consistency exception:\n" + 	ce.getMessage());
			} 
			catch (RequestTimeoutException re) {
				System.out.println("Request timeout exception:\n" + re.getMessage());
			}
			catch (Exception e) {
				System.out.println("Toutes Exceptions:\n" + e.getMessage());
			}
		}

	/**
	*multiGetCheckupAncestorsOrChild : Lecture des pilotes ou
	*des checkup de pilotes ayant une même shard key(même
	* nom et même adresse). La PK partiellement renseignée
	*/ 
	private void multiGetCheckupAncestorsWithOrWithOutChild(
	String plnom, String adr){
	StatementResult result = null;
	String statement = null;
	try { 
	TableAPI tableH = store.getTableAPI();

	// The name you give to getTable() must be identical
	// to the name that you gave the table when you created
	// the table using the CREATE TABLE DDL statement.
	Table tablePilote = tableH.getTable("pilote");
	Table tableCheckup = tableH.getTable("pilote.checkup");
	PrimaryKey key = tablePilote.createPrimaryKey();
	key.put("plnom", plnom);
	key.put("adr", adr);

	// Get a MultiRowOptions and tell it to look at both the child tables 
	MultiRowOptions mro = new MultiRowOptions(null, null, 				Arrays.asList(tableCheckup )); 

	// Retrieve the rows. 
	TableIterator<Row> iter=tableH.tableIterator(key, mro, null); 

	while (iter.hasNext()) { 
	Row row = iter.next(); 

	// display parent rows
	if (row.getTable().equals(tablePilote))  displayPiloteRow (row);

	// display children rows
	else if (row.getTable().equals(tableCheckup))
		displayCheckupRow (row);
	} 
		} 
		catch (ConsistencyException ce) {
			System.out.println("Consistency exception:\n" + ce.getMessage());
		} 
		catch (RequestTimeoutException re) {
			System.out.println("Request timeout exception:\n" + re.getMessage());
		}
		catch (Exception e) {
			System.out.println("Toutes Exceptions:\n" + e.getMessage());
		}
	}




	/**
	*multiGetCheckupChildAndAncestors: Lecture des checkup de pilotes et des 
	*ancêtres liés aux checkup ayant  une même shard key(même nom et même
	* adresse). La PK partiellement renseignée
	*/ 	
	private void multiGetCheckupChildAndAncestors (String plnom, String adr){
	TableAPI tableAPI = store.getTableAPI();
	StatementResult result = null;
	String statement = null;
	try { 
	TableAPI tableH = store.getTableAPI();
	Table tablePilote = tableH.getTable("pilote");
	Table tableCheckup = tableH.getTable("pilote.checkup");
	PrimaryKey key = tableCheckup.createPrimaryKey();
	key.put("plnom", plnom);
	key.put("adr", adr);
	// Get a MultiRowOptions and tell it to look at both the child tables 
	MultiRowOptions mro = new MultiRowOptions(null, 				Arrays.asList(tablePilote ), null); 



	// Retrieve the rows. 
	TableIterator<Row> iter = tableH.tableIterator(key, mro, null); 
	while (iter.hasNext()) {  
	Row row = iter.next(); 
	// display parent rows
	if (row.getTable().equals(tablePilote)) displayPiloteRow (row);
	// display children rows
	else if (row.getTable().equals(tableCheckup)) displayCheckupRow (row);
	} 
	} catch (ConsistencyException ce) {
		System.out.println("Consistency exception:\n" +ce.getMessage());
	} catch (RequestTimeoutException re) {
		System.out.println("Request timeout exception:\n" + re.getMessage());
	} catch (IllegalArgumentException e) {
		System.out.println("Invalid statement:\n" + e.getMessage());
	} catch (FaultException e) {
		System.out.println("Statement couldn't be executed, please retry: " + e);
	}
	}

	/**
	* multiGetOverIndex: Lecture via index
	*/
	private void multiGetOverIndexIdxPilotePlnom(String plnom){
	StatementResult result = null;
	String statement = null;
	try { 
	TableAPI tableH = store.getTableAPI();
	Table tablePilote = tableH.getTable("pilote");
		
	// Construct the IndexKey. The name we gave our index when 
	// we created it was ‘idx_pilote_plnom'. 
	Index idxPilotePlnom = tablePilote.getIndex("idx_pilote_plnom "); 
	IndexKey idxPilotePlnomKey = idxPilotePlnom.createIndexKey(); 
	idxPilotePlnomKey.put("plnom", plnom);

	// Retrieve the rows. 
	TableIterator<Row> iter = tableH.tableIterator(idxPilotePlnomKey , null, null); 
	while (iter.hasNext()) { 
	Row row = iter.next(); 
	// display pilote rows
	displayPiloteRow (row);
	} 
	} catch (ConsistencyException ce) {
		System.out.println(" Consistency exception:\n" + ce.getMessage());
	} catch (RequestTimeoutException re) {
		System.out.println(" Request timeout exception:\n" + re.getMessage());
	} catch (IllegalArgumentException e) {
		System.out.println("Invalid statement:\n" + e.getMessage());
	} catch (FaultException e) {
		System.out.println("Statement couldn't be executed, please retry: " + e);
	}
	}



		
}