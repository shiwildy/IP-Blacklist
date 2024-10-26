#!/bin/bash
# =======================================================================================================
#
#  IP Blacklist is a Bash script designed to protect your server by blocking malicious IP addresses.
#  It works by fetching an updated list of harmful IPs from a GitHub repository and configuring your
#  server to drop packets from these IPs by routing them to a blackhole.
#
#  Version: 1.0.1
#  Author: Wildy Sheverando <hai@shiwildy.com>
#  This Project licensed under The MIT License
#
#  https://github.com/shiwildy/IP-Blacklist.git
#
# =======================================================================================================

if [[ $(whoami) != 'root' ]]; then
    echo "This script require root access."
    exit 1
fi

# >> Check required binaries
for requ in "wget" "ip" "route"; do
    if ! command -V $requ > /dev/null 2>&1; then
        echo "${requ} not installed, install it and try again."
        exit
    fi
done

# >> Create dirs & copy required files
rm -rf /usr/local/ip-blacklist > /dev/null 2>&1
mkdir -p /usr/local/ip-blacklist
cp update.sh /usr/local/ip-blacklist/update.sh
chmod 1700 /usr/local/ip-blacklist/update.sh

# >> Create cron to update database every day
sed -i '/# >> START IP-Blacklist database update/,/# >> END IP-Blacklist database update/d' /etc/crontab
echo '
# >> START IP-Blacklist database update
0 0 * * * root /usr/local/ip-blacklist/update.sh >/dev/null 2>&1
# >> END IP-Blacklist database update
' >> /etc/crontab

# >> Updating database
/bin/bash /usr/local/ip-blacklist/update.sh

# >> Done
echo "Installation successfuly"