#!/bin/bash

function getmod {		#преобразует буквенное представление прав в цифрыш
L=$1
i=`expr index "$L" "r"`
j=`expr index "$L" "w"`
k=`expr index "$L" "x"`
let "i=i*4+j+k/3"
echo "$i"
}


CONF=config.conf

IFS=":"
while read FILE REST USER GROUP
     do echo $FILE
	chmod $(getmod ${REST:1:3})$(getmod ${REST:4:3})$(getmod ${REST:7:3}) $FILE
done < $CONF
