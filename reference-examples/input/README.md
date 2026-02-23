# Introduction

Reference Examples for interacting with API endpoints for Graylog Inputs.

This information has been tested and verified for:
- Graylog 6.3
- Graylog 7.0

# Create Input

```sh
# BASE URI for Graylog Cluster
#   e.g.
#       http://hostname.domain.tld:9000
#       https://hostname.domain.tld
GRAYLOG_URI_BASE=https://hostname.domain.tld
# trim tailing slash, we cannot have it
GRAYLOG_URI_BASE=$(echo $GRAYLOG_URI_BASE | sed 's/\/$//')

# API Token
# leave the sapce so that bash history does not save this
 GRAYLOG_API_TOKEN=

curl "${GRAYLOG_URI_BASE}/api/system/inputs" \
  --user "${GRAYLOG_API_TOKEN}:token" \
  -H 'Content-Type: application/json' \
  -H 'X-Requested-By: XMLHttpRequest' \
  -d "@input.json"
```

# Viewing Existing Inputs

This is very useful if you need or want to copy an existing event definition schema.

```sh
# BASE URI for Graylog Cluster
#   e.g.
#       http://hostname.domain.tld:9000
#       https://hostname.domain.tld
GRAYLOG_URI_BASE=https://hostname.domain.tld
# trim tailing slash, we cannot have it
GRAYLOG_URI_BASE=$(echo $GRAYLOG_URI_BASE | sed 's/\/$//')

# API Token
# leave the sapce so that bash history does not save this
 GRAYLOG_API_TOKEN=

# return All Inputs
curl "${GRAYLOG_URI_BASE}/api/system/inputs" \
  --user "${GRAYLOG_API_TOKEN}:token"

# use a query to return a single Input, using its unique `id`
INPUT_ID=699c975062899cd783248eea
curl "${GRAYLOG_URI_BASE}/api/system/inputs/${INPUT_ID}" \
  --user "${GRAYLOG_API_TOKEN}:token"
```

# Update Existing Input

```sh
# BASE URI for Graylog Cluster
#   e.g.
#       http://hostname.domain.tld:9000
#       https://hostname.domain.tld
GRAYLOG_URI_BASE=https://hostname.domain.tld
# trim tailing slash, we cannot have it
GRAYLOG_URI_BASE=$(echo $GRAYLOG_URI_BASE | sed 's/\/$//')

# API Token
# leave the sapce so that bash history does not save this
 GRAYLOG_API_TOKEN=

# use a query to return a single Input, using its unique `id`
INPUT_ID=699c97b362899cd7832491bd
curl "${GRAYLOG_URI_BASE}/api/system/inputs/${INPUT_ID}" \
  --user "${GRAYLOG_API_TOKEN}:token" \
  --request PUT \
  -H 'Content-Type: application/json' \
  --header 'X-Requested-By: XMLHttpRequest' \
  -d "@input.json"
```

# Delete Input by Id

```sh
# BASE URI for Graylog Cluster
#   e.g.
#       http://hostname.domain.tld:9000
#       https://hostname.domain.tld
GRAYLOG_URI_BASE=https://hostname.domain.tld
# trim tailing slash, we cannot have it
GRAYLOG_URI_BASE=$(echo $GRAYLOG_URI_BASE | sed 's/\/$//')

# API Token
# leave the sapce so that bash history does not save this
 GRAYLOG_API_TOKEN=

# use a query to return a single Input, using its unique `id`
INPUT_ID=699c975062899cd783248eea
curl "${GRAYLOG_URI_BASE}/api/system/inputs/${INPUT_ID}" \
  --user "${GRAYLOG_API_TOKEN}:token" \
  --request DELETE \
  --header 'X-Requested-By: XMLHttpRequest'
```