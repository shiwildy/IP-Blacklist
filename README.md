# IP Blacklist
IP Blacklist is a Bash script designed to protect your server by blocking malicious IP addresses. It works by fetching an updated list of harmful IPs from a GitHub repository and configuring your server to drop packets from these IPs by routing them to a blackhole.

## Features
- **Automatic IP Blocking**: Blocks incoming traffic from blacklisted IP addresses by routing them to a blackhole.
- **Daily Updates**: Fetches and updates the list of blacklisted IP addresses every day from a GitHub repository.
- **Simple Configuration**: Easy setup and management with a straightforward configuration file.

## Installation
```bash
git clone https://github.com/shiwildy/IP-Blacklist.git
cd IP-Blacklist
bash setup.sh
```

## How It Works
+ The script fetches the list of blacklisted IPs from the specified GitHub repository.
+ It parses the list and updates your server’s routing rules to direct packets from these IPs to a blackhole.
+ The script runs every day to ensure the blacklist is up-to-date.

## Contributing
Contributions are welcome! If you’d like to contribute to the project

## Contact
For any questions or support, please open an issue on the GitHub repository or contact hai@shiwildy.com
