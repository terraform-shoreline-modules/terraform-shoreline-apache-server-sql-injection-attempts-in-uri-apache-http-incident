

#!/bin/bash



# Define variables

RULE_ID=${MODSECURITY_RULE_ID}

RULE_SET_FILE=${MODSECURITY_RULESET_FILE}

SQL_INJECTION_PATTERN=${REGEX_PATTERN_TO_MATCH_SQL_INJECTION}



# Check if ModSecurity is installed

if [[ $(which modsecurity-crs) ]]; then

  # Create or modify ModSecurity rule to prevent SQL injection attacks

  echo "Creating/modifying ModSecurity rule to prevent SQL injection attacks"

  echo "SecRule ARGS \"$SQL_INJECTION_PATTERN\" \"id:$RULE_ID,deny,status:400,msg:'SQL injection attempt detected'\"" >> $RULE_SET_FILE



  # Restart Apache web server to apply changes

  echo "Restarting Apache web server"

  systemctl restart apache2

else

  echo "ModSecurity is not installed. Please install ModSecurity before running this script."

  exit 1

fi