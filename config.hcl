listener "tcp" {
	address = "0.0.0.0:8200"
	tls_cert_file = "/etc/vault/certs/cert.pem"
	tls_key_file = "/etc/vault/certs/key.pem"
}

storage "consul" {
	address = "host:8500"
	scheme = "http"
	path = "vault/"
}

seal "awskms" {
}
