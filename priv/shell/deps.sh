#!/bin/sh

favicons_zip="$1"

if [ ! -f $favicons_zip ]; then
    echo "File $favicons_zip does not exist"
    exit 1
fi

if [ -d priv/static ]; then
    rm -r priv/static
fi

cd assets && npm run deploy && cd ..

mkdir -p _build/favicons
unzip $favicons_zip -x '*.md' '*.html' -d _build/favicons
mv _build/favicons/* priv/static

mix phx.digest
