#!/bin/bash

xinput list | grep 'Finger touch' | cut -f 2 | cut -d '=' -f 2 | xargs xinput disable;

#done
