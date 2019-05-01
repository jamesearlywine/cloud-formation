#!/bin/bash
apt-get install -y jq

DNS_DOMAIN='earlywine.info'
DNS_JENKINS_SUBDOMAIN='jenkins'
DNS_NAME="${DNS_JENKINS_SUBDOMAIN}.${DNS_DOMAIN}"
PUBLIC_IP_ADDRESS=$(curl checkip.amazonaws.com)
CLOUDFLARE_API_KEY=$(aws s3 cp s3://jle-config/cloudflare/apikey -)
CLOUDFLARE_API_EMAIL=$(aws s3 cp s3://jle-config/cloudflare/email -)

DNS_ZONE_ID=`curl -X GET \
  "https://api.cloudflare.com/client/v4/zones?name=${DNS_DOMAIN}" \
  -H "Content-Type:application/json" \
  -H "X-Auth-Key: ${CLOUDFLARE_API_KEY}" \
  -H "X-Auth-Email: ${CLOUDFLARE_API_EMAIL}" \
  | jq --raw-output .result[0].id \
`

# debugging
# echo "DNS_DOMAIN: ${DNS_DOMAIN}"
# echo "DNS_JENKINS_SUBDOMAIN: ${DNS_JENKINS_SUBDOMAIN}"
# echo "DNS_ZONE_ID: ${DNS_ZONE_ID}"
# echo "DNS_NAME: ${DNS_NAME}"

if [ -z $DNS_ZONE_ID ] || [ "$DNS_ZONE_ID" == "null" ];
then
  echo "No DNS_ZONE_ID found for Domain: ${DNS_DOMAIN}"
  exit
else
  DNS_RECORD_ID=$(curl -X GET \
    "https://api.cloudflare.com/client/v4/zones/${DNS_ZONE_ID}/dns_records?name=${DNS_NAME}" \
    -H "Content-Type:application/json" \
    -H "X-Auth-Key: ${CLOUDFLARE_API_KEY}" \
    -H "X-Auth-Email: ${CLOUDFLARE_API_EMAIL}" \
    | jq --raw-output .result[0].id
  )
fi

DNS_UPDATE_REQUEST="{ \
  \"type\": \"A\", \
  \"name\": \"${DNS_NAME}\", \
  \"content\": \"${PUBLIC_IP_ADDRESS}\", \
  \"ttl\": 120, \
  \"proxied\": false \
}"


if [ -z $DNS_ZONE_ID ] || [ "$DNS_ZONE_ID" == "null" ];
then
DNS_UPDATE_RESPONSE=$(curl -X POST \
  "https://api.cloudflare.com/client/v4/zones/${DNS_ZONE_ID}/dns_records/${DNS_RECORD_ID}" \
  -H "Content-Type:application/json" \
  -H "X-Auth-Key: ${CLOUDFLARE_API_KEY}" \
  -H "X-Auth-Email: ${CLOUDFLARE_API_EMAIL}" \
  --data "${DNS_UPDATE_REQUEST}" \
  | jq .
)

else
DNS_UPDATE_RESPONSE=$(curl -X PUT \
  "https://api.cloudflare.com/client/v4/zones/${DNS_ZONE_ID}/dns_records/${DNS_RECORD_ID}" \
  -H "Content-Type:application/json" \
  -H "X-Auth-Key: ${CLOUDFLARE_API_KEY}" \
  -H "X-Auth-Email: ${CLOUDFLARE_API_EMAIL}" \
  --data "${DNS_UPDATE_REQUEST}" \
  | jq .
)
fi

DNS_UPDATE_SUCCESS=$(echo "${DNS_UPDATE_RESPONSE}" | jq --raw-output .success)

if [ "${DNS_UPDATE_SUCCESS}" == "true" ];
then
  echo "DNS Entry updated for ${DNS_NAME} .. A Record now indicates ip address ${PUBLIC_IP_ADDRESS}."

  # debugging
  # echo "DNS_UPDATE_REQUEST: ${DNS_UPDATE_REQUEST}"
  # echo "DNS_UPDATE_RESPONSE: ${DNS_UPDATE_RESPONSE}"
else
echo "DNS Entry NOT updated."
  echo "DNS_UPDATE_REQUEST: ${DNS_UPDATE_REQUEST}"
  echo "DNS_UPDATE_RESPONSE: ${DNS_UPDATE_RESPONSE}"
fi
