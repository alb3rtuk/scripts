#!/bin/sh

# Re-Compiles Less file.

cd ~/Repos/Nimzo/httpdocs

lessc public/dev/lib/app-less/app.less > public/min/lib/app-css/app.css
lessc public/dev/lib/app-less/app.less > public/min/lib/css/app.min.css -x