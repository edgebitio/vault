#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Usage: $0 DOMAIN-NAME KMS-KEY-ID" >&2
	exit 1
fi

DOMAIN="$1"
KMS_KEY="$2"

# Generate a self-signed certificate and a private key
openssl req -x509 \
	-newkey rsa:4096 -keyout key.pem \
	-out cert.pem -sha256 -days 365 \
	-subj "/CN=$DOMAIN" -nodes \
	-extensions san \
	-config <( \
	  echo "[req]"; \
	  echo "distinguished_name=req"; \
	  echo "[san]"; \
	  echo "subjectAltName=DNS:localhost,IP:127.0.0.1,DNS:$DOMAIN")

# Make sure to delete the plaintext version of the key
trap "rm key.pem" EXIT

# Encrypt the private key using KMS
aws kms encrypt --key-id "$KMS_KEY" --plaintext "fileb://key.pem" --output text --query CiphertextBlob | base64 -d >key.pem.enc
