#!/bin/bash
set -xe
home_ca="home-ca"
rm -rf $home_ca
mkdir -p $home_ca/private $home_ca/crts $home_ca/csrs
chmod 700 $home_ca/private

# Root CA Generation
openssl req -nodes \
    -newkey rsa:4096 \
    -keyout $home_ca/private/root-ca.key \
    -out $home_ca/csrs/root-ca.csr \
    -sha256 \
    -batch \
    -subj "/CN=Root CA"

openssl x509 -req \
    -in $home_ca/csrs/root-ca.csr \
    -out $home_ca/crts/root-ca.crt \
    -signkey $home_ca/private/root-ca.key \
    -sha256 \
    -days 4383 \
    -CAcreateserial \
    -extensions root_ca_ext \
    -extfile build-ca.conf

# Subordinate CA Generation
openssl req -nodes \
    -newkey rsa:2048 \
    -keyout $home_ca/private/sub-ca.key \
    -out $home_ca/csrs/sub-ca.csr \
    -sha256 \
    -batch \
    -subj "/CN=Sub CA"

openssl x509 -req \
    -in $home_ca/csrs/sub-ca.csr \
    -out $home_ca/crts/sub-ca.crt \
    -CA $home_ca/crts/root-ca.crt \
    -CAkey $home_ca/private/root-ca.key \
    -sha256 \
    -days 4383 \
    -CAcreateserial \
    -extensions sub_ca_ext \
    -extfile build-ca.conf

# ZGJ0315 CA Generation
openssl req -nodes \
    -newkey rsa:2048 \
    -keyout $home_ca/private/zgj0315-ca.key \
    -out $home_ca/csrs/zgj0315-ca.csr \
    -sha256 \
    -batch \
    -subj "/CN=ZGJ0315 CA"

openssl x509 -req \
    -in $home_ca/csrs/zgj0315-ca.csr \
    -out $home_ca/crts/zgj0315-ca.crt \
    -CA $home_ca/crts/sub-ca.crt \
    -CAkey $home_ca/private/sub-ca.key \
    -sha256 \
    -days 4383 \
    -CAcreateserial \
    -extensions dj_ca_ext \
    -extfile build-ca.conf
