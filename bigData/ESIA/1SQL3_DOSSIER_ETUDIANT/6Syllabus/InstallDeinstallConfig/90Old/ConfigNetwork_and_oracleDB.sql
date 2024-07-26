La séance  complémentaire de tune 2 Oracle sera ce samedi 16/2/2021 de 15h à 20h.
Pour la rendre efficace, vous devez vous assurer de ce qui suit :
1) Oracle 12c ou 18c ou 19c est bien installé sur votre machine. Pour ce qui ont des problèmes d'installations, j'ai prévu une séance ce ce soir à partir de 18h. Voici les consignes pour réussir une installation :
1.1) Il faut télécharger Oracle 19c sur le site Oracle si ce n'est déjà fait. Une procédure d'installation est dans vos dossier du support de cours DBA1. Vous pour aussi installer une 12c elle est dans Onedrive (voir le lien déjà envoyé).
1.2) Pour ceux qui ont des problèmes avec une version (erreurs lors de l'installation liés aux problèmes de compatibilité, de mémoire, etc), en prévision de la réunion avec moi, ils doivent désinstaller (sous windows) comme suit :
1.2.1 sur la barre de recherche Tapez "services". Désactivez tous les services Oracle de la version à enlever et arrêtez les
1.2.2 Lancer sur la barre de recherche "regedit". puis allez dans les services oracle comme suit :
            hkeyLocalMachine->System->currentControlSet->Services
            Chercher les services Oracle de la version à déinstaller et supprimiez les tous
1.2.3 Procéder à la désinstallation du produit comme suit
           Demarrer->oracle-oracleDB19cHome1 ->Universall Installer
           Cliquer sur "Désinstaller les produits". Choissez le HOME à déinstaller
          Cliquez sur les + pour tout déplier
          Cochez tous les carrés sauf celui de la racine (par exemple : OraDB19Home)
          Cliquez sur "Enlever" pour tout déinstaller.
           
1.2.4 Lancer sur la barre de recherche "regedit". puis allez puis supprimé l'onglet oracle\cléVersion comme suit :
          hkeyLocalMachine->Software
          Chercher la clé "Oracle" sous cette clé, supprimez par exemple KEY_OraDB19Home1 de la version Oracle           concernée. S'il n'y pas d'autres clés. Vous pouvez supprimer la racine "oracle"
        Attention, avant de supprimer , notez les valeurs des clés suivantes :
          - ORACLE_BASE: exemple de valeur D:\app\Oracle19c
         - ORACLE_HOME : exemple de valeur : D:\1agm05092005\5Logiciels_new\Oracle19c\WINDOWS.X64_193000_db_home


1.2.5 Après les actions ci-dessus, arrêtez votre PC puis redémarrez le

1.2.6 Supprimer les dossiers
après redémarrage, supprimer les dossiers pointés par ORACLE_BASE et si séparé ORACLE_HOME

          - ORACLE_BASE: exemple de valeur D:\app\Oracle19c
         - ORACLE_HOME : exemple de valeur : D:\1agm05092005\5Logiciels_new\Oracle19c\WINDOWS.X64_193000_db_home
1.2.7 Encore peut d'effort. Si vous n'avez qu'une seule installation alors vous pouvez
dans c:\>programmes 
supprimez le dossier Oracle.

2) Vous avez une base CDB (par exemple ORCL) et une base pluggable (par exemple ORCLPDB). Pour connaitre le nom de votre pluggable faire ce suit :
c:\> sqlplus sys as sysdba
sql> show pdbs
vous devez voir, par exemple :
    CON_ID CON_NAME OPEN MODE RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED READ ONLY NO
         3  orclpdb    READ WRITE NO
Attention PDB$SEED est une base modèle pour créer d'autres pluggables. Ne pas utiliser.

Votre pluggable s'appelle alors orclpdb. Elle doit être en mode : read/wrie et restricted : NO
Si votre pluggable est mode mount faire ceci :
sql> alter pluggable database orclpdb open; -- permet de l'ouvrir

