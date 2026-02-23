# Introduction

Reference Examples for interacting with API endpoints for Graylog Index Sets.

This information has been tested and verified for:
- Graylog 6.3
- Graylog 7.0

# Create Index Set

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

curl "${GRAYLOG_URI_BASE}/api/system/indices/index_sets" \
  --user "${GRAYLOG_API_TOKEN}:token" \
  -H 'Content-Type: application/json' \
  -H 'X-Requested-By: XMLHttpRequest' \
  -d "@index-set.json"
```

# Viewing Existing Index Sets

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

# return All Index Sets
curl "${GRAYLOG_URI_BASE}/api/system/indices/index_sets" \
  --user "${GRAYLOG_API_TOKEN}:token"

# use a query to return a single Input, using its unique `id`
INDEXSET_ID=699c99e962899cd78324a079
curl "${GRAYLOG_URI_BASE}/api/system/indices/index_sets/${INDEXSET_ID}" \
  --user "${GRAYLOG_API_TOKEN}:token"
```
# Update an Existing Index Set

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
INDEXSET_ID=699c99e962899cd78324a079
curl "${GRAYLOG_URI_BASE}/api/system/indices/index_sets/${INDEXSET_ID}" \
  --user "${GRAYLOG_API_TOKEN}:token" \
  --request PUT \
  -H 'Content-Type: application/json' \
  --header 'X-Requested-By: XMLHttpRequest' \
  -d "@index-set-update.json"
```

# Delete Index Set

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

INDEXSET_ID=699c99e962899cd78324a079
curl "${GRAYLOG_URI_BASE}/api/system/indices/index_sets/${INDEXSET_ID}" \
  --user "${GRAYLOG_API_TOKEN}:token" \
  --request DELETE \
  --header 'X-Requested-By: XMLHttpRequest'
```