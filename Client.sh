#!/bin/bash

source $(dirname $(realpath $0))/HarborApi.sh
API_BASE_PATH="/api/v2.0"

Get () {
      while getopts "u:k:l:" opt; do
        case $opt in
            u)
                local api_url="http://"${OPTARG}
                ;;
            k)
                local api_key=$OPTARG
                ;;
            l)
                local api_path=$OPTARG
                ;;
            *)
                ;;
        esac
    done
    shift $((OPTIND - 1))
    response=$(get $api_url $api_key $api_path)
    process_response "$response"
}

GetAuthRepositories () {
      while getopts "u:k:" opt; do
        case $opt in
            u)
                local api_url="http://"${OPTARG}$API_BASE_PATH
                ;;
            k)
                local api_key=$OPTARG
                ;;
            *)
                ;;
        esac
    done
    shift $((OPTIND - 1))
    response=$(get_auth_repositories $api_url $api_key)
    process_response "$response"
}

GetProjects () {
      while getopts "u:k:" opt; do
        case $opt in
            u)
                local api_url="http://"${OPTARG}$API_BASE_PATH
                ;;
            k)
                local api_key=$OPTARG
                ;;
            *)
                ;;
        esac
    done
    shift $((OPTIND - 1))
    response=$(get_projects $api_url $api_key)
    process_response "$response"
}

GetRepositories () {
      while getopts "u:k:p:" opt; do
        case $opt in
            u)
                local api_url="http://"${OPTARG}$API_BASE_PATH
                ;;
            k)
                local api_key=$OPTARG
                ;;
            p)
                local project_name=$OPTARG
                ;;
            *)
                ;;
        esac
    done
    shift $((OPTIND - 1))
    response=$(get_repositories $api_url $api_key $project_name)
    process_response "$response"
}

GetArtifacts () {
      while getopts "u:k:p:r:" opt; do
        case $opt in
            u)
                local api_url="http://"${OPTARG}$API_BASE_PATH
                ;;
            k)
                local api_key=$OPTARG
                ;;
            p)
                local project_name=$OPTARG
                ;;
            r)
                local repository_name=$OPTARG
                ;;
            *)
                ;;
        esac
    done
    shift $((OPTIND - 1))
    response=$(get_artifacts $api_url $api_key $project_name $repository_name)
    process_response "$response"
    # jq '.[].addition_links.vulnerabilities.href' - to read vulnerabilities links
}

process_response () {
  local response_body=$(echo $1 | awk -F":curl_output:" '{print $1}')
  local curl_output=$(echo $1 | awk -F":curl_output:" '{print $2}')
    if [[ $(echo $curl_output) -eq "http_response=200" ]]; then
            echo "$response_body"
        else
            echo "--- Error: $curl_output" >&2
            exit 1
    fi
}

source $(dirname $(realpath $0))/Menu.sh
