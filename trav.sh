#!/bin/bash

depth()
{
treedepth=0
while [ $treedepth -lt $1 ]
do
echo -n " "
let treedepth++
done
}

traverse()
{
ls "$1" | while read i
do
depth $1
if [ -d "$1/$i" ]
then
output=$(du -bs --max-depth=0 "$1/$i")
echo "dir. | " $output
else
result=$(du -ab --max-depth=0 "$1/$i")
echo "file | " $result
fi
done
}

if [ -z "$1" ]
then
traverse . 0
else
traverse $1 0
fi
