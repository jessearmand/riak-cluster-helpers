#!/bin/bash

CWD=$(cd $(dirname $0); pwd)
HOME_DIR=$HOME

BASE_DIR="${HOME_DIR}/dev"
echo "Creating dev directory ${BASE_DIR}"
mkdir "${BASE_DIR}"

for node in 1 2 3 4; do
  NODE_NAME="dev${node}"
  NODE_DIR="$BASE_DIR/$NODE_NAME"

  echo "Creating node ${NODE_NAME}"
  cp -r $(brew --prefix riak) $NODE_DIR

  echo "  Removing data dir"
  rm -rf "$NODE_DIR/libexec/data/"

  HTTP="809${node}"
  echo "  Setting 'http' to '${HTTP}'"
  perl -p -i.bak -e 's/({http, \[ {"\d+\.\d+\.\d+\.\d+", )(\d+)( } ]})/${1}'${HTTP}'${3}/g' "$NODE_DIR/libexec/etc/app.config"

  HANDOFF_PORT="810${node}"
  echo "  Setting 'handoff_port' to '${HANDOFF_PORT}'"
  perl -p -i.bak -e 's/({handoff_port, )(\d+)( })/${1}'${HANDOFF_PORT}'${3}/g' "$NODE_DIR/libexec/etc/app.config"

  PB_PORT="808${node}"
  echo "  Setting 'pb_port' to '${PB_PORT}'"
  perl -p -i.bak -e 's/({pb_port, )(\d+)( })/${1}'${PB_PORT}'${3}/g' "$NODE_DIR/libexec/etc/app.config"

  NAME="dev${node}"
  echo "  Setting 'name' to '${NAME}'"
  perl -p -i.bak -e 's/(-name )(\S+)(@.*)$/${1}'${NAME}'${3}/g' "$NODE_DIR/libexec/etc/vm.args"

  NODE_BIN_DIR="$NODE_DIR/libexec/bin"
  echo "  Setting 'RUNNER_SCRIPT_DIR' to '${NODE_BIN_DIR}'"
  perl -p -i.bak -e "s|RUNNER_SCRIPT_DIR=.*$|RUNNER_SCRIPT_DIR=${NODE_BIN_DIR}|g" "$NODE_DIR/bin/riak" \
    "$NODE_DIR/bin/riak-admin" \
    "$NODE_DIR/bin/search-cmd" \
    "$NODE_DIR/libexec/bin/riak" \
    "$NODE_DIR/libexec/bin/riak-admin" \
    "$NODE_DIR/libexec/bin/search-cmd"

done
