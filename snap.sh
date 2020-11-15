#!/bin/bash
#
filename=DIVI-snapshot-`date +%F`.tar.gz
wget -O $filename https://snapshots.diviproject.org/dist/DIVI-snapshot.tar.gz
read -p "You are going to replace *all* blockchain data... are you absolutely sure? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
        ~/divi-1.1.2/bin/divi-cli stop
        echo -n "Waiting for divid closing"
        while /usr/bin/pgrep divid >/dev/null; do
                sleep 1
                echo -n "."
        done
        echo -e "\nRemoving old directories..."
        rm -fr ~/.divi/blocks
        rm -fr ~/.divi/chainstate
        echo "Untar new snapshot..."
        tar xvf $filename
        echo "Starting divid..."
        ~/divi-1.1.2/bin/divid
        echo "End of job!"
fi
exit 0
