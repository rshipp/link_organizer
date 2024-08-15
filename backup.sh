#!/bin/bash

mkdir -p backups/sql
sqlite3 storage/development.sqlite3 .dump > backups/sql/development.sql
cd backups/sql
[ -d .git ] || git init
git add development.sql
git commit -m 'backup'
