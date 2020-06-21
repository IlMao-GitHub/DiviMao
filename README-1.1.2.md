# Divi Smart Node
This procedure should helps to update our Divi Core, in this case from 1.0.8 to 1.1.2. If you need to install it from scratch you can use the procedure I wrote for 1.0.8 located [here](https://github.com/IlMao-GitHub/DiviMao/blob/master/README-1.0.8.md). This procedure should work with any Raspberry, though due to memory contrains a Pi 4B with 4 GB is highly recommended. 

# System requirements
I'm using a Raspberry Pi 4B with a 32GB Class 10 microSD card and 4GB of RAM.
I'm supposing that you have used my previous guide to install your Divi Core, so you have defined my suggested aliases.
**Note: While no issues have been found with this implementation, this software is considered to be in an Alpha stage. Use at your own risk and *always* back up your mnemonic seed phrase before transacting with any real funds**

# Download and configure Divi core 1.1.2

1. Download Divi core 1.1.2: `cd; wget https://github.com/DiviProject/Divi/releases/download/v1.1.2/divi-1.1.2-RPi2.tar.gz`
2. Unpack tarball: `tar xvf divi-1.1.2-RPi2.tar.gz`. Your executables will go in /home/pi/divi-1.1.2/bin. 
3. Stop your divid process: `dli stop`
4. Wait for shutdown. You can check the process using `dividebug` alias; wait for `Shutdown: done` message. CTRL-C to exit.
5. Update your aliases to reflect new release. If you have used my 1.0.8 guide, you could use following aliases. You can update your ~/.bash_aliases, and load them with `source ~/.bash_aliases`; in vi, you can use the following command to replace all release occurences: `:%s/1.0.8/1.1.2/g`. Use nano to edit the file if you feel more comfortable with it:  
```
# System
alias aliasfile="sudo nano ~/.bash_aliases"
alias aliasreload="source ~/.bash_aliases"
alias sweep="cat /dev/null > ~/.bash_history && history -c && exit"

# Divi
alias init-divi-conf="mv ~/divisetup-complete.sh ~/divisetup-run.sh"
alias dli="~/divi-1.1.2/bin/divi-cli"
alias dividebug="sudo tail -f ~/.divi/debug.log"
alias divistart="~/divi-1.1.2/bin/divid"
alias dividir="cd ~/divi-1.1.2/bin"
alias datadir="cd ~/.divi"
alias diviuserdelete="sudo rm -rf ~/.divi/backups ~/.divi/divi.conf ~/.divi/masternode.conf ~/.divi/mnpayments.dat ~/.divi/wallet.da
t"
alias diviclearcache="sudo rm -rf ~/.divi/blocks ~/.divi/chainstate ~/.divi/database ~/.divi/zerocoin ~/.divi/.lock ~/.divi/db.log ~
/.divi/debug.log ~/.divi/fee_estimates.dat ~/.divi/mncache.dat ~/.divi/netfulfilled.dat ~/.divi/peers.dat ~/.divi/sporks"
alias divirefresh="~/divi-1.1.2/bin/divid -reindex"
alias divirescan="~/divi-1.1.2/bin/divid -rescan"
alias ll='ls -la'
```
For an alias description, please refer to official [github page](https://github.com/DiviProject/divi-smart-node).

6. Restart divid again: `divistart`. It should show "DIVI server starting", and sync should start. You can monitor advance of sync through commands `dli getinfo` (blocks must reach the highest block in blockchain, syncing blocks generated during the shutdown), or `dli mnsync status`, where IsBlockchainSynced must be true, RequestMasternodeAssets must be 999 and RequestMasternodeAttempt must be 0. This could takes some minutes to hours, depending of your networks and how much time you had divid stopped.
7. Don't forget to update your /etc/rc.local, if you want to run divid at boot:
```
su pi -c '/home/pi/divi-1.1.2/bin/divid -daemon -pid=/home/pi/.divi/divid.pid -conf=/home/pi/.divi/divi.conf -datadir=/home/pi/.divi'
```

For further information, please refer to the official pages on [Divi Project Wiki](https://wiki.diviproject.org/).
