FROM golang:1.23-alpine AS builder
WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download
RUN go mod verify

COPY . .

RUN go test
RUN go build -o /app/postfix_exporter

FROM golang:1.23-alpine
EXPOSE 9154
WORKDIR /
COPY --from=builder /app/postfix_exporter /app/
ENTRYPOINT ["/app/postfix_exporter"]
