# Create Self-Signed Certificates
All PAYLAY applications require an SSL certificate.

To get started, you can easily generate Self-Signed Certificates using OpenSSL for the sole purpose of **local software development**.

## Generate a self-signed certificate
Generate a new self-signed certificate

#### macOS
~~~ bash
openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
    -subj "/CN=localhost" \
    -extensions SAN \
    -config <(cat /etc/ssl/openssl.cnf \
            <(printf "[SAN]\nsubjectAltName='DNS:localhost,IP:127.0.0.1'")) \
    -keyout paylaydev.key -out paylaydev.crt
~~~

#### Windows
~~~ shell
openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes ^
-keyout paylaydev.key -out paylaydev.crt -subj /CN=localhost ^
-addext subjectAltName=DNS:localhost,IP:127.0.0.1
~~~

## PKCS#12
All PAYLAY applications require certificates in PKCS#12 format, so we need to run another command to convert it to PKCS#12:

#### macOS, Windows
~~~ shell
openssl pkcs12 -inkey paylaydev.key -in paylaydev.crt -export -out paylaydev.p12
~~~