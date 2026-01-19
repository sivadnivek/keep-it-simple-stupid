#!/bin/bash

# prolly have to run as root because of ipset or do something else with perms
# ideas for how to bl things here using ipset--- not yet completed

# ip regex to use var instead of obnoxious long ip regex thingy
BLIP="[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"

# get the ips from the list of hostnames
for i in ~/blip/hostnamestobl.txt; do dig +short "$i" | grep -oP "$BLIP" >> ~/blip/masterlist.ip ; done ;

# dedupe the master list against what's already in ipset list
ipset list blocklist > ~/blip/ipsetblocklist.ip; diff masterlist.ip ipsetblocklist.ip | grep \> > deduped.txt;
sed -i 's/> //g' deduped.txt;

# add what's left to the blocklist
while read yip; do ipset add blocklist $yip; done < ~/blip/deduped.txt 

# make sure you didn't block your own ip (or list of ips?)
curl zx2c4.com/ip | grep -oP $BLIP > ~/blip/myip?s.now;

if [ (ipset list | grep ~/blip/myip.now) -ge 1 ] then # still not sure if this part works

ipset del blocklist ~/blip/myip.now

else

done ;

# maybe include an option to explicitly unblock some ips after checking for them?
# please be aware that there may be a compatibility issue with the other related script i have on here
# i think in that one i named the blocklist blacklist
# fuck i balmer peaked and burned the bacon i was cooking to help with my hangover
# house full of smoke
