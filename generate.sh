#!/bin/bash

rm src docs test -rf
openapi-generator-cli generate \
-g typescript-axios \
--additional-properties=npmName=vrchatapi \
--git-user-id=vrchatapi \
--git-repo-id=vrchatapi-javascript \
-o . \
-i ../specification/openapi.yaml \
--http-user-agent="vrchatapi-javascript"

# Modify package.json
sed -i 's/Unlicense/MIT/g' ./package.json

# Enable global cookies
sed -i '/^import { BASE_PATH/a import axiosCookieJarSupport from "axios-cookiejar-support";axiosCookieJarSupport(globalAxios);import { CookieJar } from "tough-cookie";globalAxios.defaults.jar = new CookieJar();globalAxios.defaults.withCredentials = true;' ./api.ts

sed -i '/"dependencies"/a     "@types/tough-cookie": "^4.0.1",' ./package.json
sed -i '/"dependencies"/a     "axios-cookiejar-support": "^1.0.1",' ./package.json
sed -i '/"dependencies"/a     "tough-cookie": "^4.0.0",' ./package.json

npm install
npm run build