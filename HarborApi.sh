#!/bin/bash

# Helper function to send HTTP requests using curl
send_request() {
    local method="$1"
    local uri="$2"
    local api_key="$3"
    shift 3
    local curl_params=(
        -s
        -w ":curl_output:http_code=%{http_code}"
        -X "$method"
        -H "authorization: Basic $api_key"
        -H "accept: application/json"
        "$@"
    )
    local response=$(curl "${curl_params[@]}" "$uri")
    echo "$response"
}

# Helper function to send HTTP GET requests
send_get_request() {
    send_request "GET" "$@"
}

# Helper function to send HTTP POST requests
send_post_request() {
    send_request "POST" "$@"
}

get_auth_repositories() {
    local api_url=$1
    local api_key="$2"
    local path="/repositories"
    send_get_request "${api_url}${path}" "$api_key"
}

get_projects() {
    local api_url=$1
    local api_key="$2"
    local path="/projects"
    send_get_request "${api_url}${path}" "$api_key"
}

get_repositories() {
    local api_url=$1
    local api_key="$2"
    local project_name="$3"
    local path="/projects/$project_name/repositories"
    send_get_request "${api_url}${path}" "$api_key"
}

get_artifacts() {
    local api_url=$1
    local api_key="$2"
    local project_name="$3"
    local repository_name="$4"
    local path="/projects/$project_name/repositories/$repository_name/artifacts"
    send_get_request "${api_url}${path}" "$api_key"
}

get () {
  local uri="$1/$3"
  local api_key="$2"
  send_get_request "$uri" "$api_key"
}
