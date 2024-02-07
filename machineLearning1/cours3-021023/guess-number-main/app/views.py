from django.shortcuts import render
from django.http import JsonResponse
from random import randint
from .monia import algo
import base64
from PIL import Image
import io
import numpy as np
import skimage 


def home(request):
    context = {}
    return render(request, "index.html", context)


def guess(request):
    raw_data = request.POST.get("canvas")

    # data_as_array = [int(x) for x in raw_data.split(",")[3::4]]   

    image_data = base64.b64decode(raw_data.split(',')[1])
    image = Image.open(io.BytesIO(image_data))

  

    # Convertir l'image en niveaux de gris et la redimensionner
    image = image.convert('L')
    image = image.resize((28, 28), Image.Resampling.LANCZOS)

    # Sauvegardez l'image à ce stade pour vérifier à quoi elle ressemble
    image.save('canvas_grayscale.png')


    # Convertir l'image en tableau NumPy et normaliser
    image_array = np.asarray(image)

    image_array = image_array.astype('float32') / 255.0
    # Supposons que image_array est votre image de taille (28, 28) en niveaux de gris
    image_array = image_array.reshape(1, -1)  # Cela crée un tableau 2D avec une seule ligne

    image_array_255 = image_array * 255
    # Ensuite, convertissez en uint8
    image_array_uint8 = image_array_255.astype(np.uint8)
    # Maintenant, vous pouvez sauvegarder l'image sans rencontrer l'erreur
    skimage.io.imsave('canvas.png', image_array_uint8.reshape(28,28))


    guess = algo(image_array) # Là où ils appellent leur fonction d'IA
    
    return render(request, "partials/guess.html", { "guess": guess })