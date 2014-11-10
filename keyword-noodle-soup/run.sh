#!/bin/sh

npm install http-server

echo "Point Overview to http://localhost:9051"

node_modules/.bin/http-server -p 9051 --cors -c-1
