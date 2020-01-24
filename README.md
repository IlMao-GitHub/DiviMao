# Divi Smart Node
Get a Divi core node up and running on a Raspberry Pi from scratch. This procedure should work with any Raspberry, including the new Pi 4B.

# System requirements
I'm using a Raspberry Pi 4B with a 32GB Class 10 microSD card and 4GB of RAM.

**Note: While no issues have been found with this implementation, this software is considered to be in an Alpha stage. Use at your own risk and *always* back up your mnemonic seed phrase before transacting with any real funds**

# Make your Raspbian working
1. [Download](https://downloads.raspberrypi.org/raspbian_lite_latest) the latest Raspbian Lite Image (just 433 MB download). There's no GUI in this image, I've choosen this one to make things simpler and quick as possible. You can always add stuff to your Raspbian later.
2. Extract img file from zip file (2.2 GB).
3. Use [SD Card Formatter](https://www.sdcard.org/downloads/formatter/) or similar software to format microSD Card.
4. Use [Win32 Disk Imager](https://sourceforge.net/projects/win32diskimager/files/latest/download) or similar software to flash the image to a microSD Card.
5. Insert the flashed microSD card into your Raspberry Pi 4B device and turn it on. Note: because I'm attached my Pi 4 to an old TV, I had to configure the file config.txt to make my old TV working. You can modify the file editing it even from Windows, accessing the "boot" partition on SD Card after flashing. In my specific case, I've changed hdmi_group=1 and hdmi_mode=4. This could help to fix other display problems too.
6. Login with default user "pi" and password "raspberry".
7. Configure your network to access Internet. If you are using an Ethernet connection, it should automatically get a IP Address through your DHCP. If you are using just wifi, you could use `sudo raspi-config` to configure it (2.Network Options/N2.Wi-fi). Then, `iwconfig` to check wi-fi, `ifconfig` to check network.
8. If you want to use SSH (PUTTY) to remotely connect to your Raspberry, you need to enable it through `sudo raspi-config` as well. (5.Interfacing Options/P2.SSH). I strongly suggest you to change User Password for the current user too (1.Change User Password).
9. Before to download and configure Divi Core, I suggest you to update your Raspian packages with `sudo apt-get update` and `sudo apt-get dist-upgrade`.
10. I suggest you to change swap file size too, modifying /etc/dphys-swapfile configuration file (putting a "#" in front to "CONF_SWAPSIZE=100" line, in order to comment it. Then, `sudo dphys-swapfile setup` and `sudo dphys-swapfile swapon`. Check with `free` command.

# Download and configure Divi core 1.0.4

1. Download Divi core 1.0.4: `cd; wget https://github.com/DiviProject/divi-smart-node/releases/download/v1.0.4-rpi/divi-1.0.4-RPi2.tar.gz`
2. Unpack tarball: `tar xvf divi-1.0.4-RPi2.tar.gz`. Your executables will go in /home/pi/divi-1.0.4/bin. 
3. I suggest you to define some useful alias to make things simpler. You can add them to ~/.bash_aliases, and load them with `source ~/.bash_aliases`:
```
# System
alias aliasfile="sudo nano ~/.bash_aliases"
alias aliasreload="source ~/.bash_aliases"
alias sweep="cat /dev/null > ~/.bash_history && history -c && exit"

# Divi
alias init-divi-conf="mv ~/divisetup-complete.sh ~/divisetup-run.sh"
alias dli="~/divi-1.0.4/bin/divi-cli"
alias dividebug="sudo tail -f ~/.divi/debug.log"
alias divistart="~/divi-1.0.4/bin/divid"
alias dividir="cd ~/divi-1.0.4/bin"
alias datadir="cd ~/.divi"
alias diviuserdelete="sudo rm -rf ~/.divi/backups ~/.divi/divi.conf ~/.divi/masternode.conf ~/.divi/mnpayments.dat ~/.divi/wallet.dat"
alias diviclearcache="sudo rm -rf ~/.divi/blocks ~/.divi/chainstate ~/.divi/database ~/.divi/zerocoin ~/.divi/.lock ~/.divi/db.log ~
/.divi/debug.log ~/.divi/fee_estimates.dat ~/.divi/mncache.dat ~/.divi/netfulfilled.dat ~/.divi/peers.dat ~/.divi/sporks"
alias divirefresh="~/divi-1.0.4/bin/divid -reindex"
alias divirescan="~/divi-1.0.4/bin/divid -rescan"
alias ll='ls -la'
```
For an alias description, please refer to official [github page](https://github.com/DiviProject/divi-smart-node).

4. At this point directory ~/.divi doesn't exist yet. To create all the structure, simply start divid, using the just defined alias: `divistart`.
5. Edit file /home/pi/.divi/divi.conf inserting in it the rpcuser and rpcpassword lines shown by divid output. Add line `daemon=1` at the end of the file. Example:
```
rpcuser=divirpc
rpcpassword=CA45HPtyYojothQWsvByNBVZupo3kCQum8FFWGZ1v5in
daemon=1
```
5. Start divid again: `divistart`. This time it should show "DIVI server starting", and sync should start. You can monitor advance of sync through commands `dli getinfo` (blocks must reach the highest block in blockchain), or `dli mnsync status`, where IsBlockchainSynced must be true, RequestMasternodeAssets must be 999 and RequestMasternodeAttempt must be 0. This could takes several hours, depending of your networks.
For further information, please refer to the official pages on [Divi Project Wiki](https://wiki.diviproject.org/).
