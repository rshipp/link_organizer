#!/bin/bash

sqlite3 storage/development.sqlite3 .dump > backups/sql/development.sql
cd backups/sql
git add development.sql
git commit -m 'backup'
