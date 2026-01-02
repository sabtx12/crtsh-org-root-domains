#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 \"Organization Name\""
    echo "Example: $0 \"Example Co.\""
    exit 1
fi

ORG="$1"
ENCODED_ORG=$(printf '%s' "$ORG" | jq -sRr @uri)

echo "[*] Searching for Organization: $ORG"
echo "[*] URL: https://crt.sh/?O=$ENCODED_ORG&output=json"

curl -s --fail "https://crt.sh/?O=$ENCODED_ORG&output=json" > temp_crt.json

if [ ! -s temp_crt.json ] || grep -q "[]" temp_crt.json; then
    echo "[!] No results found or error fetching data."
    rm -f temp_crt.json
    exit 1
fi

# Extract domains from name_value (SANs) and common_name, remove wildcards, clean, filter valid domains
jq -r '.[].name_value // empty, .[].common_name // empty' temp_crt.json \
    | tr ',' '\n' \
    | sed 's/^\*\.//g; s/[[:space:]]//g; s/^www\.//g' \
    | grep -E '^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' \
    | sort -u > all_domains.txt

echo "[+] All domains extracted (all_domains.txt):"
cat all_domains.txt

# Extract root domains (apex domains like example.com or example.co.uk)
awk -F. '{
    n = NF
    if (n >= 2) {
        root = $(n-1) "." $n
        if (n >= 3 && ($(n-2) ~ /^(co|com|net|org|gov|ac|go|ne|info|biz)$/)) {
            root = $(n-2) "." root
        }
        print root
    }
}' all_domains.txt | sort -u > root_domains.txt

echo "[+] Root domains extracted (root_domains.txt):"
cat root_domains.txt

# Cleanup
rm -f temp_crt.json 

echo "[*] Done!"