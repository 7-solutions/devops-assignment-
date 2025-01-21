FROM golang:1.23.5-alpine3.21 AS builder

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /app

COPY go.mod ./
RUN go mod tidy

COPY . .

RUN go build -o main .

FROM alpine:3.21.2

RUN apk --no-cache add ca-certificates=20241121-r1 \
    && addgroup -S appgroup \
    && adduser -S appuser -G appgroup

WORKDIR /home/appuser/

COPY --from=builder /app/main .

RUN chown -R appuser:appgroup /home/appuser

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl --fail http://localhost:8080/ || exit 1

CMD ["./main"]
