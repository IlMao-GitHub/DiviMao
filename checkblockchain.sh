#!/bin/bash
explorer=https://blocks.divi.domains
echo Data from $explorer
printf -v difficulty '%f' `curl -s $explorer/api/getdifficulty`
echo Current difficulty: $difficulty
lastblock=`curl -s $explorer/api/getblockcount`
echo Last block: $lastblock
lastblockhash=`curl -s $explorer/api/getblockhash?index=$lastblock | sed -e 's/"//g'`
echo Last block hash: $lastblockhash

echo
echo Data from my blockchain:
printf -v my_difficulty '%f' `~/dividir/divi-cli getdifficulty`
echo Current difficulty: $my_difficulty
my_lastblock=`~/dividir/divi-cli getblockcount`
echo Last block: $my_lastblock
my_lastblockhash=`~/dividir/divi-cli getblockhash $my_lastblock`
echo Last block hash: $my_lastblockhash

echo
if [ $difficulty == $my_difficulty ] && [ $lastblock == $my_lastblock ] && [ $lastblockhash == $my_lastblockhash ]
then
        echo Everything is perfect, so lucky!
else
        echo Something is different, please check!
fi
