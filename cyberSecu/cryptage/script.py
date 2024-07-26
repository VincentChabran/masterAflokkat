from collections import Counter
import random
import math

# César
def cesar_chiffrement(texte, cle):
   texte_chiffre = ""
   for char in texte:
      if char.isalpha():
         shift = cle % 26
         if char.islower():
               texte_chiffre += chr((ord(char) - ord('a') + shift) % 26 + ord('a'))
         elif char.isupper():
               texte_chiffre += chr((ord(char) - ord('A') + shift) % 26 + ord('A'))
      else:
         texte_chiffre += char
   return texte_chiffre

def cesar_dechiffrement(texte, cle):
   return cesar_chiffrement(texte, -cle)



def cesar_decrypt_without_key(texte):
   results = []
   for key in range(26):
      decrypted_text = cesar_dechiffrement(texte, key)
      results.append((key, decrypted_text))
   return results




# Vigenère

# Chiffrement et déchiffrement de Vigenère
def vigenere_chiffrement(texte, cle):
   texte_chiffre = ""
   cle_repeated = (cle * (len(texte) // len(cle) + 1))[:len(texte)]
   for i, char in enumerate(texte):
      if char.isalpha():
         shift = ord(cle_repeated[i].lower()) - ord('a')
         if char.islower():
               texte_chiffre += chr((ord(char) - ord('a') + shift) % 26 + ord('a'))
         elif char.isupper():
               texte_chiffre += chr((ord(char) - ord('A') + shift) % 26 + ord('A'))
      else:
         texte_chiffre += char
   return texte_chiffre


def vigenere_dechiffrement(texte, cle):
   texte_dechiffre = ""
   cle_repeated = (cle * (len(texte) // len(cle) + 1))[:len(texte)]
   for i, char in enumerate(texte):
      if char.isalpha():
         shift = ord(cle_repeated[i].lower()) - ord('a')
         if char.islower():
               texte_dechiffre += chr((ord(char) - ord('a') - shift + 26) % 26 + ord('a'))
         elif char.isupper():
               texte_dechiffre += chr((ord(char) - ord('A') - shift + 26) % 26 + ord('A'))
      else:
         texte_dechiffre += char
   return texte_dechiffre








# Fonction qui chiffre un texte avec César puis Vigenère
def chiffre_cesar_vigenere(texte, cle_cesar, cle_vigenere):
   texte_cesar = cesar_chiffrement(texte, cle_cesar)
   
   texte_vigenere = vigenere_chiffrement(texte_cesar, cle_vigenere)
   return texte_vigenere









# Fonction pour ajouter des chiffres en fonction d'un mot
def ajouter_chiffres_en_fonction_du_mot(texte, mot):
   chiffres = "".join(str(ord(char)) for char in mot)
   milieu = len(texte) // 2
   texte_modifie = texte[:milieu -1] + chiffres[math.floor(len(chiffres) / 2):] + texte[milieu:] + chiffres[:math.floor(len(chiffres) / 2)] 
   # texte_modifie = texte[:milieu -1] + texte[milieu - 1: milieu].upper() + chiffres[math.floor(len(chiffres) / 2):] + chiffre_cesar_vigenere(texte[math.floor(len(texte)/2):], len(texte), cesar_chiffrement(texte, math.floor(len(texte)/2)+10))[1:math.floor(len(texte) /2)].upper() + chiffre_cesar_vigenere("NarUtOS", len(texte), "r" + mot[:1] + "a") + texte[milieu:] + chiffres[:math.floor(len(chiffres) / 2)] + chiffre_cesar_vigenere("Ram" + texte[:2] + "nDO", len(texte), "Dragon")
   return texte_modifie



def chiffre_dechiffre_complexe(texte, cle_cesar_1, cle_vigenere_1, cle_cesar_2, cle_vigenere_2):
   # 1. Chiffrement avec César (cle_cesar_1)
   texte = cesar_chiffrement(texte, cle_cesar_1)
   # 2. Déchiffrement avec Vigenère (cle_vigenere_1)
   texte = vigenere_dechiffrement(texte, cle_vigenere_1)
   # 3. Déchiffrement avec César (cle_cesar_2)
   texte = cesar_dechiffrement(texte, cle_cesar_2)
   # 4. Chiffrement avec Vigenère (cle_vigenere_2)
   texte = vigenere_chiffrement(texte, cle_vigenere_2)
   return texte 


# Fonction inverse qui déchiffre un texte avec un ordre complexe de Vigenère et César
def dechiffre_chiffre_complexe(texte, cle_vigenere_2, cle_cesar_2, cle_vigenere_1, cle_cesar_1):
   # 1. Déchiffrement avec Vigenère (cle_vigenere_2)
   texte = vigenere_dechiffrement(texte, cle_vigenere_2)
   # 2. Chiffrement avec César (cle_cesar_2)
   texte = cesar_chiffrement(texte, cle_cesar_2)
   # 3. Chiffrement avec Vigenère (cle_vigenere_1)
   texte = vigenere_chiffrement(texte, cle_vigenere_1)
   # 4. Déchiffrement avec César (cle_cesar_1)
   # for _ in range(2):
   texte = cesar_dechiffrement(texte, cle_cesar_1)
   return texte



def generer_mot_de_passe(mot):
   if len(mot) > 10:
      return f"Mot de passe trop long {mot}"

   # Modifier le mot pour mettre des majuscules toutes les 2 lettres
   mot_modifie = ""
   for i, char in enumerate(mot):
      if i % 2 == 0:
         mot_modifie += char.upper()
      else:
         mot_modifie += char.lower()

   # Obtenir la valeur ASCII de la première lettre
   premiere_lettre_ascii = str(ord(mot[0]))

   mot_de_passe = ""
   ascii_index = 0

   for char in mot_modifie:
      mot_de_passe += char
      if char.isupper() and ascii_index < len(premiere_lettre_ascii) and len(mot) + len(mot_de_passe) - 1 <= 10:
         mot_de_passe += premiere_lettre_ascii[ascii_index]
         ascii_index += 1

   if(len(mot_de_passe) < 8):
      while len(mot_de_passe) < 8:
         mot_de_passe += str(random.randint(0, 9))

   return mot_de_passe


def restaurer_mot(mot_transforme):
   mot_restauré = ""
   i = 0
   while i < len(mot_transforme):
      char = mot_transforme[i]
      if char.isalpha():
         mot_restauré += char
         i += 1
      else:
         i += 1
   return mot_restauré.lower()




if __name__ == "__main__":
   texte_clair = "hello"
   # texte_clair = "vincent"
   # texte_clair = "bonjour"
   # texte_clair = "securiter"
   cle_cesar_1 = 20
   cle_vigenere_1 = "cle"
   cle_cesar_2 = 7
   cle_vigenere_2 = "crypto"


   if(len(texte_clair) > 10):
      print("Texte trop long")
      exit()


   print("Texte en clair" ,texte_clair)
   # # Chiffrement complexe
   texte_chiffre = chiffre_dechiffre_complexe(texte_clair, cle_cesar_1, cle_vigenere_1, cle_cesar_2, cle_vigenere_2)
   print(f"{texte_chiffre}")


   mot_de_passe = generer_mot_de_passe(texte_chiffre)
   print(mot_de_passe)

   mot_chiffrer_restaurer = restaurer_mot(mot_de_passe)
   # print(mot_chiffrer_restaurer)

   texte_dechiffre = dechiffre_chiffre_complexe(mot_chiffrer_restaurer, cle_vigenere_2, cle_cesar_2, cle_vigenere_1, cle_cesar_1)
   print(texte_dechiffre)



