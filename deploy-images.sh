#!/bin/sh
rsync -chrvz --exclude=.* --progress images root@ferreira.rocks:/data/www/ferreira.rocks
