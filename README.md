
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Apache SQL Injection Attempts in URI Incident
---

This incident type refers to the detection of SQL injection attempts in Apache web server logs. SQL injection is a type of cyber attack that exploits vulnerabilities in web applications allowing attackers to execute malicious SQL statements. In this incident, attackers are attempting to inject SQL code into the URI (Uniform Resource Identifier) of an Apache web server, potentially compromising the server's security and exposing sensitive information.

### Parameters
```shell
export MODSECURITY_RULESET_FILE="PLACEHOLDER"

export MODSECURITY_RULE_ID="PLACEHOLDER"

export REGEX_PATTERN_TO_MATCH_SQL_INJECTION="PLACEHOLDER"
```

## Debug

### Show the last 100 lines of Apache access log
```shell
tail -n 100 /var/log/apache/access.log
```

### Show all unique IP addresses that accessed the server in the last 24 hours
```shell
grep "\[`date -d '24 hours ago' '+%d/%b/%Y:%H:%M'`\:" /var/log/apache/access.log | awk '{print $1}' | sort | uniq
```

### Show all GET requests with SQL injection attempts
```shell
grep -E "GET /.*\b(union|select|drop|insert|update)\b.*HTTP" /var/log/apache/access.log
```

### Show all POST requests with SQL injection attempts
```shell
grep -E "POST /.*\b(union|select|drop|insert|update)\b.*HTTP" /var/log/apache/access.log
```

### Show the Apache configuration file
```shell
cat /etc/apache2/apache2.conf
```

### Show all enabled Apache modules
```shell
apache2ctl -M
```

### Show all Apache virtual hosts
```shell
apache2ctl -S
```

### Show the Apache error log
```shell
tail -f /var/log/apache/error.log
```

## Repair

### Update and patch the Apache server to the latest stable version to prevent the exploitation of known vulnerabilities.
```shell


#!/bin/bash



# Update package list

sudo apt-get update



# Upgrade Apache server to the latest stable version

sudo apt-get install apache2



# Restart Apache server

sudo systemctl restart apache2



echo "Apache server has been updated and patched to the latest stable version."


```

### Create or Modify ModSecurity Rule to prevent SQL injection attacks.
```shell


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


```