/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package galerie;

import java.io.IOException;
import java.sql.*;


public class Galerie{

public static void main(String[] argv) throws SQLException, ClassNotFoundException{
try {
    Class.forName("oracle.jdbc.driver.OracleDriver" );

    Connection conn = DriverManager.getConnection(
			"jdbc:oracle:thin:@144.21.67.201:1521/PDBBDS1.631174089.oraclecloud.internal", "MOPOLO2B2223", "MOPOLO2B222301");	
	
    Statement stmt = conn.createStatement();
   
    java.util.Map mapOraObjType = conn.getTypeMap();
 	
    //Le nom du type abstrait Oracle doit être précédé du nom de son propriétaire
    // Voilà le mapping objet relationnel.
    mapOraObjType.put((Object)"MOPOLO2B2223.TABLEAU_T", (Object)Class.forName("galerie.Tableau" ));
    mapOraObjType.put((Object)"MOPOLO2B2223.ARTISTE_T", (Object)Class.forName("galerie.Artiste" ));
//
    String sqlTableau = "SELECT value(ot) FROM o_tableau ot";
 
    ResultSet resultsetTableau = stmt.executeQuery(sqlTableau);

	//maintenant que j'ai récupérer des personnes je voudrais les affihcer  
    System.out.println("***************************INFOS TABLEAUX***************************************");
    while(resultsetTableau.next()){
	//Récupération et affichage d’un tableau
	//System.out.println(resultsetEmp.getObject(1)); 
	Tableau tablo = (Tableau)resultsetTableau.getObject(1, mapOraObjType); //,map);
        tablo.display();
    }
    
    // accès aux objets Dept
    String sqlArt = "SELECT value(oa) FROM o_artiste oa";
 
    ResultSet resultsetArt = stmt.executeQuery(sqlArt);

    System.out.println("***************************INFOS ARTISTES***************************************");
 
  //maintenant que j'ai récupérer des départements je voudrais les affihcer  
    while(resultsetArt.next()){
	//Récupération et affichage d’un artiste
	//System.out.println(resultsetDept.getObject(1)); 
	Artiste art = (Artiste)resultsetArt.getObject(1, mapOraObjType); //,map);
	art.display();
   }

}
catch(ClassNotFoundException | SQLException | IOException e){
	System.out.println("Echec du mapping");
	e.printStackTrace();
}

}

}
