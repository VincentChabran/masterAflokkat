from numpy import exp
import numpy
import matplotlib.pyplot as plt


def sigmoide(z):
   return 1/(1+ exp(-z))


# Represente exp(-z)
# Je veux afficher la courbe de la fonction exponentielle entre -10 et 10 :
# xs = numpy.linspace(-10, 10 , 6895) # Renvoi une liste de 6985 nombres à virgule entre -10 et 10

# ys = exp(-xs)
# plt.plot(xs, ys)
# plt.show()
# ***********************


# Reprensente la fx sigmoide
xs = numpy.linspace(-10, 10 ,6000)
ys = sigmoide(xs)
plt.plot(xs, ys)
plt.show()
