# Installing DNS

```
apt install dnsmasq
```

# Configuration
at /etc/dnsmasq.conf configure following snippet:

```
# Never forward plain names (without a dot or domain part)
domain-needed

server=1.1.1.1
server=8.8.8.8

# Add local-only domains here, queries in these domains are answered
# from /etc/hosts or DHCP only.
local=/home/
cache-size=5000
```

After that configure entries at /etc/hosts

Allow port 53 in UFW
```
ufw allow 53
```

# References
https://stevessmarthomeguide.com/home-network-dns-dnsmasq/