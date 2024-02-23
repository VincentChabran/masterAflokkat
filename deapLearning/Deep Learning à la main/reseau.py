
import numpy as np
import random

class Reseau(object):

    def __init__(self, tailles):
        self.nb_couches = len(tailles)
        self.tailles = tailles
        self.biais = [np.random.uniform(0, 1, (el, 1)) for el in tailles[1:]]
        # self.poids = [np.random.uniform(0, 1, (tailles[i], tailles[i+1])) for i in range(self.nb_couches - 1)]
        self.poids = [np.random.uniform(0, 1, (x, y)) for x, y in zip(tailles[:-1], tailles[1:])]  

        

    def forward(self, x):
        for i in range(1, self.nb_couches):
            sortie = []
            for j in range(self.tailles[i]):
                sortie_neuronnes = np.dot(x.T, self.poids[i-1][:,j]) 
                sortie.append(sortie_neuronnes)
            x = np.asarray(sortie)
           
        # for c in range(1, self.nb_couches):
        #     sortie = []
        #     for n in range(self.tailles[c]):
        #         sortie_neurone = np.dot(x.T, self.poids[c-1][:,n])
        #         sortie.append(sortie_neurone)
        #     x = np.asarray(sortie)

        # return x
            
    
    # def forward(self, x):
    #     for c in range(1, self.nb_couches):
    #         sortie = []
    #         for n in range(self.tailles[c]):
    #             sortie_neurone = np.dot(x.T, self.poids[c - 1][:, n]) + self.biais[c - 1][n]
    #             sortie.append(sortie_neurone)
    #         x = np.asarray(sortie)
    #     return x
        


    def DGS(self, training_data, nb_epoques, taille_mini_batch, eta, test_data=None):
        if test_data is not None: n_test = len(test_data)
        n = len(training_data)
        for j in range(nb_epoques):
            random.shuffle(training_data)
            mini_batches = [
                training_data[k:k+taille_mini_batch]
                for k in range(0, n, taille_mini_batch)]
            for mini_batch in mini_batches:
                self.update_mini_batch(mini_batch, eta)
            if test_data is not None:
                print(f"Époque {j}: {self.evaluer(test_data)} / {n_test}")
            else:
                print(f"Époque {j} complete")


    def update_mini_batch(self, mini_batch, eta):
        nabla_b = [np.zeros(b.shape) for b in self.biais]
        nabla_w = [np.zeros(w.shape) for w in self.poids]
        for x, y in mini_batch:
            delta_nabla_b, delta_nabla_w = self.backprop(x, y)
            nabla_b = [nb+dnb for nb, dnb in zip(nabla_b, delta_nabla_b)]
            nabla_w = [nw+dnw for nw, dnw in zip(nabla_w, delta_nabla_w)]
        self.poids = [w-(eta/len(mini_batch))*nw
                        for w, nw in zip(self.poids, nabla_w)]
        self.biais = [b-(eta/len(mini_batch))*nb
                       for b, nb in zip(self.biais, nabla_b)]


    def backprop(self, x, y):
        nabla_b = [np.zeros(b.shape) for b in self.biais]
        nabla_w = [np.zeros(w.shape) for w in self.poids]

        activation = x
        activations = [x]
        zs = []
        for b, w in zip(self.biais, self.poids):
            z = np.matmul(w.T, activation)+b
            zs.append(z)
            activation = sigmoide(z)
            activations.append(activation)

        delta = self.derivee_cout(activations[-1], y) * \
            sigmoide_prime(zs[-1])
        nabla_b[-1] = delta
        nabla_w[-1] = np.dot(delta, activations[-2].transpose()).T

        for l in range(2, self.nb_couches):
            z = zs[-l]
            sp = sigmoide_prime(z)
            delta = np.matmul(self.poids[-l+1], delta) * sp
            nabla_b[-l] = delta
            nabla_w[-l] = np.dot(delta, activations[-l-1].transpose()).T
        return (nabla_b, nabla_w)


    def evaluer(self, test_data):
        score = 0 
        for x, y in test_data:
            pred = self.forward(x).argmax()
            if y == pred:
                score += 1
        return score
        


    def derivee_cout(self, activations_sortie, y):
        return (activations_sortie-y)


def sigmoide(z):
    return 1.0 / (1.0 + np.exp(-z))


def sigmoide_prime(z):
    return sigmoide(z)*(1-sigmoide(z))