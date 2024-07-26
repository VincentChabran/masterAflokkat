
# Étape de construction
FROM golang:latest AS builder
WORKDIR /app
COPY . .
RUN go mod download
ARG VERSION=1
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main -ldflags "-X main.version=${VERSION}" .

# Étape finale
FROM scratch
# FROM alpine:latest
# RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .
EXPOSE 8080
CMD ["./main"]








# # Utilisez une image de base appropriée pour votre projet
# FROM golang:latest

# # Définissez le répertoire de travail dans le conteneur
# WORKDIR /app

# # Copiez les fichiers de votre projet dans le conteneur
# COPY . /app

# # Installez les dépendances de votre projet
# RUN go mod download

# # Exposez le port sur lequel votre application écoute
# EXPOSE 8080

# # Démarrez votre application
# CMD ["go", "run", "main.go"]