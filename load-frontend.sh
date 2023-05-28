#!/usr/bin/env bash

IFS='
'
export $(egrep -v '^#' .env | xargs -0)
IFS=
prodDir=$PWD
branch=$@
if [  -z "$@" ]
  then
    branch=$PROJECTS_BRANCH
fi
echo "Working branch " $branch

# curl -F chat_id=$TELEGRAM_ADMIN_CHAT -F text="start deploy ${BASE_DOMAIN} ${branch}" \
# https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage

folders=( \
    $FRONTEND_SRC_DIR \
      )

for folder in ${folders[*]}
do
    echo "update " $folder
    cd $folder && git clone git@github.com:hhru-school/techradar.git
    git checkout $branch
    echo "building frontend "
    cd $folder && npm i
    cd $folder && npm build react-app-rewired -y
done

cd $prodDir && docker-compose up -d --build

# curl -F chat_id=$TELEGRAM_ADMIN_CHAT -F text="finish deploy ${BASE_DOMAIN}" \
# https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage
