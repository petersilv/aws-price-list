key_name="emlyknj-xv03933-tableau"

openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 des3 -inform PEM -out "$key_name.p8"
openssl rsa -in "$key_name.p8" -pubout -out "$key_name.pub"