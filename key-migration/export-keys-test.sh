#!/bin/bash

# SPDX-FileCopyrightText: 2017 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0

if ! cd "$1"; then
    echo "USAGE: $0 PATH"
    exit 1
fi

for item in \
    "bluetooth:bluetooth" \
    "cyngn:cyngn-priv-app" \
    "media:media" \
    "network:networkstack" \
    "nfc:nfc" \
    "platform:platform" \
    "test:testkey" \
    "sdk:sdk_sandbox" \
    "shared:shared" \
    "verifiedboot:verifiedboot"
do
    prefix="${item%%:*}"
    filename="${item#*:}"

    if [ "$prefix" = "test" ]; then
        echo ${prefix}_cert=\"$(openssl x509 -outform der -in $filename.x509.pem | xxd -p  | tr -d '\n')\"
        echo ${prefix}_key=\"$(openssl x509 -pubkey -noout -in $filename.x509.pem | grep -v '-' | tr -d '\n')\"
    elif [[ "$prefix" =~ ^(cyngn|verifiedboot)$ ]]; then
        echo \# ${prefix}_cert_test=\"\"\(UNUSED\)
        echo \# ${prefix}_key_test=\"\" \(UNUSED\)
    else
        echo ${prefix}_cert_test=\"$(openssl x509 -outform der -in $filename.x509.pem | xxd -p  | tr -d '\n')\"
        echo ${prefix}_key_test=\"$(openssl x509 -pubkey -noout -in $filename.x509.pem | grep -v '-' | tr -d '\n')\"
    fi 
done