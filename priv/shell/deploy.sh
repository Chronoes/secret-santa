#!/bin/sh
scp _build/prod/rel/secret_santa/releases/"$1"/secret_santa.tar.gz "$2":~
ssh -t "$2" -- sudo -p "\[sudo\]\ password\ for\ %u@%H:\ " \$HOME/bin/deploy.sh secret_santa
