import mnist_loader

training_data, validation_data, test_data = mnist_loader.load_data_wrapper()

import reseau

res = reseau.Reseau([784, 30, 10])
res.DGS(training_data, 30, 10, 3.0, test_data=test_data)


import reseau 
import numpy as np
res = reseau.Reseau([784, 30, 10])
# res = reseau.Reseau([5, 3, 2])

# print(res.biais)
# print(res.poids)
# print(res.poids[0])
# print(res.poids[0][:,0])

res.forward(np.ones((784, 1)))
