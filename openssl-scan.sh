#!/bin/bash -       
# ==============================================================================
# Title           : openssl-scan.sh
# Description     : This script will check the version of openSSL 3.x 
# Author          : Julien Mousqueton @JMousqueton
# Date            : 2022-11-01
# Version         : 1.0
# Licences        : GNU 3.0    
# Usage	      	  : bash openssl-scan.sh 
# ==============================================================================

# set the directory to search for OpenSSL libraries in (default: /)
search_directory=/

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow


############################################################
# Check if Binutils is installed                            #
############################################################
Openssl_check ()
{
  echo "Checking for binutils ..."
  if command -v strings > /dev/null; then
    echo "Detected strings..."
  else
    if [[ $OSTYPE == 'darwin'* ]]; then 
        echoerr "MacOS : you should check manually if openssl is installed" 
        exit 3
    else
      echo "Installing openssl..."
      sudo apt-get install -q -y openssl
      if [ "$?" -ne "0" ]; then
        echoe "Unable to install openssl ! Your base system has a problem; please check your default OS's package repositories because openssl should work."
        echoe "Repository installation aborted."
        exit 3
      fi
    fi
  fi
}

############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Check OpenSSL Version."
   echo
   echo "Syntax: openssl-scan.sh [-o|-h]"
   echo "options:"
   echo -e "-o     Only vulnerable versions."
   echo -e "-h     Print this Help."
   echo
}

############################################################
# Main                                                     #
############################################################
regex="^OpenSSL\s*[0-9].[0-9].[0-9]"
# Get the options
while getopts ":h:o" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      o) # only vulnerable
         regex="^OpenSSL\s*3.0.[0-6]";;
      v) # Verbose mode 
         Verbose="true";;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit 22;;
   esac
done

for file_name in $(find $search_directory -type f -name "libcrypto*.so*" -o -name “libssl*.so*” -o -name “libssl*.a* -o -name “libcrypto*.a*); do
        openssl_version=$( strings $file_name | grep $regex)
        if [[ $openssl_version ]]; then
            echo  $openssl_version - $file_name
        fi
    done