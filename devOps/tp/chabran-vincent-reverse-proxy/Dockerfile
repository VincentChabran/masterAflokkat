
# Étape de construction
FROM golang:latest AS builder
WORKDIR /app
COPY . .
RUN go mod download
ARG VERSION=1
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main -ldflags "-X main.version=${VERSION}" .


FROM scratch
WORKDIR /root/
COPY --from=builder /app/main .
EXPOSE 4443
CMD ["./main"]


