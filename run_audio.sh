#!/bin/bash
sudo pmset -a sleep 0; sudo pmset -a disablesleep 1
set -a
source .env
python3 data_fetcher.py &
cd audio/
/Applications/SuperCollider.app/Contents/MacOS/sclang run.scd

