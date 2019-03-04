#!/bin/sh

export MIX_ENV=prod
mix deps.get --only prod
mix compile

mix phx.digest.clean

cd assets && npm run deploy && cd ..

mix phx.digest
