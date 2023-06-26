#!/bin/bash

get_repositories() {
  local uri="$1/api/v2.0/repositories"
  local api_key="$2"
  local curl_params=(
    -s
    -w ":curl_output:http_code=%{http_code}"
    -X 'GET' "$uri"
    -H "authorization: Basic $api_key"
    -H "accept: application/json"
  )
  local response=$(curl "${curl_params[@]}")
  echo "$response"
}

get_projects() {
  local uri="$1/api/v2.0/projects"
  local api_key="$2"
  local curl_params=(
    -s
    -w ":curl_output:http_code=%{http_code}"
    -X 'GET' "$uri"
    -H "authorization: Basic $api_key"
    -H "accept: application/json"
  )
  local response=$(curl "${curl_params[@]}")
  echo "$response"
}
