#!/bin/bash
set -euo pipefail

for branch in $(git for-each-ref --format='%(refname)' refs/heads/); do
	if [ "master" = "${branch#*/*/}" ]; then
	    echo "no force"
	    echo "${branch#*/*/}"
	else
	    echo "force"
	    echo "${branch#*/*/}"
	fi
done

mkdir git-magic
cd git-magic
git clone --mirror https://github.com/Nitrokey/pynitrokey.git
cd pynitrokey.git
git remote add --mirror=fetch secondary https://git.dotplex.com/Nitrokey/pynitrokey.git
git remote set-url secondary https://oauth2:$GITLAB_REPO_KEY@git.dotplex.com/Nitrokey/pynitrokey.git
git fetch origin
git push secondary --tags

for branch in $(git for-each-ref --format='%(refname)' refs/heads/); do
	if [ "master" = "${branch#*/*/}" ]; then
	    echo "${branch#*/*/}"
	    git push secondary ${branch#*/*/}
	else
	    echo "${branch#*/*/}"
	    git push secondary ${branch#*/*/} --force
	fi
done