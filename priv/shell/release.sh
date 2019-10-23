#!/bin/sh
export MIX_ENV=prod
export TZ=Europe/Tallinn

mix distillery.release
