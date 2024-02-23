import skimage as ski
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import random


nb_images = 25000

def process_image(image, size=50, pad_mode="constant"):
    image_gris = ski.color.rgb2gray(image)

    idx_to_pad = 1 if image_gris.shape[0] > image_gris.shape[1] else 0
    other_idx = 1 - idx_to_pad

    short_dim = image_gris.shape[idx_to_pad]
    large_dim = image_gris.shape[other_idx]

    total_pad_size = (large_dim - short_dim)

    pad_size_1 = total_pad_size//2
    pad_size_2 = total_pad_size//2

    if total_pad_size % 2 != 0:
        pad_size_2 += 1

    pad_width = [[0,0], [0,0]]
    pad_width[idx_to_pad] = [pad_size_1, pad_size_2]

    padded_image = np.pad(image_gris, pad_width, mode=pad_mode)

    resized_image = ski.transform.resize(padded_image, (size, size))

    return resized_image


def img_name(is_cat,n, ext=".jpg"):
    kind = "cat" if is_cat else "dog"
    return kind+"."+str(n)+ext

def load_image(is_cat, n):
    return ski.io.imread("train/" + img_name(is_cat, n))

def load_and_process_image(is_cat, n):
    im = load_image(is_cat, n)
    return process_image(im)

processed_dirname = "train_processed/"

def load_processed_dataset():
    x = []
    y = []
    for is_cat in [True, False]:
        for i in range(nb_images//2):
            im = ski.io.imread(processed_dirname+img_name(is_cat, i, ext=".tiff"))
            x.append(im)
            y.append(0 if is_cat else 1)
    
    return x, y

if __name__ == "__main__":  
    for is_cat in [True, False]:
        for i in range(nb_images//2):
            print(i)
            im = load_and_process_image(is_cat, i)
            ski.io.imsave(processed_dirname+img_name(is_cat, i, ext=".tiff"), im)

# imgs = []
# matplotlib.use('QtAgg') # Delete me
# nb_test = 16
# for _ in range(nb_test):
#     cat_or_dog = random.choice(["cat", "dog"])
#     n = random.randrange(1, 11000)

#     path = "train/"+cat_or_dog+"."+str(n)+".jpg"
#     im = ski.io.imread(path)
#     imgs.append(process_image(im))

# _, axs = plt.subplots(4, 4, figsize=(12, 12))
# axs = axs.flatten()
# for img, ax in zip(imgs, axs):
#     ax.imshow(img, cmap="gray")
# plt.show()