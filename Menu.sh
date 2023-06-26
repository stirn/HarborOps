#!/bin/bash

PrintHelp() {
    echo "Usage: $0 <Command> [options]"
    echo "Commands:"
    echo "  GetRepositories                 List all authorized repositories"
    echo "  GetProjects                     Returns projects created by Harbor"
    echo ""
    echo "Command Options:"
    echo "  Mandatory keys:"
    echo "      -u                  URL to connect to"
    echo "      -k                  API key to use"
    echo ""
    echo "  GetRepositories:"
    echo "                          No keys required"
    echo ""
    echo "  GetProjects:"
    echo "                          No keys required"
    echo ""
    # ...to be continued
}

case $1 in
    GetRepositories)
        shift
        GetRepositories "$@"
        ;;
    GetProjects)
        shift
        GetProjects "$@"
        ;;
    *)
        echo "Invalid option: $1"
        PrintHelp
        exit 1
        ;;
esac
