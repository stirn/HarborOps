#!/bin/bash

get_auth_repositories () {
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

get_projects () {
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

get_repositories () {
  local project_name="$3"
  local uri="$1/api/v2.0/projects/$project_name/repositories"
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

get_artifacts () {
  local project_name="$3"
  local repository_name="$4"
  local uri="$1/api/v2.0/projects/$project_name/repositories/$repository_name/artifacts"
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
