# Introduction

Reference Examples for interacting with API endpoints for Graylog Sigma Rules.

This information has been tested and verified for:
- Graylog 6.3
- Graylog 7.0
- Graylog Cloud

# Create Sigma Rule

Required JSON properties:

```json
{
  "entity": {
    "source": "title: Z TEST Django Framework Exceptions\nid: zzzz5618-981e-4a7c-81f8-f78ce480zzzz\nstatus: stable\ndescription: Detects suspicious Django web application framework exceptions that could indicate exploitation attempts\nreferences:\n    - https://docs.djangoproject.com/en/1.11/ref/exceptions/\n    - https://docs.djangoproject.com/en/1.11/topics/logging/#django-security\nauthor: Thomas Patzke\ndate: 2017/08/05\nmodified: 2020/09/01\ntags:\n    - attack.initial_access\n    - attack.t1190\nlogsource:\n    category: application\n    product: django\ndetection:\n    keywords:\n        - SuspiciousOperation\n        # Subclasses of SuspiciousOperation\n        - DisallowedHost\n        - DisallowedModelAdminLookup\n        - DisallowedModelAdminToField\n        - DisallowedRedirect\n        - InvalidSessionKey\n        - RequestDataTooBig\n        - SuspiciousFileOperation\n        - SuspiciousMultipartForm\n        - SuspiciousSession\n        - TooManyFieldsSent\n        # Further security-related exceptions\n        - PermissionDenied\n    condition: keywords\nfalsepositives:\n    - Application bugs\nlevel: medium\n",
    "streams": [],
    "stream_categories": [],
    "notifications": [],
    "search_within_ms": 300000,
    "execute_every_ms": 300000,
    "use_cron_scheduling": false
  }
}
```

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

curl "${GRAYLOG_URI_BASE}/api/plugins/org.graylog.plugins.securityapp.sigma/sigma/rules" \
  --user "${GRAYLOG_API_TOKEN}:token" \
  -H 'Content-Type: application/json' \
  -H 'X-Requested-By: XMLHttpRequest' \
  -d "@sigmarule_before_gl7.json"
```

Note that Graylog 7 introduces breaking changes for this API endpoint. See [General REST API Changes](https://github.com/Graylog2/graylog2-server/blob/7.0/UPGRADING.md#general-rest-api-changes)

# Viewing Existing Sigma Rules

This is very useful if you need or want to copy an existing Sigma Rule schema.

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

# return Sigma Rules
curl "${GRAYLOG_URI_BASE}/api/plugins/org.graylog.plugins.securityapp.sigma/sigma/rules?page=1&per_page=15&user_timezone=UTC&sort=parsed_rule.title&direction=asc" \
  --user "${GRAYLOG_API_TOKEN}:token"

# use a query to return a single Sigma Rule, using its `title`
# using jq ( https://jqlang.org/ ) to perform URLENCODE duties, spaces MUST be replaced with %20
SIGMA_RULE_TITLE="Z TEST Django Framework Exceptions"
ENCODED_SIGMA_RULE_TITLE=$(printf %s "$SIGMA_RULE_TITLE" | jq -sRr @uri)
curl "${GRAYLOG_URI_BASE}/api/plugins/org.graylog.plugins.securityapp.sigma/sigma/rules?page=1&per_page=15&query=title%3A%22${ENCODED_SIGMA_RULE_TITLE}%22&user_timezone=UTC&sort=parsed_rule.title&direction=asc" \
  --user "${GRAYLOG_API_TOKEN}:token"
```