#!/bin/sh
scp _build/prod/rel/secret_santa/releases/"$1"/secret_santa.tar.gz "$2":~
ssh "$2" -- tar xvzf ~/secret_santa.tar.gz -C /srv/secret_santa \; systemctl restart secret-santa-server.service
