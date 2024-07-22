FROM hashicorp/vault:latest

RUN apk update && apk add aws-cli

COPY config.hcl /vault/config/

RUN mkdir -p /etc/vault/certs/
COPY cert.pem /etc/vault/certs/
COPY key.pem.enc /etc/vault/certs/

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ARG AWS_DEFAULT_REGION
ENV AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION

ARG AWS_KEY_ID
ENV VAULT_AWSKMS_SEAL_KEY_ID=$AWS_KEY_ID

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
