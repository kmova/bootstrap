#!/bin/bash -x

TAG_NAME="v1.0.1"
TAG_BRANCH="master"
GIT_URL="https://api.github.com/repos/kmova/bootstrap/releases"


RELEASE_CREATE_JSON=$(echo \
{ \
 \"tag_name\":\"${TAG_NAME}\", \
 \"target_commitish\":\"${TAG_BRANCH}\", \
 \"name\":\"${TAG_NAME}\", \
 \"body\":\"Test releasing via CLI\", \
 \"draft\":false, \
 \"prerelease\":false \
} \
)


echo ${RELEASE_CREATE_JSON}

curl -u ${GIT_NAME}:${GIT_TOKEN} \
 --url ${GIT_URL} \
 --request POST --header 'content-type: application/json' \
 --data "$RELEASE_CREATE_JSON"
