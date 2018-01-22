#!/bin/sh
rsync -chrvz --bwlimit=20 --exclude=.* --progress images root@ferreira.rocks:/data/www
