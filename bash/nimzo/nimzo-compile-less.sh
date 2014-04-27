#!/bin/sh

# Re-Compiles Less file.

cd ~/Repos/Nimzo/httpdocs
lessc public/dev/lib/app-less/app.less > public/min/lib/css/app.min.css -x