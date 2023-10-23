#!/bin/bash
sudo echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.profile
sudo echo 'export CGO_LDFLAGS_ALLOW='-fopenmp'' >> ~/.profile

sudo apt install libvips-dev libraw-bin libraw-dev

mkdir -p ./dist/data/

cp -r config ./dist/data/

npm install --legacy-peer-deps
npm rebuild node-sass

NODE_ENV=production npm run build

cd server

go get
cd ..

go build -ldflags "-X github.com/mickael-kerjean/filestash/server/common.BUILD_NUMBER=`date -u +%Y%m%d`" -o ./dist/filestash ./server/main.go

mkdir -p ./dist/data/plugin

go build -buildmode=plugin -o ./dist/data/plugin/image.so server/plugin/plg_image_light/index.go

sudo apt install ca-certificates

sudo mv dist /app
