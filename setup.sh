#!/bin/bash

read -p 'make sure you have installed go as described in the md file, then press enter to continue'

sudo echo 'export GOPATH=/tmp/go' >> ~/.profile
sudo echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.profile
sudo echo 'export CGO_LDFLAGS_ALLOW='-fopenmp'' >> ~/.profile
sudo source ~/.profile

mkdir -p $GOPATH/src/github.com/mickael-kerjean/

mkdir /tmp/deps && cd /tmp/deps

sudo apt-get install libvips-dev libraw-bin libraw-dev

cd $GOPATH/src/github.com/mickael-kerjean
git clone --depth 1 https://github.com/mickael-kerjean/filestash
cd filestash

mkdir -p ./dist/data/

cp -r config ./dist/data/

npm install
npm rebuild node-sass

NODE_ENV=production npm run build

cd $GOPATH/src/github.com/mickael-kerjean/filestash/server

go get

cd ..

go build -ldflags "-X github.com/mickael-kerjean/filestash/server/common.BUILD_NUMBER=`date -u +%Y%m%d`" -o ./dist/filestash ./server/main.go

mkdir -p ./dist/data/plugin

go build -buildmode=plugin -o ./dist/data/plugin/image.so server/plugin/plg_image_light/index.go

sudo apt-get install emacs texlive texlive-base texlive-latex-extra zip

sudo chmod 777 /usr/share/texlive/texmf-dist/tex/latex/base/

sudo curl https://raw.githubusercontent.com/mickael-kerjean/filestash_latex/master/wrapfig.sty > /usr/share/texlive/texmf-dist/tex/latex/base/wrapfig.sty

sudo curl https://raw.githubusercontent.com/mickael-kerjean/filestash_latex/master/capt-of.sty > /usr/share/texlive/texmf-dist/tex/latex/base/capt-of.sty

sudo curl https://raw.githubusercontent.com/mickael-kerjean/filestash_latex/master/sectsty.sty > /usr/share/texlive/texmf-dist/tex/latex/base/sectsty.sty

sudo texhash

sudo find /usr/share/emacs -name '*.pbm' | sudo xargs rm

sudo find /usr/share/emacs -name '*.png' | sudo xargs rm

sudo find /usr/share/emacs -name '*.xpm' | sudo xargs rm

sudo rm -rf /usr/share/texmf-dist/doc

cd $GOPATH/src/github.com/mickael-kerjean/filestash/

sudo apt-get install ca-certificates

sudo mv dist /app
