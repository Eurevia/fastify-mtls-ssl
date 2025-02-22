#!/bin/bash


# Organisation for CA Cert
MY_ORG="Eurevia"

# Hostname of the Server
SERVER_NAME="localhost"
SERVER_ALT_NAME="DNS:regate.local,DNS:localhost,IP:127.0.0.1,IP:192.168.200.1"

# Hostname or the Client
CLIENT_NAME="clienthost"

# 100 ans
EXPIRATION_DELAY_DAYS=36500

CERTIFICATES_DIR=./certificates
CERTIFICATES_CA_DIR=$CERTIFICATES_DIR/ca
CERTIFICATES_SERVER_DIR=$CERTIFICATES_DIR/server
CERTIFICATES_CLIENT_DIR=$CERTIFICATES_DIR/client

rm -Rf $CERTIFICATES_DIR
mkdir -p $CERTIFICATES_DIR
mkdir -p $CERTIFICATES_CA_DIR
mkdir -p $CERTIFICATES_SERVER_DIR
mkdir -p $CERTIFICATES_CLIENT_DIR


rm $CERTIFICATES_DIR/*

# generate CA certificate
openssl req \
  -new \
  -x509 \
  -nodes \
  -days $EXPIRATION_DELAY_DAYS \
  -subj "/CN=${MY_ORG}" \
  -keyout $CERTIFICATES_CA_DIR/eureviaCAKey.pem \
  -out $CERTIFICATES_CA_DIR/eureviaCACert.pem
  
# generate server key
openssl genrsa \
  -out $CERTIFICATES_SERVER_DIR/eureviaServKey.pem 2048

# generate server.csr
openssl req \
  -new \
  -key $CERTIFICATES_SERVER_DIR/eureviaServKey.pem \
  -subj "/CN=${SERVER_NAME}" \
  -out $CERTIFICATES_SERVER_DIR/server.csr

# generate server.crt (in PEM format)
openssl x509 \
  -req \
  -in $CERTIFICATES_SERVER_DIR/server.csr \
  -CA $CERTIFICATES_CA_DIR/eureviaCACert.pem \
  -CAkey $CERTIFICATES_CA_DIR/eureviaCAKey.pem \
  -extfile <(printf "subjectAltName=${SERVER_ALT_NAME}")  \
  -CAcreateserial \
  -days $EXPIRATION_DELAY_DAYS \
  -out $CERTIFICATES_SERVER_DIR/eureviaServCert.pem



# generate client key (in pem format)

openssl genrsa \
  -out $CERTIFICATES_CLIENT_DIR/eureviaClientKey.pem 2048

# generate a client csr file
openssl req \
  -new \
  -key $CERTIFICATES_CLIENT_DIR/eureviaClientKey.pem \
  -subj "/CN=${CLIENT_NAME}" \
  -out $CERTIFICATES_CLIENT_DIR/client.csr

# generate a client crt file (pem format)

openssl x509 \
  -req \
  -in $CERTIFICATES_CLIENT_DIR/client.csr \
  -CA $CERTIFICATES_CA_DIR/eureviaCACert.pem \
  -CAkey $CERTIFICATES_CA_DIR/eureviaCAKey.pem \
  -CAcreateserial \
  -days 365 \
  -out $CERTIFICATES_CLIENT_DIR/eureviaClientCert.pem




echo "======== Check Server PEM =========="

openssl x509  -text  -in $CERTIFICATES_SERVER_DIR/eureviaServCert.pem
