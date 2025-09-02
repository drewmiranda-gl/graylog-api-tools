#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/config.sh

RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"

ERROR_CONTROL() {
    if (( $1 > 0 )); then
        echo "NON ZERO EXIT CODE: ${1}"
        exit
    fi
}

EXIT_ON_EMPTY() {
    if [[ -z $1 ]]; then
        # echo "${2}"
        echo -e "${RED}${2}${ENDCOLOR}"
        exit 1
    fi
}

EXIT_ON_WHICH_EMPTY() {
    (which $1 > /dev/null)
    exit_code=$?
    if (( $exit_code > 0 )); then
        echo -e "${RED}ERROR:${ENDCOLOR} cannot find ${1}"
        echo "Resolve by installing package: ${2}"
        exit
    fi
}

CONCAT(){
    echo "$1$2"
}

to_lowercase(){
    echo $(echo ${1} | awk '{print tolower($1)}')
}

to_uppercase(){
    echo $(echo ${1} | awk '{print toupper($1)}')
}

escape_quotes() {
  local input="$1"
  echo "$input" | sed 's/"/\\"/g'
}

trim_leading_trailing_quotes() {
    local str="$1"
    echo "$str" | sed 's/^"//; s/"$//'
}

TRIM_LAST_SLASH() {
    # echo $1
    echo "$1" | sed 's/\/$//'
}

GRAYLOG_URL_BASE=$(TRIM_LAST_SLASH $GRAYLOG_URL_BASE)

EXEC_CURL() {
    HTTP_METHOD="$1"
    CURL_URL="$2"
    HTTP_USERPASS="$3"
    HTTP_PAYLOAD="$4"
    
    HTTP_METHOD_UPPER="$(to_uppercase $1)"
    USNPWBASESIXFOUR=$(echo -n $HTTP_USERPASS | openssl base64 -A)

    HEADER_AUTH="--header"
    HEADER_AUTH_VAL="Authorization: Basic ${USNPWBASESIXFOUR}"
    if [[ -z $1 ]]; then
        HEADER_AUTH=""
        HEADER_AUTH_VAL=""
    fi

    # echo "HTTP Method: ${HTTP_METHOD_UPPER}"
    if [ "$HTTP_METHOD_UPPER" = "GET" ]; then
        # echo "${HTTP_METHOD_UPPER} ${CURL_URL}"
        curl --silent --location "$CURL_URL" $HEADER_AUTH "$HEADER_AUTH_VAL"
    elif [ "$HTTP_METHOD_UPPER" = "POST" ]; then
        # echo "${HTTP_METHOD_UPPER} ${CURL_URL}"
        # echo "PAYLOAD: ${HTTP_PAYLOAD}"
        curl --silent -XPOST --location "$CURL_URL" $HEADER_AUTH "$HEADER_AUTH_VAL" --header "X-Requested-By: API Tools" --header 'Content-Type: application/json' --data "$HTTP_PAYLOAD"
    elif [ "$HTTP_METHOD_UPPER" = "DELETE" ]; then
        # echo "${HTTP_METHOD_UPPER} ${CURL_URL}"
        # echo "PAYLOAD: ${HTTP_PAYLOAD}"
        curl --silent -XDELETE --location "$CURL_URL" $HEADER_AUTH "$HEADER_AUTH_VAL" --header "X-Requested-By: API Tools"
    fi
}

QUERY_GRAYLOG_API() {
    API_METHOD=$1
    API_URL=$2
    PAYLOAD=$3
    # GRAYLOG_API_TOKEN
    # GRAYLOG_URL_BASE
    CURL_URL="${GRAYLOG_URL_BASE}${API_URL}"
    USNPW="${GRAYLOG_API_TOKEN}:token"
    EXEC_CURL "$API_METHOD" "$CURL_URL" "$USNPW" "$PAYLOAD"
    
}

EXAMPLE_TO_USE_QUERY_GRAYLOG_API() {
    # echo -e "${BLUE}Building list of Graylog Index Sets${ENDCOLOR}"
    JSON=$(QUERY_GRAYLOG_API "/api/system/indices/index_sets?skip=0&limit=0&stats=false")
    echo $JSON | jq -r '.index_sets[] | .id + "," + .title'
}

CREATE_GRAYLOG_INPUT() {    
    TITLE="$1"
    PAYLOAD="$2"

    echo -e "\nCreating Graylog Input: ${TITLE}"

    QUERY_GRAYLOG_API "POST" "/api/system/inputs?setup_wizard=false" "$PAYLOAD"
}

GET_GRAYLOG_INPUTS() {
    QUERY_GRAYLOG_API "GET" "/api/system/inputs"
}

DELETE_GRAYLOG_INPUT() {
    INPUT_ID="$1"
    echo "Deleting input by ID: ${INPUT_ID}"
    QUERY_GRAYLOG_API "DELETE" "/api/system/inputs/${INPUT_ID}"
}

DELETE_LIST_OF_GRAYLOG_INPUTS() {
    INPUT="$1"

    while IFS= read -r line; do
        INPUT_ID_TRIMMED=$(trim_leading_trailing_quotes $line)
        DELETE_GRAYLOG_INPUT "$INPUT_ID_TRIMMED"
    done <<< "$INPUT"
}

DELETE_ALL_RANDOM_INPUTS() {
    LIST_OF_RDM_INPUTS=$(GET_GRAYLOG_INPUTS | jq '.inputs[] | select(.type == "org.graylog2.inputs.random.FakeHttpMessageInput") | .id')
    DELETE_LIST_OF_GRAYLOG_INPUTS "$LIST_OF_RDM_INPUTS"
}

CREATE_MANY_MANY_RANDOM_INPUTS() {
    I_MAX=$1

    i=1
    while [ $i -le $I_MAX ]; do
        INPUT_NUMBER="$i"
        INPUT_TITLE="rdm_${INPUT_NUMBER}"
        INPUT_JSON_PAYLOAD="{ \"type\": \"org.graylog2.inputs.random.FakeHttpMessageInput\", \"configuration\": { \"throttling_allowed\": false, \"sleep\": 1000, \"sleep_deviation\": 2000, \"source\": \"example.org\", \"override_source\": null, \"charset_name\": \"UTF-8\" }, \"title\": \"${INPUT_TITLE}\", \"global\": true, \"node\": \"3113601e-4276-4075-9d35-0c24de6b3204\" }"
        CREATE_GRAYLOG_INPUT "$INPUT_TITLE" "$INPUT_JSON_PAYLOAD"
        ((i++))
    done
}

MAIN() {
    echo -e "Graylog API Base: ${GRAYLOG_URL_BASE}"
    
    # Delete Random Inputs
    # DELETE_ALL_RANDOM_INPUTS

    # Create Random Inputs
    # CREATE_MANY_MANY_RANDOM_INPUTS 300
}

# verify dependencies
EXIT_ON_WHICH_EMPTY "curl" "curl"
EXIT_ON_WHICH_EMPTY "jq" "jq"

# verify inputs/config
MSG_EMPTY="empty or not configured. See config.sh" 
EXIT_ON_EMPTY "$GRAYLOG_URL_BASE" "\$GRAYLOG_URL_BASE${MSG_EMPTY}"
EXIT_ON_EMPTY "$GRAYLOG_API_TOKEN" "\$GRAYLOG_API_TOKEN${MSG_EMPTY}"

MAIN