import numpy
import matplotlib.pyplot as plt

# FOnction carré
x = numpy.linspace(-10, 10 , 6895) # Renvoi une liste de 6985 nombres à virgule entre -10 et 10
y = x ** 2

plt.plot(x, y)
plt.show()
