# Divi Smart Node
Get a Divi core node up and running on a Raspberry Pi from scratch. This procedure could work with any Raspberry, included new Pi 4B.

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
7. Configure your netowork to access Internet. If you are using an Ethernet connection, it should automatically get a IP Address. If you are using just wifi, you could use "sudo raspi-config" to configure it (2.Network Options/N2.Wi-fi). Then, "iwconfig" to check wi-fi, "ifconfig" to check network.
8. If you want to use SSH (PUTTY) to remotely connect to your Raspberry, you need to enable it through "sudo raspi-config" as well. (5.Interfacing Options/P2.SSH). I strongly suggest you to change User Password for the current too (1.Change User Password).
9. Before to download and configure Divi Core, I suggest you to update your Raspian packages with "sudo apt-get update" and "sudo apt-get dist-upgrade".
10. I suggest you to change swap file size too, modifying /etc/dphys-swapfile configuration file (putting a "#" in front to "CONF_SWAPSIZE=100" line, in order to comment it. Then, "sudo dphys-swapfile setup" and "sudo dphys-swapfile swapon". Check with "free" command.

# Download and install Divi core 1.0.4

1. Download Divi core 1.0.4:
  a. cd; wget https://github.com/DiviProject/divi-smart-node/releases/download/v1.0.4-rpi/divi-1.0.4-RPi2.tar.gz
2. Unpack tarball; your executables will go in /home/pi/divi-1.0.4/bin
  a. tar xvf divi-1.0.4-RPi2.tar.gz
3. I suggest you to define some useful alias to make things simpler. You can add them to ~/.bash_aliases, and load them with "source ~/.bash_aliases":
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
alias diviuserdelete="sudo rm -rf ~/.divi/backups ~/.divi/divi.conf ~/.divi/masternode.conf ~/.divi/mnpayments.dat ~/.divi/wallet.da
t"
alias diviclearcache="sudo rm -rf ~/.divi/blocks ~/.divi/chainstate ~/.divi/database ~/.divi/zerocoin ~/.divi/.lock ~/.divi/db.log ~
/.divi/debug.log ~/.divi/fee_estimates.dat ~/.divi/mncache.dat ~/.divi/netfulfilled.dat ~/.divi/peers.dat ~/.divi/sporks"
alias divirefresh="~/divi-1.0.4/bin/divid -reindex"
alias divirescan="~/divi-1.0.4/bin/divid -rescan"
alias ll='ls -la'
  

  a. "cd
4. On boot, you will be prompted to enter an RPC username, type one of your choosing and press `ENTER`.
5. The node will configure itself and begin to sync automatically, use the node as usual via the command line.

For more information on CLI commands, see our [wiki page](https://wiki.diviproject.org/#divi-cli)

# Filepaths

### Autostart Configuration

The autostart configuration can be found at `~/.config/lxsession/LXDE-pi/autostart`

* Scripts will be run at startup using the autostart file
* Always keep scripts above the `@xscreensaver -no-splash` line

### Divi Config Script (first run)

This process is automated and does not require any user input. The divi daemon (`divid`) is run at the system level as a service. 

A script called `divisetup-run.sh` will run the first time the image is booted. It is located at `/home/pi/divisetup-run.sh` and performs the following actions:

* Searches the `.divi` data directory for `divi.conf`
* Randomly generates an rpc username & password using the SHA256 hashing algorithm and writes it to `divi.conf`
* Writes `daemon=0` to the `divi.conf` file
* Renames `divisetup-run.sh` to `divisetup-complete.sh`
* Starts `divid.service`
*If `~/.divi/divi.conf` exists already, only the final step will run.*

### Divi Config Script (subsequent runs)

After the initial setup, a script named `divi-startup.sh` runs on boot. It is located at `/home/pi/divi-startup.sh` and performs the following actions:

* Checks for `divisetup-complete.sh`
* If not found, runs `divisetup-run.sh`

### Divi Shutdown Script

**Note: Shutdown script has not been confirmed as working and should be considered a known issue.**

# Aliases

Several bash aliases are present in the root directory's `.bash_aliases` file. 

| ALIAS | FUNCTION  |
| ---   | ---       |
| `aliasfile`       | opens the alias file for editing  |
| `aliasreload`     | reloads the shell                 |
| `sweep`           | deletes `.bash_history` and closes the terminal |
| `init-divi-conf`  | resets `divisetup-run.sh` to reconfigure `divid` on next boot |
| `dli`             | alias for `./divi-cli`. Run any `divi-cli` command with `dli <command>` |
| `dividebug`       | tails the debug log |
| `divistart`       | starts `./divid`  |
| `diviservicestart`| starts the `divid.service` system service |
| `diviservicestop` | stops `divid.service` |
| `diviservicestatus`| prints the `divid.service` status for debugging |
| `diviclearcache`  | removes unnecessary data directory files |
| `divirefresh`     | starts `./divid` with the `-reindex` flag |
| `divirescan`      | starts `./divid` with the `-rescan` flag |
| `dividir`         | quick access to the `DIVI` directory  |
| `datadir`         | quick access tho the Divi data directory where config files, etc. are found | 
| `diviuserdelete`  | **DANGER:** This command removes all user-specific files, including `wallet.dat`. Use with extreme caution|




# FAQ

Q. Can I run a masternode on a Raspberry Pi?

A. Yes, see our [wiki page](https://wiki.diviproject.org/#masternode-setup-guide) for instructions.

Q. Can I use this Raspbian image as a "stake box?"

A. Yes, just be sure to back up your mnemonic seed phrase in case of SD card errors or any other issues.
