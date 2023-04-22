#!/bin/bash
## The command below echoes in the screen all the commands
##set -x

############# Settings
host=localhost
port=3306
user=root
password=root

############# Input parameters (Can set default values)
database="";
sqlfile="";


############# Read arguments
## arg1 is database name
if [ $# -ge 1 ]
then
  database=$1;
fi
if [ -z "$database" ]
then
  echo "missing database argument please execute \"script [database name] [sql export file]\"";
  exit 0;
fi
## arg2 is export sql file (Optional)
if [ $# -ge 2 ]
then
  sqlfile=$2;
fi
if [ -z "$sqlfile" ]
then
  sqlfile="$database-data.sql";
fi


mysqldumpArgs="--user=$user --password=$password --host=$host --port=$port --protocol=tcp 
--default-character-set=utf8 --tz-utc --complete-insert=TRUE --add-locks=FALSE --single-transaction=TRUE --no-create-info=TRUE --lock-tables=FALSE 
--skip-triggers --disable-keys  $database";

################ Show user script configuration
echo "";
echo "You are about to export the database $database data with the following configuration:";
echo "";
echo "Host: $host:$port ";
echo "Schema: $database";
echo "Username: $user ";
echo "Password: $password ";
echo "Exclude Tables:$ignoreTablesString ";
echo "Export File: $sqlfile";
echo "Mysqldump Command: $mysqldumpArgs";
echo "";

while true; do
    read -p "Are you sure (Y/N)?" answer
    case $answer in
        [Yy]* ) break;;
        [Nn]* ) exit 0;;
        * ) echo "Please enter 'Y' for Yes or 'N' for No.";;
    esac
done


############### Run Command
mysqldump $mysqldumpArgs > $sqlfile

# Remove variables SET
setRegex_1="/SET @@.*/d"
setRegex_2="/SET @MYSQLDUMP.*/d"
setRegex_3="/SET @MYSQLDUMP.*/d"
setRegex_4="/\/\*![0-9]* SET[^;]*;/d"
setRegex_5="/\/\*![0-9]* SET[^;]*;;/d"
sed -i -e "$setRegex_1" -e "$setRegex_2" -e "$setRegex_3" -e "$setRegex_4" -e "$setRegex_5" $sqlfile

# Remove comments
commentRegex="/^--.*$/d"
sed -i -e "$commentRegex" $sqlfile

# Disable foreign keys checks
sed -i "1s/^/SET FOREIGN_KEY_CHECKS=0; \nSET TIME_ZONE='+00:00'; /" $sqlfile


echo "Database $database data export completed";

