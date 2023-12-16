package script;

import oracle.jdbc.OracleTypes;
import oracle.sql.REF;
import oracle.sql.STRUCT;
import java.math.BigDecimal;
import java.sql.*;

public class Emprunt {
    private int idEmprunt;
    private String idLivre;
    private int idAdherent;
    private Date dateEmprunt;
    private Date dateRetour;

    public Emprunt(int idEmprunt, String idLivre, int idAdherent, Date dateEmprunt, Date dateRetour) {
        this.idEmprunt = idEmprunt;
        this.idLivre = idLivre;
        this.idAdherent = idAdherent;
        this.dateEmprunt = dateEmprunt;
        this.dateRetour = dateRetour;
    }

    public int getIdEmprunt() {
        return idEmprunt;
    }

    public String getIdLivre() {
        return idLivre;
    }

    public int getIdAdherent() {
        return idAdherent;
    }

    public Date getDateEmprunt() {
        return dateEmprunt;
    }

    public Date getDateRetour() {
        return dateRetour;
    }

    public static Emprunt createEmprunt(int id, String livreId, int adherentId, Date dateEmprunt, Date dateRetour, Connection conn) throws SQLException {
        String sql = "{? = call t_emprunt.create_emprunt(?, ?, ?, ?, ?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, OracleTypes.STRUCT, "T_EMPRUNT");
            cstmt.setInt(2, id);
            cstmt.setString(3, livreId);
            cstmt.setInt(4, adherentId);
            cstmt.setDate(5, dateEmprunt);
            cstmt.setDate(6, dateRetour);
            cstmt.execute();

            Struct empruntStruct = (Struct) cstmt.getObject(1);
            Object[] attributs = empruntStruct.getAttributes();

            int idEmprunt = ((BigDecimal) attributs[0]).intValue();
            return new Emprunt(idEmprunt, livreId, adherentId, dateEmprunt, dateRetour);
        }
    }

    public static Emprunt getEmpruntById(int id, Connection conn) throws SQLException {
        String sql = "SELECT id_emprunt, livre_ref, adherent_ref, date_emprunt, date_retour FROM emprunts WHERE id_emprunt = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int idEmprunt = rs.getInt("id_emprunt");
                    Date dateEmprunt = rs.getDate("date_emprunt");
                    Date dateRetour = rs.getDate("date_retour");

                    REF livreRef = (REF) rs.getObject("livre_ref");
                    STRUCT livreStruct = (STRUCT) livreRef.getValue();
                    Object[] attributsLivre = livreStruct.getAttributes();
                    String idLivre = (String) attributsLivre[0];

                    REF adherentRef = (REF) rs.getObject("adherent_ref");
                    STRUCT adherentStruct = (STRUCT) adherentRef.getValue();
                    Object[] attributsAdherent = adherentStruct.getAttributes();
                    int idAdherent = ((BigDecimal) attributsAdherent[0]).intValue();

                    return new Emprunt(idEmprunt, idLivre, idAdherent, dateEmprunt, dateRetour);
                }
            }
        }
        return null;
    }

    public void updateEmprunt(Date newDateEmprunt, Date newDateRetour, Connection conn) throws SQLException {
        String sql = "{call update_emprunt_wrapper(?, ?, ?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, this.idEmprunt);
            cstmt.setDate(2, newDateEmprunt);
            cstmt.setDate(3, newDateRetour);
            cstmt.execute();
        }
    }

    public static void deleteEmprunt(int id, Connection conn) throws SQLException {
        String sql = "{call t_emprunt.delete_emprunt(?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, id);
            cstmt.executeUpdate();
        }
    }

    public boolean isOverdue(Connection conn) throws SQLException {
        String sql = "{? = call is_overdue_wrapper(?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, Types.BOOLEAN);
            cstmt.setInt(2, this.idEmprunt);
            cstmt.execute();
            return cstmt.getBoolean(1);
        }
    }

    public int durationDays(Connection conn) throws SQLException {
        String sql = "{? = call duration_days_wrapper(?)}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, Types.INTEGER);
            cstmt.setInt(2, this.idEmprunt);
            cstmt.execute();
            return cstmt.getInt(1);
        }
    }

    public static void listEmpruntsOrdered(Connection conn) throws SQLException {
        String sql = "{? = call t_emprunt.list_emprunts_ordered()}";
        try (CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, OracleTypes.CURSOR);
            cstmt.execute();

            try (ResultSet rs = (ResultSet) cstmt.getObject(1)) {
                while (rs.next()) {
                    Date dateEmprunt = rs.getDate("date_emprunt");
                    System.out.println("Date d'emprunt : " + dateEmprunt);
                }
            }
        }
    }
}
