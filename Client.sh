#!/bin/bash

source $(dirname $(realpath $0))/HarborApi.sh

GetRepositories() {
      while getopts "u:k:" opt; do
        case $opt in
            u)
                local api_url="http://"${OPTARG}
                ;;
            k)
                local api_key=$OPTARG
                ;;
            *)
                ;;
        esac
    done
    shift $((OPTIND - 1))
    response=$(get_repositories $api_url $api_key)
    response_body=$(echo $response | awk -F" :curl_output:" '{print $1}')
    curl_output=$(echo $response | awk -F" :curl_output:" '{print $2}')

    if [[ $(echo $curl_output) -eq "http_response=200" ]]; then
            echo $response_body | jq '.[].name'
        else
            echo "--- Error: $curl_output" >&2
            exit 1
    fi
}

source $(dirname $(realpath $0))/Menu.sh

#