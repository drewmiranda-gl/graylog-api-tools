# Introduction

Reference Examples for interacting with API endpoints for Graylog Reports. Note that Reports is an enterprise feature and requires an active enterprise license.

This information has been tested and verified for:
- Graylog 6.3
- Graylog 7.0
- Graylog Cloud

# View Report

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

# REPORTS unique ObjectID, 
#   can be obtained from viewing the report config in Graylog UI
REPORT_OID=
# name of output file
OUTPUT_FILE_NAME="output.csv"

curl "${GRAYLOG_URI_BASE}/api/plugins/org.graylog.plugins.report/reports/${REPORT_OID}/generate/report_filename_not_used" \
  --user "${GRAYLOG_API_TOKEN}:token" \
  --output "${OUTPUT_FILE_NAME}"
```