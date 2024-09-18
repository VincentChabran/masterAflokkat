# Staged build

## Stage 1: build the sources to produce the executable file
FROM golang:1.22-alpine as builder

ARG VERSION

WORKDIR /go/src/backend
COPY . .
RUN GOOS=linux GOARCH=amd64 go build -ldflags "-X main.version=$VERSION -s -w"


## Stage 2: Assemble the final image
FROM scratch

WORKDIR /app
COPY --from=builder /go/src/backend/backend .

EXPOSE 8080

CMD ["./backend"]
