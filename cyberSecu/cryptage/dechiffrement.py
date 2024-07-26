# protocole de chiffrement

def vigenere (text, key) :
   alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
   splitKey = list(key)
   splitText = list(text)

   fullIndexKey =''
   indexKey = []
   result= ''
   
   for i in range (len(text)):
      fullIndexKey += str(i%len(key))
      #print (fullIndexKey)


   for index in fullIndexKey :
      splitKey = list(key)
      indexKe = splitKey[int(index)]
      indexKey.append(alphabet.index(indexKe))
      #print(indexKey)

   for i in range(len(splitText)) :
      indexAlph = alphabet.index(splitText[i])
      preresult= (indexKey[i]+ indexAlph)%26
      #print(preresult)
      result += alphabet[preresult]
      
      
   return result, key    

def protocoleDeCryptage (text, key) :

   alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
   keyTwo = 0

   #Chiffrement de César
   resultStepOne = cesar(text,key)
   #print (resultStepOne)

   #Chiffrement de Vigenère

   #Salage de la clé
   keyOne = f"{alphabet[resultStepOne[1]]}{text}"
   #print(keyOne)

   resultStepTwo = vigenere(resultStepOne[0], keyOne)
   #print (resultStepTwo)
   keyTwoList = list( resultStepTwo[1])
   #print(keyTwoList)
   for letter in keyTwoList : 
      keyTwo += alphabet.index(letter)
   #print(keyTwo)

   #déchiffrement de César
   resultStepThree = deCesar(resultStepTwo[0],keyTwo)
   #print(resultStepThree)

   #Chiffrement de Vigenère
   keyThree =alphabet[(resultStepThree[1])%26]
   #print(keyThree)
   #salage du texte
   textThree = f'{resultStepThree[0]}{resultStepTwo[0]}'

   resultStepFour = vigenere(textThree, keyThree)
   #print(resultStepFour)

   #Chiffrement de Vigenère

   #Salage de la clé
   keyFour = f"{resultStepFour[1]}{resultStepFour[0]}"
   #print(keyFour)
   resultStepFive = vigenere(resultStepFour[0], keyFour)

   return resultStepFive


protocoleDeCryptage ( 'aflokkat', 3)  