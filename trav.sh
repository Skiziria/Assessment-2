#!/bin/bash
#check the depth 
depth(){
treedepth=0
while [ $treedepth -lt $1 ]
do
echo -n " "
let treedepth++
done
}

traverse(){
#check if it's a file or a directory 
ls "$1" | while read i
do
depth $1
#if you can go deeper through this object than it's a directory else it's a file
if [ -d "$1/$i" ]
then
output=$(du -bs --max-depth=0 -h "$1/$i")
echo "dir. | " $output
else
result=$(du -ab --max-depth=0 -h "$1/$i")
echo "file | " $result
fi
done
}
#execute the traverse codes
if [ -z "$1" ]
then
traverse . 0
else
traverse $1 0
fi
