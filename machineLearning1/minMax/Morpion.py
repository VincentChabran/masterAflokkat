import random
import copy

class Morpion:
    """Un instance de la classe Morpion représente un état du jeu,
    c'est-à-dire l'ensemble des croix et des ronds ainsi que
    le joueur dont c'est le tour."""

    def __init__(self, position=None, joueur_actif="X"):
        self.position = position if position is not None else [[" " for _ in range(3)] for _ in range(3)]
        self.joueur_actif = joueur_actif

    def coups_possibles(self):
        """Renvoie la liste des coups possibles dans la position."""
        possibles = []
        for i in range(3):
            for j in range(3):
                if self.position[i][j] == " ":
                    possibles.append((i, j))
        return possibles

    def jouer_coup(self, coup):
        """Renvoie une nouvelle instance de Morpion, qui représente l'état
        du jeu après que `coup` ait été joue."""
        nouvelle_position = copy.deepcopy(self.position)
        i, j = coup
        nouvelle_position[i][j] = self.joueur_actif
        prochain_joueur = "O" if self.joueur_actif == "X" else "X"
        return Morpion(nouvelle_position, prochain_joueur)

    def fini(self):
        """Renvoie :
        - 1 si le joueur X a gagné
        - -1 si le joueur O a gagné
        - 0 en cas de match nul
        - None si la partie n'est pas encore terminée
        """
        # Vérification des lignes, colonnes et diagonales pour une victoire
        for i in range(3):
            if self.position[i][0] == self.position[i][1] == self.position[i][2] != " ":
                return 1 if self.position[i][0] == "X" else -1
            if self.position[0][i] == self.position[1][i] == self.position[2][i] != " ":
                return 1 if self.position[0][i] == "X" else -1

        if self.position[0][0] == self.position[1][1] == self.position[2][2] != " ":
            return 1 if self.position[0][0] == "X" else -1
        if self.position[0][2] == self.position[1][1] == self.position[2][0] != " ":
            return 1 if self.position[0][2] == "X" else -1

        # Vérification pour un match nul
        if all(self.position[i][j] != " " for i in range(3) for j in range(3)):
            return 0

        # La partie n'est pas terminée
        return None


def afficher_plateau(jeu: Morpion):
    """Affiche le plateau de jeu"""
    for ligne in jeu.position:
        print(ligne)


def demander_coup(jeu: Morpion):
    coup = None
    coups_possibles = jeu.coups_possibles()
    while coup not in coups_possibles:
        try:
            i = int(input("Entrez la ligne (0, 1, 2) : "))
            j = int(input("Entrez la colonne (0, 1, 2) : "))
            coup = (i, j)
            if coup not in coups_possibles:
                print("Coup invalide, essayez encore.")
        except ValueError:
            print("Entrée invalide, essayez encore.")
    return coup


def jouer_contre_ordi():
    jeu = Morpion()
    joueur_humain = "X"
    
    while jeu.fini() is None:
        afficher_plateau(jeu)
        if jeu.joueur_actif == joueur_humain:
            print("C'est votre tour !")
            coup = demander_coup(jeu)
        else:
            print("Tour de l'ordinateur...")
            coup = random.choice(jeu.coups_possibles())
        
        jeu = jeu.jouer_coup(coup)
    
    afficher_plateau(jeu)
    resultat = jeu.fini()
    if resultat == 1:
        print("Le joueur X a gagné !")
    elif resultat == -1:
        print("Le joueur O a gagné !")
    else:
        print("Match nul !")

# Lancer le jeu
jouer_contre_ordi()
