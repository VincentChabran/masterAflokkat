def encryption_transposition(message, key):
   # Remove spaces from the message
   message = message.replace(" ", "")
   
   # Create an empty list to store the columns
   columns = [''] * key

   print(columns)
   
   # Loop through each character in the message
   for i in range(len(message)):
      # Find the column to place the character
      column = i % key
      columns[column] += message[i]
   
   # Join the columns to get the encrypted message
   encrypted_message = ''.join(columns)
   return encrypted_message

def decryption_transposition(encrypted_message, key):
   # Calculate the number of rows
   num_rows = len(encrypted_message) // key
   if len(encrypted_message) % key != 0:
      num_rows += 1
   
   # Create an empty list to store the rows
   rows = [''] * num_rows
   
   # Calculate the number of columns in the last row
   last_column_length = len(encrypted_message) % key
   
   # Loop through each character in the encrypted message
   index = 0
   for col in range(key):
      for row in range(num_rows):
         # Check if the character exists in the encrypted message
         if row == num_rows - 1 and col >= last_column_length and last_column_length != 0:
               continue
         rows[row] += encrypted_message[index]
         index += 1
   
   # Join the rows to get the decrypted message
   decrypted_message = ''.join(rows)
   return decrypted_message

# Exemple d'utilisation
message = "Hello World"
message = "Hel loW orl d"
key = 4

encrypted = encryption_transposition(message, key)
print("Message chiffré:", encrypted)

# decrypted = decryption_transposition(encrypted, key)
# print("Message déchiffré:", decrypted)
