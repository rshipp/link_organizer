#!/bin/bash

mkdir -p backups/sql
sqlite3 storage/development.sqlite3 '.dump "links" "tags" "links_tags"' > backups/sql/development.sql
cd backups/sql
[ -d .git ] || git init
git add development.sql
git commit -m 'backup'
