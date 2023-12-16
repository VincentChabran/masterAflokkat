package script;

import oracle.jdbc.OracleTypes;
import oracle.sql.REF;
import oracle.sql.STRUCT;
import java.math.BigDecimal;
import java.sql.*;

public class Bibliotheque {
    private int idBibliotheque;
    private int idVille;
    private String nom;
    private String adresse;

    public Bibliotheque(int idBibliotheque, int idVille, String nom, String adresse) {
        this.idBibliotheque = idBibliotheque;
        this.idVille = idVille;
        this.nom = nom;
        this.adresse = adresse;
    }

    public int getIdBibliotheque() {
        return idBibliotheque;
    }

    public void setIdBibliotheque(int idBibliotheque) {
        this.idBibliotheque = idBibliotheque;
    }

    public int getIdVille() {
        return idVille;
    }

    public void setIdVille(int idVille) {
        this.idVille = idVille;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public static Bibliotheque createBibliotheque(int id, int villeId, String nom, String adresse, Connection conn) throws SQLException {
        String sql = "{? = call t_bibliotheque.create_bibliotheque(?, ?, ?, ?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, OracleTypes.STRUCT, "T_BIBLIOTHEQUE");
            cstmt.setInt(2, id);
            cstmt.setInt(3, villeId);
            cstmt.setString(4, nom);
            cstmt.setString(5, adresse);
            cstmt.execute();

            Struct bibliothequeStruct = (Struct) cstmt.getObject(1);
            Object[] attributs = bibliothequeStruct.getAttributes();

            int idBibliotheque = ((BigDecimal) attributs[0]).intValue();
            // Traiter les autres attributs si nécessaire
            return new Bibliotheque(idBibliotheque, villeId, nom, adresse);
        }
    }

    public static Bibliotheque getBibliothequeById(int id, Connection conn) throws SQLException {
        String sql = "SELECT id_bibliotheque, ville_ref, nom, adresse FROM bibliotheques WHERE id_bibliotheque = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int idBibliotheque = rs.getInt("id_bibliotheque");
                    String nom = rs.getString("nom");
                    String adresse = rs.getString("adresse");

                    REF villeRef = (REF) rs.getObject("ville_ref");
                    STRUCT villeStruct = (STRUCT) villeRef.getValue();
                    Object[] attributsVille = villeStruct.getAttributes();

                    int idVille = ((BigDecimal) attributsVille[0]).intValue();

                    return new Bibliotheque(idBibliotheque, idVille, nom, adresse);
                }
            }
        }
        return null;
    }

    public void updateBibliotheque(String newNom, String newAdresse, Connection conn) throws SQLException {
        String sql = "{call update_bibliotheque_wrapper(?, ?, ?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, this.idBibliotheque);
            cstmt.setString(2, newNom);
            cstmt.setString(3, newAdresse);
            cstmt.execute();
        }
    }

    public static void deleteBibliotheque(int id, Connection conn) throws SQLException {
        String sql = "{call t_bibliotheque.delete_bibliotheque(?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, id);
            cstmt.executeUpdate();
        }
    }

    public int countLivres(Connection conn) throws SQLException {
        String sql = "{? = call count_livres_wrapper(?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, Types.INTEGER);
            cstmt.setInt(2, this.idBibliotheque);
            cstmt.execute();
            return cstmt.getInt(1);
        }
    }

    public void listLivres(Connection conn) throws SQLException {
        String sql = "{call list_livres_wrapper(?, ?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, this.idBibliotheque);
            cstmt.registerOutParameter(2, OracleTypes.CURSOR);
            cstmt.execute();

            try (ResultSet rs = (ResultSet) cstmt.getObject(2)) {
                while (rs.next()) {
                    String titreLivre = rs.getString(1);
                    System.out.println("Livre: " + titreLivre);
                }
            }
        }
    }

    public static void listBibliothequesOrdered(Connection conn) throws SQLException {
        String sql = "{? = call t_bibliotheque.list_bibliotheques_ordered()}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, OracleTypes.CURSOR);
            cstmt.execute();

            try (ResultSet rs = (ResultSet) cstmt.getObject(1)) {
                while (rs.next()) {
                    String nomBibliotheque = rs.getString(1);
                    System.out.println("Bibliotheque: " + nomBibliotheque);
                }
            }
        }
    }







    public static void afficherDetailsBibliotheque(int idBibliotheque, Connection conn) {
        String sql = "SELECT id_bibliotheque, ville_ref, nom, adresse FROM bibliotheques WHERE id_bibliotheque = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, idBibliotheque);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    System.out.println("ID Bibliotheque: " + rs.getInt("id_bibliotheque"));
                    System.out.println("Nom: " + rs.getString("nom"));
                    System.out.println("Adresse: " + rs.getString("adresse"));

                    REF villeRef = (REF) rs.getObject("ville_ref");
                    STRUCT villeStruct = (STRUCT) villeRef.getValue();
                    Object[] attributsVille = villeStruct.getAttributes();

                    System.out.println("Ville ID: " + attributsVille[0]);
                    System.out.println("Ville Nom: " + attributsVille[1]);
                } else {
                    System.out.println("Aucune bibliothèque trouvée avec l'ID " + idBibliotheque);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
