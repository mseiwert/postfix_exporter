FROM golang:1.23 AS builder
WORKDIR /src

# avoid downloading the dependencies on succesive builds
RUN apt-get update -qq && apt-get install -qqy \
  build-essential \
  libsystemd-dev

COPY go.mod go.sum ./
RUN go mod download
RUN go mod verify

COPY . .

RUN go test
RUN go build -o /bin/postfix_exporter

FROM golang:1.23-alpine
EXPOSE 9154
WORKDIR /
COPY --from=builder /bin/postfix_exporter /bin/
ENTRYPOINT ["/bin/postfix_exporter"]
