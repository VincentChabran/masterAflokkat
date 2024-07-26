++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Exercice MOOCEBFR3 : Ingénierie des Données du Big Data: SGBD Objet relationnel et SQL3 Oracle
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

****************************************************************************************************************
* Exercices Module M3.5 : Gestion des objets volumineux
****************************************************************************************************************

----------------------------------------------------------------------------------------------------------------
-- M3.5.1 Manipultation des objets volumineux
----------------------------------------------------------------------------------------------------------------

-- Cet exercice est complémentaire à l'exercice libre du module 3.3
-- Vous devez avoir installé oracle sur votre poste.

-- Adapter le code ci-dessous pour charger les CV des Employés vers la table employe_o (voir exercice libre
-- module 3.3). Cette activité doit être faite en suivant les étapes suivantes.

-- Etape 1 : Création du répertoire sous L'OS

-- choisir un disque ou vous avez de l'espace. Attention ce répertoire fait partie maintenant de votre base

-- mkdir 'C:\CVDIRECTORY\orcl\BFILES\';

-- Etape 2 : déposer les fichiers contenant les CV pour chacun des Employés dans ce répertoire

--exemple cv1Miloud.txt, cv2Boumlid.txt, cv3Milou.txt,
--cv4Miloud.txt,cv5Chanik.txt

-- Etape 3. Créer la table contenant le BFILE pour faire le lien avec les fichiers

create table empCVFiles(
	empno	number (4) references employe_o,
	ename	varchar2(15),
	cvFile	bfile
);

-- Etape 4. Créer dans la base de données Oracle un objet DIRECTORY
CREATE OR REPLACE DIRECTORY bfile_dir 
	AS 'C:\CVDIRECTORY\orcl\BFILES\';

--'
-- Etape 5. Insertion des bfiles (associer à chaque employé le fichier de son CV
delete from empCVFiles;
INSERT INTO empCVFiles
	VALUES(1, 'MILOUD', BFILENAME('BFILE_DIR', 'cv1Miloud.txt'));
INSERT INTO empCVFiles
VALUES(2, 'BOUMLID', BFILENAME('BFILE_DIR', 'cv2Boumlid.txt'));
INSERT INTO empCVFiles
	VALUES(3, 'MILOU', BFILENAME('BFILE_DIR', 'cv3Milou.txt'));
INSERT INTO empCVFiles
	VALUES(4, 'MILOUD', BFILENAME('BFILE_DIR', 'cv4Miloud.txt'));
INSERT INTO empCVFiles
	VALUES(5, 'CHANIK', BFILENAME('BFILE_DIR', 'cv5Chanik.txt'));

	
-- Etape 6 : Ecrire un programme PLSQL qui permet de copier les CV du file system vers la base
-- Adapter le code ci-dessus pour charger un CV pour un employé donné.
-- Dans la colonne CV de la table employe_o copier les cv dans la colonne CV de la table employe_o
declare
cursor c is
select empno, cvFile from empCVFiles;
v_clob clob;
lg number(38);
begin
for j in c
loop
Dbms_Lob.FileOpen ( j.cvFile, Dbms_Lob.File_Readonly );
lg:=Dbms_Lob.GETLENGTH(j.cvFile);

select e.cv into v_clob  
from employe_o e
where e.empno=J.empno for update;

Dbms_Lob.LoadFromFile
(
dest_lob => v_clob,
src_lob => j.cvFile,
amount => lg, 
dest_offset => 1,
src_offset => 1
);
--amount => 4294967296, /* = 4Gb */
Dbms_Lob.FileClose ( j.cvFile );
end loop;
commit;
end;
/

----------------------------------------------------------------------------------------------------------------
-- M3.5.2 Activités supplémentaires à faire sur les objets volumineux
----------------------------------------------------------------------------------------------------------------

-- M3.5.2.1 Vérifier que les CV ont été copiés dans la base
?

-- M3.5.2.2 Affichez via SQL le CV de chaque Employé
?

-- M3.5.2.2 Extraction des objets volumineux vers le file system

-- Créer un objet DIRECTORY pointant le répertoire physique ci-dessous
CREATE OR REPLACE DIRECTORY extract_bfile_dir AS 'C:\FROMDBCVDIRECTORY\orcl\BFILES\';

'
-- Ecrire un programme PLSQL qui permet d''extraire les CV depuis la base de données vers le file System