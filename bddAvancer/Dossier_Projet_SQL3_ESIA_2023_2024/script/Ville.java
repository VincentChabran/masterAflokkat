package script;

import oracle.jdbc.OracleTypes;
import java.math.BigDecimal;
import java.sql.*;

public class Ville {
    private int idVille;
    private String nom;

    public Ville(int idVille, String nom) {
        this.idVille = idVille;
        this.nom = nom;
    }

    public int getIdVille() {
        return idVille;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public static Ville createVille(int id, String nom, Connection conn) throws SQLException {
        String sql = "{? = call t_ville.create_ville(?, ?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, OracleTypes.STRUCT, "T_VILLE");
            cstmt.setInt(2, id);
            cstmt.setString(3, nom);
            cstmt.execute();

            Struct villeStruct = (Struct) cstmt.getObject(1);
            Object[] attributs = villeStruct.getAttributes();

            int idVille = ((BigDecimal) attributs[0]).intValue();
            String nomVille = (String) attributs[1];
            return new Ville(idVille, nomVille);
        }
    }

    public void updateVille(String newNom, Connection conn) throws SQLException {
        String sql = "{call update_ville_wrapper(?, ?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, this.idVille);
            cstmt.setString(2, newNom);
            cstmt.execute();

            this.nom = newNom;
        }
    }

    public static void deleteVille(int id, Connection conn) throws SQLException {
        String sql = "{call t_ville.delete_ville(?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, id);
            cstmt.executeUpdate();
        }
    }

    public int countBibliotheques(Connection conn) throws SQLException {
        String sql = "{? = call count_bibliotheques_wrapper(?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, Types.INTEGER);
            cstmt.setInt(2, this.idVille);
            cstmt.execute();
            return cstmt.getInt(1);
        }
    }

    public void listBibliotheques(Connection conn) throws SQLException {
        String sql = "{call list_bibliotheques_wrapper(?, ?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, this.idVille);
            cstmt.registerOutParameter(2, OracleTypes.CURSOR);
            cstmt.execute();

            try (ResultSet rs = (ResultSet) cstmt.getObject(2)) {
                while (rs.next()) {
                    System.out.println("Bibliotheque: " + rs.getString(1));
                }
            }
        }
    }

    public static void listVillesOrdered(Connection conn) throws SQLException {
        String sql = "{? = call t_ville.list_villes_ordered()}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, OracleTypes.CURSOR);
            cstmt.execute();

            try (ResultSet rs = (ResultSet) cstmt.getObject(1)) {
                while (rs.next()) {
                    String nomVille = rs.getString(1);
                    System.out.println("Ville : " + nomVille);
                }
            }
        }
    }
}
