#!/bin/sh
scp _build/prod/rel/secret_santa/releases/"$1"/secret_santa.tar.gz "$2":/home/holo
ssh -t "$2" -- sudo tar xvzf /home/holo/secret_santa.tar.gz -C /srv/secret_santa \;\
    sudo chown -R http:http /srv/secret_santa
