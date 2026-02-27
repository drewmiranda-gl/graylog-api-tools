# View Forwarder Output Metrics

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

append_line() {
    local new_line="$1"

    if [[ -z "$METRICS_LIST" ]]; then
        METRICS_LIST="$new_line"
    else
        METRICS_LIST+=$'\n'"$new_line"
    fi
}

jq_append() {
    local new_item="$1"
    JSON_LIST=$(jq --arg item "${new_item}" '. += [$item]' <<< "$JSON_LIST")
}

METRICS_LIST=""

# get outputs list
OUTPUTS_LIST=$(curl "${GRAYLOG_URI_BASE}/api/system/outputs" \
  --user "${GRAYLOG_API_TOKEN}:token" \
  --silent  | jq -r ".outputs[].id")

JSON_LIST="[]"

# Iterate line-by-line
while IFS= read -r line; do
    jq_append "org.graylog.enterprise.integrations.outputs.forwarder.ForwarderOutput.${line}.forwardedMessages"
    jq_append "org.graylog.enterprise.integrations.outputs.forwarder.journal.ForwarderJournal.${line}.oldest-segment"
    jq_append "org.graylog.enterprise.integrations.outputs.forwarder.journal.ForwarderJournal.${line}.uncommittedMessages"
    jq_append "org.graylog.enterprise.integrations.outputs.forwarder.journal.ForwarderJournal.${line}.unflushedMessages"
done <<< "$OUTPUTS_LIST"

echo $JSON_LIST

JSONPAYLOAD_METRICS='{}'
JSONPAYLOAD_METRICS=$(jq --argjson child "$JSON_LIST" \
  '.metrics = $child' <<< "$JSONPAYLOAD_METRICS")

clear

curl --location "${GRAYLOG_URI_BASE}/api/cluster/metrics/multiple" \
    --silent \
    --header 'Content-Type: application/json' \
    --header 'X-Requested-By: XMLHttpRequest' \
    --user "${GRAYLOG_API_TOKEN}:token" \
    --data "$JSONPAYLOAD_METRICS" | jq -r '
  ["Node Guid","metric name","metric value"],
  ["----","----","----"],
  (
    to_entries[] as $node
    | $node.value.metrics[]
    | [
        $node.key,
        .name,
        (if .type == "meter"
         then "total: \(.metric.rate.total), 1min: \(.metric.rate.one_minute)"
         else (.metric.value | tostring)
         end)
      ]
  )
  | @tsv
' | column -t -s $'\t'

```

# Metric Reference

```
org.graylog.enterprise.integrations.outputs.forwarder.ForwarderOutput.69a1b436fe0a5395771f378b.forwardedMessages
org.graylog.enterprise.integrations.outputs.forwarder.journal.ForwarderJournal.69a1b436fe0a5395771f378b.oldest-segment
org.graylog.enterprise.integrations.outputs.forwarder.journal.ForwarderJournal.69a1b436fe0a5395771f378b.uncommittedMessages
org.graylog.enterprise.integrations.outputs.forwarder.journal.ForwarderJournal.69a1b436fe0a5395771f378b.unflushedMessages
```