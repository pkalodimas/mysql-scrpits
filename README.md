# mysql-scrpits
This repository contains scripts for backing up and restore MySQL databases.
It is using the mysqldump tool and the linux sed to apply exported scripts cleanup

- mysql-import.sh file is running sql files in the sql server

- mysql-export-schema.sh is using the mysqldump tool to export the database schema backup file and cleans it (so it does not fail when restored) by:
  - Removes the schema prefix from tables
  - Removes Definers from routines, triggers, etc
  - Removes auto-increment from tables
  - Removes variables sets that added by mysqldumpl
  - Removes comments added by mysqldump
  - Adds command to disable foreign keys checks at the beginning of the script.

- mysql-export-data.sh is using the mysqldump tool to export the database schema backup file and cleans it (so it does not fail when restored) by:
  - Removes variables sets that added by mysqldumpl
  - Removes comments added by mysqldump
  - Adds command to disable foreign keys checks at the beginning of the script.
