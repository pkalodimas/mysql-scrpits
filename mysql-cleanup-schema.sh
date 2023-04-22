#!/bin/bash
## The command below echoes in the screen all the commands
##set -x

############# Input parameters (Can set default values)
database=""
sqlfile=""


############# Read arguments 
## arg1 is database name
if [ $# -ge 1 ]
then
  database=$1
fi
if [ -z "$database" ]
then
  echo "missing database argument please execute \"script [database name] [sql export file]\""
  exit 0
fi
## arg2 is sql file (Optional)
if [ $# -ge 2 ]
then
  sqlfile=$2
fi
if [ -z "$sqlfile" ]
then
  echo "missing sql file argument please execute \"script [database name] [sql clean file]\""
  exit 0
fi

################ Show user script configuration
echo ""
echo "You are about to cleanup the database $database schema sql file with the following configuration:"
echo ""
echo "Schema: $database"
echo "SQL File: $sqlfile"
echo ""

while true; do
    read -p "Are you sure (Y/N)?" answer
    case $answer in
        [Yy]* ) break;;
        [Nn]* ) exit 0;;
        * ) echo "Please enter 'Y' for Yes or 'N' for No.";;
    esac
done

############### Run Command

# Remove database prefix on tables
schemaPrefixRegex="s/\`$database\`\.//g"
sed -i -e "$schemaPrefixRegex" $sqlfile

# Remove definers from routines, etc
definerRegex_1="s/\/\*![0-9]* DEFINER=[^\*]*\*\///g"
definerRegex_2="s/DEFINER=\`[^@]*\`@\`[^\`]*\`//g"
sed -i -e "$definerRegex_1" -e "$definerRegex_2" $sqlfile

# Remove AUTO_INCREMENT
autoIncrementRegex="s/AUTO_INCREMENT=[0-9]*//g"
sed -i -e "$autoIncrementRegex" $sqlfile

# Remove variables SET
setRegex_1="/SET @@.*/d"
setRegex_2="/SET @MYSQLDUMP.*/d"
setRegex_3="/\/\*![0-9]* SET[^;]*;/d"
setRegex_4="/\/\*![0-9]* SET[^;]*;;/d"
sed -i -e "$setRegex_1" -e "$setRegex_2" -e "$setRegex_3" -e "$setRegex_4" $sqlfile

echo "Database schema $database cleanup completed"


