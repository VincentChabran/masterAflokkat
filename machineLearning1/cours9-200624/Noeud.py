


class Noeud:
    def __init__(self, etiquette, valeur_attribut):
        self.etiquette = etiquette
        self.valeur_attribut = valeur_attribut
        self.noeuds_enfants = []

    def ajouter_enfant(self, enfant):
        self.noeuds_enfants.append(enfant)

    def __repr__(self):
        return f"Noeud(etiquette={self.etiquette}, valeur_attribut={self.valeur_attribut}, noeuds_enfants={len(self.noeuds_enfants)})"

