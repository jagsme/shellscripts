#!/bin/sh

# Script Name: apicommands.sh
# Author: Jagdish Mehra.
# Date Created: 21/11/2016


# Purpose: To automate running of various Jmeter scripts and generate HTML report using ANT command and publish the same to the public URL 
#          This script will run from root/apache-jmeter-3.0/bin/ folder location and  take 3 command line parameters as input and throw 
#          proper error messages if any input is not proper.
#          script runs as folllows:-
#          /apache-jmeter-3.0/bin# source apicommands.sh {jmeter script name short form} {no. of users} {round no.}
#      e.g /apache-jmeter-3.0/bin# source apicommands.sh tri 100 1




# If less than 3 arguments exit
if [ $# -lt 3 ]
  then
    echo "Please pass 3 arguments (API) (Users) (Round)"
    exit 1
fi

# Get current system date and perform date string formatting
date=`date +%Y%m%d%H%M`
datenew=${date:0:8}-${date:8}

# Mapping of Jmeter script short form taken as user input with actual Jmeter script names
case $1 in
        tri)
                API='TechincalReport_iOS'
                ;;
        tra)
                API='TechnicalReport_Android'
                ;;
        aai)
                API='AddApp_iOS'
                ;;
        aaa)
                API='AddApp_Android'
                ;;
        aca)
                API='AppCompare_Android'
                ;;
        aci)
                API='AppCompare_iOS'
                ;;
        daa)
                API='DeleteApp_Android'
                ;;
        dai)
                API='DeleteApp_iOS'
                ;;
        gpa)
                API='GeneratePDF_Android'
                ;;
        gpi)
                API='GeneratePDF_iOS'
                ;;
        sa)
                API='Status_Android'
                ;;
        si)
                API='Status_iOS'
                ;;
         *)
                echo "Sorry, input is not proper! Please pass 3 arguments (API) (Users) (Round) :-
              Enter API as follows 
                tri = TechnnicalReport_iOS Api 
                tra = TechnicalReport_Android Api	
                aai = AddApp_Android Api
                aaa = AddApp_iOS Api 
                aca = AppCompare_Android Api	
                aci = AppCompare_iOS Api
                daa = DeleteApp_Android Api 
                dai = DeleteApp_iOS Api	
                gpa = GeneratePDF_Android Api
                gpi = GeneratePDF_iOS Api 
                sa =  Status_Android Api	
                si = Status_iOS Api"
                exit 1
                ;;


esac

#Generating file name and directory path string from user input
filename=/root/reports/jtl/$2/$API-$datenew-$2-round$3
filenamelog=/root/reports/logs/$2/$API-$datenew-$2-round$3

#Executing Jmeter command after generating proper file path and directory struture from user input

./jmeter -n -t $API.jmx -Jusers=$2 -l $filename.jtl -j $filenamelog.txt

#Writing the Jmeter command to apicomds.txt file
mycommand="./jmeter -n -t $API.jmx -Jusers=$2 -l $filename.jtl -j $filename-log.txt"
echo $mycommand >>apicomds.txt

#Generating ANT command from input parameters

string1=${mycommand#*-l }
string2=${string1%.jtl*}
string3=${string2%/*}
INPUT=$string2
SUBSTRING=$(echo $INPUT| cut -d'/' -f 6)


# ANT command created and written in file antcommand.txt 
echo ant -Dtestpath=$string3 -Dtest=$SUBSTRING report >> antcommand.txt

# Changing directories from /bin to /extras
cd ../extras/

# Running  ANT command in the extras folder to generate HTML report
ant -Dtestpath=$string3 -Dtest=$SUBSTRING report

# Running ANT command to generate Request Response in HTML report from build1.xml file
ant -f build1.xml -Dtestpath=$string3 -Dtest=$SUBSTRING report

# Copying HTML report to public location
cp $filename.html /var/www/html/reports/$2/

# Copying detailed HTML report to public location
cp $filename-reqresponse.html /var/www/html/reports/$2/

# Moving HTML report from JTL folder to HTML folder 
mv $filename.html /root/reports/html/$2/

# Moving detailed HTML report from JTL folder to HTML folder 
mv $filename-reqresponse.html /root/reports/html/$2/

# Changing the directory back to /bin 
cd ../bin/

