#!/bin/bash

send_request() {
    local method="$1"
    local uri="$2"
    shift 2
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

send_get_request() {
    send_request "GET" "$@"
}

send_post_request() {
    send_request "POST" "$@"
}

get_auth_repositories() {
    local path="/repositories"
    send_get_request "${api_url}${path}"
}

get_projects() {
    local path="/projects"
    send_get_request "${api_url}${path}"
}

get_repositories() {
    local project_name="$3"
    local path="/projects/$project_name/repositories"
    send_get_request "${api_url}${path}"
}

get_artifacts() {
    local project_name="$3"
    local repository_name="$4"
    local path="/projects/$project_name/repositories/$repository_name/artifacts"
    send_get_request "${api_url}${path}"
}

get () {
  local uri="$1/$3"
  send_get_request "$uri"
}
