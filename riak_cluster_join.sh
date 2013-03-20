#!/bin/bash

DEV_DIR=$HOME/dev

${DEV_DIR}/dev2/bin/riak-admin cluster join dev1@127.0.0.1
${DEV_DIR}/dev3/bin/riak-admin cluster join dev1@127.0.0.1
${DEV_DIR}/dev4/bin/riak-admin cluster join dev1@127.0.0.1
