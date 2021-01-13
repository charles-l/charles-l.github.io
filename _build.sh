#!/bin/sh
docker run --rm --volume=/root/charles-l.github.io:/srv/jekyll -it jekyll/jekyll:3.8 jekyll build
