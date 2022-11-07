#!/bin/bash
c=${1%/*}
mkdir /home/kali/Desktop/$c
echo directory created: $c
echo
echo now we will scan our private network devices:
#the SCAN function is built for scanning the private network area and log the avilable machines.
function SCAN()
{
nmap -sn $1 | grep report | awk '{print $NF}' | sed -e 's/(//g' -e 's/)//g' > /home/kali/Desktop/$c/nmap_discovery.txt ; cat /home/kali/Desktop/$c/nmap_discovery.txt ; echo
}

#NSE function are built for vulnerabilities scan from the exploitdb database site.

function NSE()
{
echo now we will run the nmap script engine for searching vulnerabilities in the aforementioned machines: ; echo ;
sudo nmap --script /usr/share/nmap/scripts/vulscan/ --script-args vulscandb=exploitdb.csv -sV -iL /home/kali/Desktop/$c/nmap_discovery.txt -O -o /home/kali/Desktop/$c/nmap_NSE.txt ; echo
}


#in the BRUTEFORCE function i will try to find weak passwords on the machines i been discovered earlier (the users file i created earlier with 

function BRUTEFORCE()
{
echo -e "\e[32mnow we will try to find weak passwords for servichyes with open ports in the aforementioned machines with hydra tool: :\e[0m" ; echo ;
hydra -L /home/kali/Desktop/users.txt -P /home/kali/Desktop/passwords.txt -M /home/kali/Desktop/$c/nmap_discovery.txt ftp > /home/kali/Desktop/$c/hydra_report.txt ; hydra -L /home/kali/Desktop/users.txt -P /home/kali/Desktop/passwords.txt -M /home/kali/Desktop/$c/nmap_discovery.txt ssh >> /home/kali/Desktop/$c/hydra_report.txt ; hydra -L /home/kali/Desktop/users.txt -P /home/kali/Desktop/passwords.txt -M /home/kali/Desktop/$c/nmap_discovery.txt postgres >> /home/kali/Desktop/$c/hydra_report.txt ; cat /home/kali/Desktop/$c/hydra_report.txt | grep login > hydra_passwords_log.txt ; echo
}

function LOG()
{
echo -e "\e[32mscript log results:\e[0m" ; echo ; cat /home/kali/Desktop/$c/nmap_discovery.txt > /home/kali/Desktop/$c/vuln_log.txt ; cat /home/kali/Desktop/$c/nmap_NSE.txt >> /home/kali/Desktop/$c/vuln_log.txt ; cat /home/kali/Desktop/$c/hydra_report.txt >> /home/kali/Desktop/$c/vuln_log.txt ; cat /home/kali/Desktop/$c/vuln_log.txt
}

SCAN $1
NSE
BRUTEFORCE
LOG


