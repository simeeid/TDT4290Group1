#!/bin/bash

if [ "${BUILD_MODE}" == "prod" ];
then
    npm run build && npm run start
else
    npm run dev
fi

# vim:ff=unix
