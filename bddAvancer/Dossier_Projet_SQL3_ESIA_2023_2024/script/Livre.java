package script;

import oracle.jdbc.OracleTypes;
import oracle.sql.REF;
import oracle.sql.STRUCT;
import java.math.BigDecimal;
import java.sql.*;
import static oracle.jdbc.OracleTypes.CURSOR;

public class Livre {
    private String idLivre;
    private int idBibliotheque;
    private String titre;
    private String auteur;
    private String genre;

    public Livre(String idLivre, int idBibliotheque, String titre, String auteur, String genre) {
        this.idLivre = idLivre;
        this.idBibliotheque = idBibliotheque;
        this.titre = titre;
        this.auteur = auteur;
        this.genre = genre;
    }

    public String getIdLivre() {
        return idLivre;
    }

    public int getIdBibliotheque() {
        return idBibliotheque;
    }

    public String getTitre() {
        return titre;
    }

    public String getAuteur() {
        return auteur;
    }

    public String getGenre() {
        return genre;
    }

    public void setIdLivre(String idLivre) {
        this.idLivre = idLivre;
    }

    public void setIdBibliotheque(int idBibliotheque) {
        this.idBibliotheque = idBibliotheque;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public void setAuteur(String auteur) {
        this.auteur = auteur;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public static Livre createLivre(String id, int idBibliotheque, String titre, String auteur, String genre, Connection conn) throws SQLException {
        String sql = "{? = call t_livre.create_livre(?, ?, ?, ?, ?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, OracleTypes.STRUCT, "T_LIVRE");
            cstmt.setString(2, id);
            cstmt.setInt(3, idBibliotheque);
            cstmt.setString(4, titre);
            cstmt.setString(5, auteur);
            cstmt.setString(6, genre);
            cstmt.execute();

            STRUCT livreStruct = (STRUCT) cstmt.getObject(1);
            Object[] attributs = livreStruct.getAttributes();
            return new Livre(id, idBibliotheque, titre, auteur, genre);
        }
    }

    public static Livre getLivreById(String id, Connection conn) throws SQLException {
        String sql = "SELECT id_livre, bibliotheque_ref, titre, auteur, genre FROM livres WHERE id_livre = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String idLivre = rs.getString("id_livre");
                    String titre = rs.getString("titre");
                    String auteur = rs.getString("auteur");
                    String genre = rs.getString("genre");

                    REF bibliothequeRef = (REF) rs.getObject("bibliotheque_ref");
                    STRUCT bibliothequeStruct = (STRUCT) bibliothequeRef.getValue();
                    Object[] attributsBibliotheque = bibliothequeStruct.getAttributes();

                    int idBibliotheque = ((BigDecimal) attributsBibliotheque[0]).intValue();
                    return new Livre(idLivre, idBibliotheque, titre, auteur, genre);
                }
            }
        }
        return null;
    }


    public void updateLivre(String newTitre, String newAuteur, String newGenre, Connection conn) throws SQLException {
        String sql = "{call update_livre_wrapper(?, ?, ?, ?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setString(1, this.idLivre);
            cstmt.setString(2, newTitre);
            cstmt.setString(3, newAuteur);
            cstmt.setString(4, newGenre);
            cstmt.execute();

            this.titre = newTitre;
            this.auteur = newAuteur;
            this.genre = newGenre;
        }
    }

    public static void deleteLivre(String id, Connection conn) throws SQLException {
        String sql = "{call t_livre.delete_livre(?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setString(1, id);
            cstmt.executeUpdate();
        }
    }

    public int countEmprunts(Connection conn) throws SQLException {
        String sql = "{? = call count_emprunts_livre_wrapper(?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, Types.INTEGER);
            cstmt.setString(2, this.idLivre);
            cstmt.execute();
            return cstmt.getInt(1);
        }
    }

    public void listAdherentsEmprunteurs(Connection conn) throws SQLException {
        String sql = "{call list_adherents_emprunteurs_wrapper(?, ?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setString(1, this.idLivre);
            cstmt.registerOutParameter(2, CURSOR);
            cstmt.execute();

            try (ResultSet rs = (ResultSet) cstmt.getObject(2)) {
                while (rs.next()) {
                    String nomAdherent = rs.getString("nom");
                    String prenomAdherent = rs.getString("prenom");
                    System.out.println("Adherent: " + nomAdherent + " " + prenomAdherent);
                }
            }
        }
    }

    public static void listLivresOrdered(Connection conn) throws SQLException {
        String sql = "{? = call t_livre.list_livres_ordered()}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, CURSOR);
            cstmt.execute();

            try (ResultSet rs = (ResultSet) cstmt.getObject(1)) {
                while (rs.next()) {
                    String titreLivre = rs.getString("titre");
                    System.out.println("Livre : " + titreLivre);
                }
            }
        }
    }
}
