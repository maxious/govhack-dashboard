#!/bin/sh

##############################################################################
# This script will monitor the number of lines in a log file to determine the
# number of requests per second.
#
# Example usage:
# logmon -f 15 -i /var/www/http/access.log
#
# Author: Adam Franco
# Date: 2009-12-11
# License: http://www.gnu.org/copyleft/gpl.html GNU General Public License (GPL)
##############################################################################

usage="Usage: `basename $0` -f <frequency in seconds, min 1, default 60> -l <log file> -k <api key> -n <field name in api>"

# Set up options
while getopts ":l:f:k:n:" options; do
 case $options in
 l ) logFile=$OPTARG;;
 f ) frequency=$OPTARG;;
 k ) apikey=$OPTARG;;
 n ) apiname=$OPTARG;;
 \? ) echo -e $usage
  exit 1;;
 * ) echo -e $usage
  exit 1;;

 esac
done

# Test for logFile
if [  ! -n "$logFile" ]
then
 echo -e $usage
 exit 1
fi

# Test for frequency
if [  ! -n "$frequency" ]
then
 frequency=60
fi

# Test that frequency is an integer
if [  $frequency -eq $frequency 2> /dev/null ]
then
 :
else
 echo -e $usage
 exit 3
fi

# Test that frequency is an integer
if [  $frequency -lt 1 ]
then
 echo -e $usage
 exit 3
fi

if [ ! -e "$logFile" ]
then
 echo "$logFile does not exist."
 echo 
 echo -e $usage
 exit 2
fi

lastCount=`wc -l $logFile | sed 's/\([0-9]*\).*/\1/'`
while true
do
 newCount=`wc -l $logFile | sed 's/\([0-9]*\).*/\1/'`
 diff=$(( newCount - lastCount ))
 rate=$(echo "$diff / $frequency" |bc -l)
 echo $rate
curl -d '{ "auth_token": "$key", "current": $rate, "value": $rate }' http://direct.disclosurelo.gs:3030/widgets/$name
 lastCount=$newCount
 sleep $frequency
done
