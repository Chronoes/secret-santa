#!/bin/sh
export MIX_ENV=prod
mix deps.get --only prod
mix compile

cd assets && npm run deploy && cd ..

mix phx.digest
