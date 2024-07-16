#!/bin/sh

set -u # Treat unset variables as an error.

exec /usr/bin/java \
  --module-path /openjfx/lib \
  --add-modules ALL-MODULE-PATH \
  -Dawt.useSystemAAFontSettings=gasp \
  -Djava.awt.headless=false \
  -XX:-UsePerfData \
  -jar /config/mcaselector.jar

# vim:ft=sh:ts=4:sw=4:et:sts=4
