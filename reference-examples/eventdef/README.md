# Introduction

Reference Examples for interacting with API endpoints for Graylog Event Definitions

# Create Event Definition

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

curl "${GRAYLOG_URI_BASE}/api/events/definitions?schedule=${ENABLE_CREATED_EVENT}" \
  --user "${GRAYLOG_API_TOKEN}:token" \
  -H 'Content-Type: application/json' \
  -H 'X-Requested-By: XMLHttpRequest' \
  -d "@eventdef.json"
```

# Viewing Existing Event Definitions

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

# return Event Definitions
curl "${GRAYLOG_URI_BASE}/api/events/definitions?page=1&per_page=50" \
  --user "${GRAYLOG_API_TOKEN}:token"

# use a query to return a single Event Definition, using its unique `id`
EVENTDEF_ID=6759eaefc9dc050f06b1b3db
curl "${GRAYLOG_URI_BASE}/api/events/definitions?page=1&per_page=50&query=id%3A${EVENTDEF_ID}" \
  --user "${GRAYLOG_API_TOKEN}:token"
```