sql> alter pluggable database orclpdb save state; -- permet de conserver cet état au prochain redémarrage de la base
3) Vous vous connectez bien à vos deux bases via leur noms réseau comme suit par exemple :
c:\> sqlplus /nolog; 
sql> connect sys@orcl as sysdba; 
sql> connect pdbadmin@orclpdb/password

4) Si votre connexion à la pluggable ou à la CDB échoue avec l'erreur ORA-12xxx faite ce qui suit 
4.1) vérifier que le listener tourne sur votre machine. Si vous êtes sous windows
tapez "services" sur la barre de recherche, allez dans section des services Oracle. Assurez qui le service OracleOraDBNrVersionHome1TNSListener exemple OracleOraDB19Home1TNSListener tourne. Si ce service ne tourne pas, redémarrez le. S'il refuse de démarrer, faite ce qui suit :
Lancer l'invite de Commande DOS en tant qu'administrateur
c:\>lsnrctl 
LSNRCTL>status
s'il y a des erreurs, faire 
LSNRCTL>stop
puis
LSNRCTL>start
Il faut que vous ayez le message démarrage réussi. Laissez lui au moins 2 minutes pour se synchroniser avec votre base. Vous devez voir des choses comme ceci

...
Le service "orcl.unice.fr" comporte 1 instance(s).
  L'instance "orcl ", statut READY, comporte 1 gestionnaire(s) pour ce service...
Le service "orclpdb.unice.fr" comporte 1 instance(s).
  L'instance "orcl", statut READY, comporte 1 gestionnaire(s) pour ce service...
La commande a rÚussi

En effet si le LISTENER ne fonctionne pas, vous ne pouvez pas vous connecter avec les ALIAS

4.2) Vérifiez que les noms réseau : par exemple ORCL et ORCLPDB ont été créée
Lancer pour cela net manager comme suit :
Demarrer->oracle-oracleDB19cHome1 ->net manager

4.2.1) Déplier l'onglet : "Resolution de non de Services" (noms réseaux de bases de données)
Vous voyez probablement le nom réseau de la CDB exemple ORCL
Placez vous dessus.
testez ce nom en cliquant sur le bouton TEST en bas de la croix ROUGE
Si vous avez le message erreur de mot de passe etc c'est le nom est bon
Si vous avez une erreur ORA-12xxxx, c'est que cela peut être :
- Port dans l'alias pas. Par exemple le listener écoute sur 1522 et vous avez configuré 1521
- Listener arrêté (faire 4.1)
- Listener fonctionne mais n'écoute pas encore votre Base (attendre 2 minutes)
- La PDB est mode Mount
- Réseau coupé si base à distance
- La base ne tourne pas (base arrêté, etc.)
- Nom de services lors de la définition de l'alias faux. Pour connaitre le bon nom faire :
sqlplus sys as sysdba
sql> show parameter db_name (exemple ORCL)
sql> show parameter db_domain (exemple ORCL.UNICE.FR)
sql> show parameter  service (exemple ORCL.UNICE.FR)
Le nom du service à utiliser lors de la définition du Nom réseau doit être :
NomCDB.db_domain pour une CDB (exemple orcl.unice.fr)
et nomPDB.db_domain pour une pluggable (exemple orclpdb.unice.fr)

Dans tous les cas, corriger le ou les problèmes et réessayer le test.
4.2.2) Si la nom réseau de la pluggable n'est pas là, créér se nom
placez vous dans l'onglet  "Resolution de non de Services" 
Cliquez sur + (bouton VERS à Gauche en haut)
Renseigner ce qui suit fenêtre après fenêtre :
nom réseau : nomPDB (exemple pdborcl)
protocole réseau : TCP/IP
nom de l'hôte : localHost ou l'IP de la machine ou le nom réseau de la machine
port : 1521
nom de service : nompdb.db_domain (exemple orclpdb.unice.fr)
Type de connexion : Dédiée
Puis faire TEST dans la page suivante
Si Erreur de mot de passe (alors c'est bon) faire Fin puis fin
dans la fenetre principale, sauver la configuration réseau :
Fichier->Sauver la configuration réseau

5. refaire les tests de connexion 


c:\> sqlplus /nolog; 
sql> connect sys@orcl as sysdba; 
sql> connect pdbadmin@orclpdb/password