/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package galerie;

//import static com.oracle.jrockit.jfr.DataType.ARRAY;
import java.sql.*;
import oracle.sql.ARRAY;
import oracle.sql.REF;
import java.io.BufferedReader;

/**
 *
 * @author mondi
 */

public class Tableau implements SQLData{
     	private String sql_type ;
  	private int taid;
	private String tanom;
        private Date tadateAchat;   
        private Ref refArtiste;
        
        

     	public Tableau (){}
        
        
 	public Tableau(String sql_type,int taid,String tanom, Date tadateAchat, REF refArtiste ){ 
		this.sql_type=sql_type;
     		this.taid=taid ;
      		this.tanom=tanom;
     		this.tadateAchat=tadateAchat;
                this.refArtiste=refArtiste;
	}
       
             @Override
        public String getSQLTypeName()throws SQLException{
      		return getSql_type();
	}
        /**
            Lire dans le flot dans l'ordre.
        */
             @Override
	public void readSQL(SQLInput stream, String typeName) throws SQLException{
       		setSql_type(typeName);
       		taid=stream.readInt();
        	tanom=stream.readString();
       		tadateAchat=stream.readDate();
                setRefArtiste((Ref) stream.readRef());
                
 	}
        /**
            Ecrire dans le flot dans l'ordre.
        */
             @Override
	public void writeSQL(SQLOutput stream) throws SQLException{
       		stream.writeInt(taid);
        	stream.writeString(tanom);
      		stream.writeDate(tadateAchat);
                stream.writeRef(getRefArtiste());
	}

    /**
     * @return the taid
     */
    public int getTaid() {
        return taid;
    }

    /**
     * @param taid the taid to set
     */
    public void setTaid(int taid) {
        this.taid = taid;
    }

    /**
     * @return the tanom
     */
    public String getTanom() {
        return tanom;
    }

    /**
     * @param tanom the tanom to set
     */
    public void setTanom(String tanom) {
        this.tanom = tanom;
    }

    /**
     * @return the tadateAchat
     */
    public Date getTadateAchat() {
        return tadateAchat;
    }

    /**
     * @param tadateAchat the tadateAchat to set
     */
    public void setTadateAchat(Date tadateAchat) {
        this.tadateAchat = tadateAchat;
    }

      /**
     * @return the refArtiste
     */
    public Ref getRefArtiste() {
        return refArtiste;
    }

    /**
     * @param refArtiste the refArtiste to set
     */
    public void setRefArtiste(Ref refArtiste) {
        this.refArtiste = refArtiste;
    }

    /**
     * @return the sql_type
     */
    public String getSql_type() {
        return sql_type;
    }

    /**
     * @param sql_type the sql_type to set
     */
    public void setSql_type(String sql_type) {
        this.sql_type = sql_type;
    }
    
    
      public void display() throws SQLException, java.io.IOException{
  
        System.out.println("");
        System.out.println("{");
        System.out.println("taid = "+this.getTaid());
	System.out.println("tanom = "+this.getTanom());       
        System.out.println("tadateAchat = "+this.getTadateAchat());
        this.displayInfoEmpDeptFromRef();
        System.out.println("}");
        System.out.println("");

      }

      
     public void displayInfoEmpDeptFromRef() throws SQLException{
  
        Ref refArtiste1 = this.getRefArtiste(); 
        Artiste art1 = (Artiste) refArtiste1.getObject();
        System.out.println("Nom du peintre = "+art1.getArnom());
      }

}
