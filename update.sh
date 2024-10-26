#!/bin/bash
# =======================================================================================================
#
#  Part of https://github.com/shiwildy/IP-Blacklist
#
#  Version: 1.0.1
#  Author: Wildy Sheverando <hai@shiwildy.com>
#  This Project licensed under The MIT License
#
# =======================================================================================================

# >> Check required binaries
for requ in "wget" "ip" "route"; do
    if ! command -V $requ > /dev/null 2>&1; then
        echo "$(date +"%H:%M:%S | %Y-%m-%d") | ERROR: update failed, ${requ} not installed" >> /usr/local/ip-blacklist/ip-blacklist.log
        exit
    fi
done

# >> Remove all blacklist
echo > /usr/local/ip-blacklist/blacklist.all
echo > /usr/local/ip-blacklist/blacklist.4
echo > /usr/local/ip-blacklist/blacklist.6

# >> Download new blacklist
wget -4 --no-check-certificate -q --header="Cache-Control: no-cache" -O /usr/local/ip-blacklist/blacklist.conf "https://raw.githubusercontent.com/shiwildy/IP-Blacklist/main/data/blacklist.conf"

function updaterecord() {
    cat /usr/local/ip-blacklist/blacklist.conf | awk '{print $1, $2}' > /usr/local/ip-blacklist/blacklist.all
    while IFS= read -r line; do
        cidr="$(echo $line | awk '{print $1}')"
        ipver="$(echo $line | awk '{print $2}')"
        if [[ $ipver == '4' ]]; then
            echo $cidr >> /usr/local/ip-blacklist/blacklist.4
        else
            echo $cidr >> /usr/local/ip-blacklist/blacklist.6
        fi
    done < /usr/local/ip-blacklist/blacklist.all
}

function delall() {
    for ips in $(ip -4 route | grep -w blackhole | awk '{print $2}'); do
        ip -4 route del "$ips"
    done
    for ips2 in $(ip -6 route | grep -w blackhole | awk '{print $2}'); do
        ip -6 route del "$ips2"
    done
}

function addnew() {
    for ips in $(cat /usr/local/ip-blacklist/blacklist.4); do
        ip -4 route add blackhole "$ips"
    done

    for ips2 in $(cat /usr/local/ip-blacklist/blacklist.6); do
        ip -6 route add blackhole "$ips2"
    done
}

updaterecord
delall
addnew

# >> Done
echo "$(date +"%H:%M:%S | %Y-%m-%d") | OKE: success update blacklist database" | tee -a /usr/local/ip-blacklist/ip-blacklist.log
