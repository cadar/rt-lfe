#!/bin/bash
clear
make && make test 
echo

inotifywait -m -e close_write *.lfe | while read f; do
    file=$(echo "$f" | cut -d' ' -f1)
    clear
    date
    make && make test 
done
