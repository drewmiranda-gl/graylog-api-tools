# Introduction

Reference Examples for interacting with API endpoints for Graylog License.

This information has been tested and verified for:
- Graylog 7.0

# Upload/Install Graylog License

Place full text of license into a file called `graylog_enterprise.license`

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

curl "${GRAYLOG_URI_BASE}/api/plugins/org.graylog.plugins.license/licenses" \
  --user "${GRAYLOG_API_TOKEN}:token" \
  --request POST \
  -H 'Content-Type: application/json' \
  --header 'X-Requested-By: XMLHttpRequest' \
  --data-raw $(cat graylog_enterprise.license)
```