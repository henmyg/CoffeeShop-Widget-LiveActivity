# Script to create a jwt token to be used for sending push notifications from postman
# Set your variables
TEAM_ID="TD8D7EFB4K" # Apple TeamID - replace with your own
KEY_ID="D26UCGF2C6" # Keyfile has name AuthKey_{Key_ID} - replace with your own
KEY_FILE="./AuthKey_D26UCGF2C6.p8" #Path to filename - replace with your own

# Generate JWT
JWT_HEADER=$(printf '%s' '{"alg":"ES256","kid":"'$KEY_ID'"}' | openssl base64 -e -A | tr '+/' '-_' | tr -d '=')
JWT_CLAIMS=$(printf '%s' '{"iss":"'$TEAM_ID'","iat":'$(date +%s)'}' | openssl base64 -e -A | tr '+/' '-_' | tr -d '=')
JWT_UNSIGNED="$JWT_HEADER.$JWT_CLAIMS"
JWT_SIGNATURE=$(printf '%s' "$JWT_UNSIGNED" | openssl dgst -binary -sha256 -sign "$KEY_FILE" | openssl base64 -e -A | tr '+/' '-_' | tr -d '=')
TOKEN="$JWT_UNSIGNED.$JWT_SIGNATURE"

echo $TOKEN
