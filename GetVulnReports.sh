#!/bin/bash

ReadRepositories () {
    for p in $projects; do
        local repositories=$(./Client.sh GetRepositories -u $1 -k $2 -p $p | jq -r '.[].name')
        echo $repositories
    done
}

ReadArtifacts () {
    for r in $repositories; do
        local project=$(echo $r | awk -F"\/" '{print $1}')
        local repository=$(echo $r | awk -F"\/" '{print $2}')
        echo $(./Client.sh GetArtifacts -u $1 -k $2 -p $project -r $repository | jq -r '.[].addition_links.vulnerabilities.href')
    done
}

ReadVulnReports () {
    for v in $vuln_reports_links; do
        echo $(./Client.sh Get -u $1 -k $2 -l $v)
    done
}

projects=$(./Client.sh GetProjects -u $1 -k $2 | jq -r '.[].name')
repositories=$(ReadRepositories $1 $2)
vuln_reports_links=$(ReadArtifacts $1 $2)
vuln_reports=$(ReadVulnReports $1 $2)

echo $vuln_reports