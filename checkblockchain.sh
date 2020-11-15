#!/bin/bash
explorer=https://blocks.divi.domains
echo Data from $explorer
difficulty=`curl -s $explorer/api/getdifficulty`
echo Current difficulty: $difficulty
lastblock=`curl -s $explorer/api/getblockcount`
echo Last block: $lastblock
lastblockhash=`curl -s $explorer/api/getblockhash?index=$lastblock | sed -e 's/"//g'`
echo Last block hash: $lastblockhash

echo
echo Data from my blockchain:
my_difficulty=`~/divi-1.1.2/bin/divi-cli getdifficulty`
echo Current difficulty: $my_difficulty
my_lastblock=`~/divi-1.1.2/bin/divi-cli getblockcount`
echo Last block: $my_lastblock
my_lastblockhash=`~/divi-1.1.2/bin/divi-cli getblockhash $my_lastblock`
echo Last block hash: $my_lastblockhash

echo
if [ $difficulty == $my_difficulty ] && [ $lastblock == $my_lastblock ] && [ $lastblockhash == $my_lastblockhash ]
then
        echo Everything is perfect, so lucky!
else
        echo Something is different, please check!
fi
