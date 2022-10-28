#!/bin/sh

aws kms decrypt --endpoint-url="$AWS_KMS_ENDPOINT" --ciphertext-blob "fileb:///etc/vault/certs/key.pem.enc" --output text --query Plaintext | base64 -d > /etc/vault/certs/key.pem

/usr/local/bin/docker-entrypoint.sh server -log-level=debug
