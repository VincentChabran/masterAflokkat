# Introduction

Cats demo REST API used to manage a local database of 🐈.

## Run locally

```bash
go run .
```

Then you can browse:

-  the home page: http://localhost:8080
-  the Swagger UI : http://localhost:8080/swagger/
-  the logs : http://localhost:8080/logs

# Dev

## Compiling

The go CLI supports `go build` to produce an exacutable and will guide you through compilation errors.

## Docker

A Dockerfile needs to be created at the repository root.
You can derive from `scratch`, then `COPY` the sources into the image and build them.
The main command of the image should simply execute the executable obtained after building.

A more advanced solution can be achieved with a staged build.

Build command:

```bash
docker build -t my-image-name .
```

Listing the images:

```bash
docker images
```

Running a container:

```bash
docker run -it <imageID>
```

Play also with:

```bash
inspect ps stop rm rmi
```

## Unit Testing

Test files have to be postfixed with `_test.go` for the command `go test .` to play them.

## API Testing

Test files have to be postfixed with `_test.go` for the command `go test ./test/apitests` to play them.

Also you will need to run the server at the same time in another tab.

# Swagger UI setup (already done)

Done following [Swagger official doc](https://github.com/swagger-api/swagger-ui/blob/master/docs/usage/installation.md#plain-old-htmlcssjs-standalone).

## Regenerate the OpenApi file

The Swagger UI consumes only JSON api specification, the function `yml2json` has been made to convert the YML format into JSON.

<!-- Ajout -->
<!--  -->
<!--  -->
<!--  -->
<!--  -->

# Pour Dockeriser

Faire un Dockerfile

```bash
docker build -t mon-application-go .
```

Ou avec un ARG

```bash
docker build --build-arg VERSION=1.0.1 -t mon-application-go .
docker build --build-arg VERSION=1.0.1 .
```

Pour run

```bash
docker run -p 8080:8080 mon-application-go
||
docker run -it alpine:latest /bin/sh
```

Si le dépôt Git est sous l'organisation `estia-bihar`, vous devez remplacer `your-github-username` par le nom de l'organisation (`estia-bihar`) dans les commandes de tagging et de push.

### 1. Créer un token GitHub avec les droits de push

1. Connectez-vous à votre compte GitHub.
2. Allez dans **Settings** > **Developer settings** > **Personal access tokens** > **Tokens (classic)**.
3. Cliquez sur **Generate new token**.
4. Donnez un nom à votre token, définissez une date d'expiration si nécessaire.
5. Cochez les permissions **write:packages**, **read:packages**, et **delete:packages**.
6. Cliquez sur **Generate token** et copiez le token généré.

### 2. Se connecter au GitHub Container Registry

Utilisez le token pour vous connecter au registre GHCR.

```sh
echo YOUR_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

Remplacez `YOUR_TOKEN` par le token que vous avez généré et `YOUR_GITHUB_USERNAME` par votre nom d'utilisateur GitHub.

### 3. Taguer votre image Docker avec le nom de l'organisation et du dépôt

Supposons que votre dépôt GitHub sous l'organisation `estia-bihar` s'appelle `mon-repo` :

```sh
docker tag mon-application-go ghcr.io/estia-bihar/mon-repo/mon-application-go:latest
```

### 4. Pousser l'image vers le registre GitHub lié au dépôt

Poussez l'image taguée vers GHCR :

```sh
docker push ghcr.io/estia-bihar/mon-repo/mon-application-go:latest
```

## Exemple complet :

1. **Créer un token et se connecter :**

```sh
echo your-token | docker login ghcr.io -u your-github-username --password-stdin
```

2. **Taguer l'image Docker :**

```sh
docker tag mon-application-go ghcr.io/estia-bihar/mon-repo/mon-application-go:latest
```

3. **Pousser l'image vers GHCR :**

```sh
docker push ghcr.io/estia-bihar/mon-repo/mon-application-go:latest
```

### Vérification :

1. **Vérifier sur GitHub :**

   -  Accédez à votre dépôt GitHub `mon-repo` sous l'organisation `estia-bihar`.
   -  Cliquez sur l'onglet **Packages** pour voir votre image Docker.

2. **Vérifier localement :**
   -  Utilisez la commande `docker images` pour vérifier que votre image est bien taguée localement.
   -  Utilisez la commande `docker pull ghcr.io/estia-bihar/mon-repo/mon-application-go:latest` pour tirer l'image du registre et vérifier qu'elle est accessible.

En suivant ces étapes, votre image Docker sera associée spécifiquement au dépôt de code source sous l'organisation `estia-bihar` sur GitHub.
