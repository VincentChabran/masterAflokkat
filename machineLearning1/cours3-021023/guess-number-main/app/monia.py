from random import randint
import pickle
import numpy as np

svc = 0

def algo(data):
    # guess = randint(0, 9)

    with open("mon modele.pkl", "rb") as f:
        svc = pickle.load(f)
        f.close()

    guess = svc.predict(data)

    print(guess)

    # predicted_number = np.argmax(guess, axis=1)


    return guess

