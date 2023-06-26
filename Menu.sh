#!/bin/bash

PrintHelp() {
    echo "Usage: $0 <Command> [options]"
    echo "Commands:"
    echo "  GetAuthRepositories             List all authorized repositories"
    echo "  GetProjects                     Returns projects created by Harbor"
    echo "  GetRepositories                 List repositories of the specified project"
    echo ""
    echo "Command Options:"
    echo "  Mandatory keys:"
    echo "      -u                  URL to connect to"
    echo "      -k                  API key to use"
    echo ""
    echo "  GetAuthRepositories:"
    echo "                          No keys required"
    echo ""
    echo "  GetProjects:"
    echo "                          No keys required"
    echo ""
    echo "  GetRepositories:"
    echo "      -p                  The name of the project"
    echo ""
    # ...to be continued
}

case $1 in
    GetAuthRepositories)
        shift
        GetAuthRepositories "$@"
        ;;
    GetProjects)
        shift
        GetProjects "$@"
        ;;
    GetRepositories)
        shift
        GetRepositories "$@"
        ;;
    *)
        echo "Invalid option: $1"
        PrintHelp
        exit 1
        ;;
esac
