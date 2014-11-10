#!/bin/sh

npm install http-server

echo "Point Overview to http://localhost:9050"

node_modules/.bin/http-server -p 9050 --cors -c-1
