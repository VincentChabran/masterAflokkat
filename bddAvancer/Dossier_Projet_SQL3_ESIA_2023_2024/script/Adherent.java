package script;

import oracle.jdbc.OracleTypes;
import oracle.sql.REF;
import oracle.sql.STRUCT;

import java.math.BigDecimal;
import java.sql.*;

public class Adherent {
    private int idAdherent;
    private int idBibliotheque;
    private String nom;
    private String prenom;

    public Adherent(int idAdherent, int idBibliotheque, String nom, String prenom) {
        this.idAdherent = idAdherent;
        this.idBibliotheque = idBibliotheque;
        this.nom = nom;
        this.prenom = prenom;
    }

    public int getIdAdherent() {
        return idAdherent;
    }

    public int getIdBibliotheque() {
        return idBibliotheque;
    }

    public String getNom() {
        return nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setIdAdherent(int idAdherent) {
        this.idAdherent = idAdherent;
    }

    public void setIdBibliotheque(int idBibliotheque) {
        this.idBibliotheque = idBibliotheque;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }


    public static Adherent createAdherent(int id, int idBibliotheque, String nom, String prenom, Connection conn) throws SQLException {
        String sql = "{? = call t_adherent.create_adherent(?, ?, ?, ?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, OracleTypes.STRUCT, "T_ADHERENT");
            cstmt.setInt(2, id);
            cstmt.setInt(3, idBibliotheque);
            cstmt.setString(4, nom);
            cstmt.setString(5, prenom);
            cstmt.execute();

            return new Adherent(id, idBibliotheque, nom, prenom);
        }
    }

    public static Adherent getAdherentById(int id, Connection conn) throws SQLException {
        String sql = "SELECT id_adherent, bibliotheque_ref, nom, prenom FROM adherents WHERE id_adherent = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int idAdherent = rs.getInt("id_adherent");
                    String nom = rs.getString("nom");
                    String prenom = rs.getString("prenom");

                    REF bibliothequeRef = (REF) rs.getObject("bibliotheque_ref");
                    STRUCT bibliothequeStruct = (STRUCT) bibliothequeRef.getValue();
                    Object[] attributsBibliotheque = bibliothequeStruct.getAttributes();

                    int idBibliotheque = ((BigDecimal) attributsBibliotheque[0]).intValue();

                    return new Adherent(idAdherent, idBibliotheque, nom, prenom);
                }
            }
        }
        return null;
    }


    public void updateAdherent(String newNom, String newPrenom, Connection conn) throws SQLException {
        String sql = "{call update_adherent_wrapper(?, ?, ?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, this.idAdherent);
            cstmt.setString(2, newNom);
            cstmt.setString(3, newPrenom);
            cstmt.execute();

            this.nom = newNom;
            this.prenom = newPrenom;
        }
    }

    public static void deleteAdherent(int id, Connection conn) throws SQLException {
        String sql = "{call t_adherent.delete_adherent(?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, id);
            cstmt.executeUpdate();
        }
    }

    public int countEmprunts(Connection conn) throws SQLException {
        String sql = "{? = call count_emprunts_adherent_wrapper(?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, Types.INTEGER);
            cstmt.setInt(2, this.idAdherent);
            cstmt.execute();
            return cstmt.getInt(1);
        }
    }

    public void listLivresEmpruntes(Connection conn) throws SQLException {
        String sql = "{call list_livres_empruntes_wrapper(?, ?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, this.idAdherent);
            cstmt.registerOutParameter(2, OracleTypes.CURSOR);
            cstmt.execute();

            try (ResultSet rs = (ResultSet) cstmt.getObject(2)) {
                while (rs.next()) {
                    String titreLivre = rs.getString(1);
                    System.out.println("Livre emprunté: " + titreLivre);
                }
            }
        }
    }

    public static void listAdherentsOrdered(Connection conn) throws SQLException {
        String sql = "{? = call t_adherent.list_adherents_ordered()}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, OracleTypes.CURSOR);
            cstmt.execute();

            try (ResultSet rs = (ResultSet) cstmt.getObject(1)) {
                while (rs.next()) {
                    String nomAdherent = rs.getString(1);
                    System.out.println("Adhérent : " + nomAdherent);
                }
            }
        }
    }
}
