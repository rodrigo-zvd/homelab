FROM alpine:3.19

# Instala dependências mínimas
RUN apk add --no-cache curl ca-certificates

# Instala o gomplate
RUN curl -L https://github.com/hairyhenderson/gomplate/releases/latest/download/gomplate_linux-amd64 \
    -o /usr/local/bin/gomplate && chmod +x /usr/local/bin/gomplate

# Garante que tem shell
ENTRYPOINT ["/bin/sh"]