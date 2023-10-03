

#!/bin/bash



# Update package list

sudo apt-get update



# Upgrade Apache server to the latest stable version

sudo apt-get install apache2



# Restart Apache server

sudo systemctl restart apache2



echo "Apache server has been updated and patched to the latest stable version."