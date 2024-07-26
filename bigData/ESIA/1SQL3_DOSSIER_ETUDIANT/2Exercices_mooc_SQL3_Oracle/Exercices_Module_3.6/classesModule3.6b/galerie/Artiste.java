/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package galerie;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.*;
import oracle.sql.ARRAY;

/**
 *
 * @author mondi
 */
public class Artiste implements SQLData{
    private String sql_type ;
    private int arid;
    private String arnom;
    private ARRAY arprenoms;
    private Clob arcv; 
    private ARRAY listRefTabs;

    public Artiste (){}

    public Artiste(String sql_type, int arid,String arnom, ARRAY arprenoms, Clob arcv, ARRAY listRefTabs ){ 
		this.sql_type=sql_type;
     		this.arid=arid ;
     		this.arnom=arnom;
      		this.arprenoms=arprenoms ;
                this.arcv=arcv;
               this.listRefTabs=listRefTabs;
    }
    
    /**
     * @return the arid
     */
    public int getArid() {
        return arid;
    }

    /**
     * @param arid the arid to set
     */
    public void setArid(int arid) {
        this.arid = arid;
    }

    /**
     * @return the arnom
     */
    public String getArnom() {
        return arnom;
    }

    /**
     * @param arnom the arnom to set
     */
    public void setArnom(String arnom) {
        this.arnom = arnom;
    }
    
     /**
     * @return the arcv
     */
    public Clob getArcv() {
        return arcv;
    }

    /**
     * @param arcv the arcv to set
     */
    public void setArcv(Clob arcv) {
        this.arcv = arcv;
    }
    
    /**
     * @param arprenoms the job to set
     */
    public void setArprenoms(ARRAY arprenoms) {
        this.arprenoms = arprenoms;
    }

     /**
     * @return the arprenoms
     */
    public ARRAY getArprenoms() {
        return arprenoms;
    }   
    
    /**
     * @return the ListRefEmp
     */
    public ARRAY getListRefTabs() {
        return listRefTabs;
    }

    /**
     * @param listRefTabs the loc to set
     */
    public void setListRefTabs(ARRAY listRefTabs) {
        this.listRefTabs = listRefTabs;
    }
    
    public String getSQLTypeName()throws SQLException{
      		return sql_type;
    }
    
 /**
    Lire dans le flot dans l'ordre.
    
 */
    public void readSQL(SQLInput stream, String typeName) throws SQLException{
       		sql_type=typeName;
       		arid=stream.readInt();
      		arnom=stream.readString();
                arprenoms=(ARRAY) stream.readArray();
       		arcv=stream.readClob();
      		listRefTabs=(ARRAY) stream.readArray();
    }
    
    /*
        Ecrire dans le flot dans l'ordre.
    */
    public void writeSQL(SQLOutput stream) throws SQLException{
                stream.writeInt(arid);
       		stream.writeString(arnom);
                 stream.writeArray(arprenoms);
      		stream.writeClob(arcv);
      		stream.writeArray(listRefTabs);
    }

    public void display() throws SQLException, IOException{
        System.out.println("");
        System.out.println("{");
        System.out.println("arid = "+this.getArid());
	System.out.println("arnom = "+this.getArnom());
        this.displayArprenoms();
        this.displayArcv();
        this.displayInfoTableauxArtiste();
        System.out.println("}");
        System.out.println("");

      
    }
    public void displayInfoTableauxArtiste() throws SQLException, IOException{
       // affichage des prénoms
        Ref [] lesRefDesTableaux= (Ref[])this.getListRefTabs().getArray();
        System.out.println("<Tableaux:");
        for (Ref refTableau : lesRefDesTableaux) {
            Tableau tablo = (Tableau) refTableau.getObject();
            //tablo.display();
            System.out.println("   [taid="+tablo.getTaid()+" tanom="+tablo.getTanom()+"]");
        }
        System.out.println(">");
    }
    
    
      public void displayArcv() throws java.sql.SQLException, java.io.IOException{
            BufferedReader clobReader = new BufferedReader(this.getArcv().getCharacterStream()); 
            String ligne; 
            System.out.println("");
            System.out.println("[ <CV/ "); 
            while((ligne = clobReader.readLine()) != null){ 
                System.out.println("   "+ligne); 
            } 
            System.out.println(" /CV>] ");
            System.out.println("");
      }
      
      public void displayArprenoms() throws SQLException{
       // affichage des prénoms
        String [] lesArprenoms= ( String [])this.getArprenoms().getArray();
       //System.out.println("Arprenoms = "+this.getArprenoms().stringValue());

        for (int i=0; i<lesArprenoms.length;i++){
           System.out.println("Prenoms["+i+"]="+lesArprenoms[i]);
        }
       
      }

}
