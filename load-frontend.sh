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

echo "update " $FRONTEND_SRC_DIR
cd $FRONTEND_SRC_DIR && git clone git@github.com:hhru-school/techradar.git
git checkout $FRONTEND_SRC_DIR
echo "building frontend "
cd $FRONTEND_SRC_DIR && npm i
cd $FRONTEND_SRC_DIR && npm build react-app-rewired -y

cd $prodDir && docker-compose up -d --build

# curl -F chat_id=$TELEGRAM_ADMIN_CHAT -F text="finish deploy ${BASE_DOMAIN}" \
# https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage
