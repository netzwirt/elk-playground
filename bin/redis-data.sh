#!/bin/bash

list=`echo {0..9} {a..f}`

val=`date`
for c1 in $list ; do
    for c2 in $list ; do
        for c3 in $list ; do
            key=${c1}${c2}${c3}
            echo -n "."
            redis-cli set $key "$val" > /dev/null
        done
    done
done
echo "done"

