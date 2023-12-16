package script;

import java.sql.*;


public class GestionBibliotheque {

    public static void main(String[] args) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Villes
            //testCUDVilles(conn);
            //testVilleFunctions(conn);

            // Bibliothéques
            //testCreateUpdateDeleteBibliotheque(conn);
            //testListerEtCompterBibliotheque(conn);

            // Livres
            //testCreateUpdateDeleteLivre(conn);
            //testListerEtCompterEmpruntsLivre(conn);

            // Adherent
            //testCreateUpdateDeleteAdherent(conn);
            //testListerEtCompterEmpruntsAdherent(conn);

            // Emprunt
            //testCreateUpdateDeleteEmprunt(conn);
            //testEmpruntFunctions(conn);



        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private static void testCUDVilles(Connection conn) throws SQLException {
        Ville nouvelleVille = Ville.createVille(1017, "Monstre", conn);
        System.out.println("Ville créée : " + nouvelleVille.getNom());

        nouvelleVille.updateVille("Ville Update", conn);
        System.out.println("Nom de la ville mis à jour : " + nouvelleVille.getNom());

        Ville.deleteVille(nouvelleVille.getIdVille(), conn);
        System.out.println("Ville supprimée.");
    }

    private static void testVilleFunctions(Connection conn) throws SQLException {
        int idVille = 1001;

        Ville ville = new Ville(idVille, "NomVille");
        int nbBibliotheques = ville.countBibliotheques(conn);
        System.out.println("Nombre de bibliothèques pour la ville " + idVille + " : " + nbBibliotheques);

        System.out.println("Liste des bibliothèques pour la ville " + idVille + " :");
        ville.listBibliotheques(conn);

        System.out.println("Liste de toutes les villes ordonnées :");
        Ville.listVillesOrdered(conn);
    }

    public static void afficherVillesClassiquement(Connection conn) {
        String sql = "SELECT * FROM villes";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                int idVille = rs.getInt("id_ville");
                String nom = rs.getString("nom");
                System.out.println("ID: " + idVille + ", Nom: " + nom);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static Ville createVilleWithClassicSqlRequest(int id, String nom, Connection conn) throws SQLException {
        String sql = "INSERT INTO villes (id_ville, nom) VALUES (?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.setString(2, nom);
            pstmt.executeUpdate();
        }
        return new Ville(id, nom);
    }

    public static void testCreateUpdateDeleteBibliotheque(Connection conn) {
        try {
            Bibliotheque nouvelleBibliotheque = Bibliotheque.createBibliotheque(2024, 1001, "Ma Nouvelle Bibliotheque", "123 Rue de la Culture", conn);
            System.out.println("Bibliotheque créée : " + nouvelleBibliotheque.getNom());

            nouvelleBibliotheque.updateBibliotheque("Bibliotheque Modifiée", "456 Avenue du Savoir", conn);
            System.out.println("Bibliotheque mise à jour.");

            Bibliotheque.deleteBibliotheque(nouvelleBibliotheque.getIdBibliotheque(), conn);
            System.out.println("Bibliotheque supprimée.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void testListerEtCompterBibliotheque(Connection conn) {
        try {
            int idBibliothequeExistante = 2001; 

            Bibliotheque bibliothequeExistante = Bibliotheque.getBibliothequeById(idBibliothequeExistante, conn);
            if (bibliothequeExistante == null) {
                System.out.println("Bibliotheque non trouvée.");
                return;
            }

            int nombreLivres = bibliothequeExistante.countLivres(conn);
            System.out.println("Nombre de livres dans la bibliotheque " + bibliothequeExistante.getNom() + " : " + nombreLivres);

            bibliothequeExistante.listLivres(conn);
            Bibliotheque.listBibliothequesOrdered(conn);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void testCreateUpdateDeleteLivre(Connection conn) {
        try {
            Livre nouveauLivre = Livre.createLivre("L124", 2001, "Nouveau Livre 3", "Nouvel Auteur", "Nouveau Genre", conn);
            System.out.println("Livre créé : " + nouveauLivre.getTitre());

            nouveauLivre.updateLivre("Titre Modifié", "Auteur Modifié", "Genre Modifié", conn);
            System.out.println("Livre mis à jour.");

           Livre.deleteLivre(nouveauLivre.getIdLivre(), conn);
            System.out.println("Livre supprimé.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void testListerEtCompterEmpruntsLivre(Connection conn) {
        try {
            String idLivreExistant = "L001";

            Livre livreExistant = Livre.getLivreById(idLivreExistant, conn);
            if (livreExistant == null) {
                System.out.println("Livre non trouvé.");
                return;
            }
            int nombreEmprunts = livreExistant.countEmprunts(conn);
            System.out.println("Nombre d'emprunts pour le livre " + livreExistant.getTitre() + " : " + nombreEmprunts);

            livreExistant.listAdherentsEmprunteurs(conn);
            Livre.listLivresOrdered(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void testCreateUpdateDeleteAdherent(Connection conn) {
        try {
            Adherent nouvelAdherent = Adherent.createAdherent(3024, 2001, "Nouvel Adherent", "Prénom", conn);
            System.out.println("Adhérent créé : " + nouvelAdherent.getNom());

           nouvelAdherent.updateAdherent("Nom Modifié", "Prénom Modifié", conn);
            System.out.println("Adhérent mis à jour.");

           Adherent.deleteAdherent(nouvelAdherent.getIdAdherent(), conn);
            System.out.println("Adhérent supprimé.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void testListerEtCompterEmpruntsAdherent(Connection conn) {
        try {
            int idAdherentExistant = 3001;

            Adherent adherentExistant = Adherent.getAdherentById(idAdherentExistant, conn);
            if (adherentExistant == null) {
                System.out.println("Adhérent non trouvé.");
                return;
            }

            int nombreEmprunts = adherentExistant.countEmprunts(conn);
            System.out.println("Nombre d'emprunts pour l'adhérent " + adherentExistant.getNom() + " : " + nombreEmprunts);
            adherentExistant.listLivresEmpruntes(conn);
            Adherent.listAdherentsOrdered(conn);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void testCreateUpdateDeleteEmprunt(Connection conn) {
        try {
            Emprunt nouvelEmprunt = Emprunt.createEmprunt(4024, "L002", 3001, new Date(System.currentTimeMillis()), new Date(System.currentTimeMillis() + 86400000), conn);
            System.out.println("Emprunt créé.");

            nouvelEmprunt.updateEmprunt(new Date(System.currentTimeMillis()), new Date(System.currentTimeMillis() + 2 * 86400000), conn);
            System.out.println("Emprunt mis à jour.");

            Emprunt.deleteEmprunt(nouvelEmprunt.getIdEmprunt(), conn);
            System.out.println("Emprunt supprimé.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void testEmpruntFunctions(Connection conn) {
        try {
            int idEmpruntExistant = 4001;

            Emprunt empruntExistant = Emprunt.getEmpruntById(idEmpruntExistant, conn);
            if (empruntExistant == null) {
                System.out.println("Emprunt non trouvé.");
                return;
            }

            boolean isOverdue = empruntExistant.isOverdue(conn);
            System.out.println("L'emprunt est-il en retard ? " + isOverdue);

            int durationDays = empruntExistant.durationDays(conn);
            System.out.println("Durée de l'emprunt en jours : " + durationDays);

            System.out.println("Liste des emprunts ordonnés par date d'emprunt :");
            Emprunt.listEmpruntsOrdered(conn);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


}
