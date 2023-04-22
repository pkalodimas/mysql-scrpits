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
  echo "missing database argument please execute \"script [database name] [sql import file]\"";
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


mysqlArgs="--user=$user --password=$password --host=$host --port=$port --protocol=tcp --default-character-set=utf8 --database=$database";

################ Show user script configuration
echo "";
echo "You are about to execute sql file on the database $database schema with the following configuration:";
echo "";
echo "Host: $host:$port ";
echo "Schema: $database";
echo "Username: $user ";
echo "Password: $password ";
echo "SQL File: $sqlfile";
echo "Mysql Arguments: $mysqlArgs";
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
mysql $mysqlArgs < $sqlfile;

echo "sql file import in database schema $database completed!";




