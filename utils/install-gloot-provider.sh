#!/usr/bin/env bash
#
# gh-dl-release! It works!
#
# This script downloads an asset from latest or specific Github release of a
# private repo. Feel free to extract more of the variables into command line
# parameters.
#
# PREREQUISITES
#
# curl, wget, jq
#
# USAGE
#
# Set all the variables inside the script, make sure you chmod +x it, then
# to download specific version to my_app.tar.gz:
#
#     gh-dl-release 2.1.1 my_app.tar.gz
#
# to download latest version:
#
#     gh-dl-release latest latest.tar.gz
#
# If your version/tag doesn't match, the script will exit with error.
set -e

TOKEN=$GITHUB_DOWNLOAD_TOKEN
REPO="g-loot/gloot-terraform-provider"
FILE="gloot-provider_linux_amd64" # the name of your release asset file, e.g. build.tar.gz
VERSION=$1                       # tag name or the word "latest"
GITHUB="https://api.github.com"

alias errcho='>&2 echo'

function gh_curl() {
  curl -H "Authorization: token $TOKEN" \
       -H "Accept: application/vnd.github.v3.raw" \
       "$@"
}

# Fetch all releases
releases=$(gh_curl -s $GITHUB/repos/$REPO/releases)

if [ "$VERSION" = "latest" ]; then
  # Github should return the latest release first, use that to parse the version number.
  VERSION=$(echo "$releases" | jq -r ".[0].tag_name")
fi

parser=". | map(select(.tag_name == \"$VERSION\"))[0].assets | map(select(.name == \"${FILE}\"))[0].id"
asset_id=$(echo "$releases" | jq "$parser")

if [ "$asset_id" = "null" ]; then
  errcho "ERROR: version not found $VERSION"
  exit 1
fi;

wget -q --auth-no-challenge --header='Accept:application/octet-stream' \
  https://"$TOKEN":@api.github.com/repos/$REPO/releases/assets/"$asset_id" \
  -O $FILE

mkdir -p ~/.terraform.d/plugins/terraform.gloot.com/providers/gloot/"$VERSION"/linux_amd64
chmod +x $FILE
mv $FILE ~/.terraform.d/plugins/terraform.gloot.com/providers/gloot/"$VERSION"/linux_amd64/terraform-provider-gloot_v"$VERSION"
