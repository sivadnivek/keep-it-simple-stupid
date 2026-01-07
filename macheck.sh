#!/bin/bash

macaddr=$(arp -a | cut -d ' ' -f 4 | uniq -d);

echo $macaddr;
