#!/usr/bin/python3

import requests
import argparse
import logging
import json
from colorama import init, Fore, Style

logging.basicConfig(level=logging.DEBUG)

API_BASE_PATH = "/api/v2.0"


def send_request(method, uri, api_key):
    headers = {
        "authorization": "Basic " + api_key,
        "accept": "application/json"
    }

    try:
        response = requests.request(method, uri, headers=headers)
        return process_response(response)
    except (requests.HTTPError, ValueError) as e:
        print(str(e))
        exit(1)


def send_get_request(uri, api_key):
    return send_request("GET", uri, api_key)


def get_auth_repositories(api_url, api_key):
    path = "/repositories"
    uri = api_url + path
    return send_get_request(uri, api_key)


def get_projects(api_url, api_key):
    path = "/projects"
    uri = api_url + path
    return send_get_request(uri, api_key)


def get_repositories(api_url, api_key, project_name):
    path = f"/projects/{project_name}/repositories"
    uri = api_url + path
    return send_get_request(uri, api_key)


def get_artifacts(api_url, api_key, project_name, repository_name):
    path = f"/projects/{project_name}/repositories/{repository_name}/artifacts"
    uri = api_url + path
    return send_get_request(uri, api_key)


def get(api_url, api_key, api_path):
    uri = f"{api_url}/{api_path}"
    return send_get_request(uri, api_key)


def process_response(response):
    try:
        response.raise_for_status()
        return response.json()
    except requests.HTTPError as e:
        error_message = f"--- Error: HTTP Status Code {response.status_code}"
        raise requests.HTTPError(error_message) from e
    except json.JSONDecodeError as e:
        error_message = "Invalid JSON response received"
        raise ValueError(error_message) from e


def print_help():
    print("Usage: python script.py <Command> [options]")
    print("Commands:")
    print("  Get                             Make GET request by specified path")
    print("  GetAuthRepositories             List all authorized repositories")
    print("  GetProjects                     Returns projects created by Harbor")
    print("  GetRepositories                 List repositories of the specified project")
    print("  GetArtifacts                    List artifacts under the specific project and repository")
    print("")
    print("Command Options:")
    print("  Mandatory keys:")
    print("      -u                  URL to connect to")
    print("      -k                  API key to use")
    print("")
    print("  Get:")
    print("      -l                  Request path (without schema and domain)")
    print("")
    print("  GetAuthRepositories:")
    print("                          No keys required")
    print("")
    print("  GetProjects:")
    print("                          No keys required")
    print("")
    print("  GetRepositories:")
    print("      -p                  The name of the project")
    print("")
    print("  GetArtifacts:")
    print("      -p                  The name of the project")
    print("      -r                  The name of the repository")
    print("")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command")

    get_parser = subparsers.add_parser("Get")
    get_parser.add_argument("-u", required=True, help="URL to connect to")
    get_parser.add_argument("-k", required=True, help="API key to use")
    get_parser.add_argument("-l", required=True, help="Request path (without schema and domain)")

    get_auth_repositories_parser = subparsers.add_parser("GetAuthRepositories")
    get_auth_repositories_parser.add_argument("-u", required=True, help="URL to connect to")
    get_auth_repositories_parser.add_argument("-k", required=True, help="API key to use")

    get_projects_parser = subparsers.add_parser("GetProjects")
    get_projects_parser.add_argument("-u", required=True, help="URL to connect to")
    get_projects_parser.add_argument("-k", required=True, help="API key to use")

    get_repositories_parser = subparsers.add_parser("GetRepositories")
    get_repositories_parser.add_argument("-u", required=True, help="URL to connect to")
    get_repositories_parser.add_argument("-k", required=True, help="API key to use")
    get_repositories_parser.add_argument("-p", required=True, help="The name of the project")

    get_artifacts_parser = subparsers.add_parser("GetArtifacts")
    get_artifacts_parser.add_argument("-u", required=True, help="URL to connect to")
    get_artifacts_parser.add_argument("-k", required=True, help="API key to use")
    get_artifacts_parser.add_argument("-p", required=True, help="The name of the project")
    get_artifacts_parser.add_argument("-r", required=True, help="The name of the repository")

    args = parser.parse_args()

    if args.command == "Get":
        api_url = "http://" + args.u + API_BASE_PATH
        api_key = args.k
        api_path = args.l
        response = get(api_url, api_key, api_path)
        print(json.dumps(response, indent=4))
    elif args.command == "GetAuthRepositories":
        api_url = "http://" + args.u + API_BASE_PATH
        api_key = args.k
        response = get_auth_repositories(api_url, api_key)
        print(json.dumps(response, indent=4))
    elif args.command == "GetProjects":
        api_url = "http://" + args.u + API_BASE_PATH
        api_key = args.k
        response = get_projects(api_url, api_key)
        json_resp = json.dumps(response, indent=4)
        colorized_json = "\n".join(f"{Fore.CYAN}{line}{Style.RESET_ALL}" for line in json_resp.splitlines())
        print(colorized_json)
    elif args.command == "GetRepositories":
        api_url = "http://" + args.u + API_BASE_PATH
        api_key = args.k
        project_name = args.p
        response = get_repositories(api_url, api_key, project_name)
        print(json.dumps(response, indent=4))
    elif args.command == "GetArtifacts":
        api_url = "http://" + args.u + API_BASE_PATH
        api_key = args.k
        project_name = args.p
        repository_name = args.r
        response = get_artifacts(api_url, api_key, project_name, repository_name)
        print(json.dumps(response, indent=4))
    else:
        print("Invalid option:", args.command)
        print_help()
        exit(1)