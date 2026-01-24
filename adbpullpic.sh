#!/bin/bash

### adb pull pictures script
mkdir DCIM;
cd DCIM;
adb shell ls /storage/self/primary/DCIM/Camera/ > pullist.txt;

while read dabad ; do adb pull /storage/self/primary/DCIM/Camera/$dabad ; done < "$PWD"/pullist.txt
