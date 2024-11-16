```
   _  __ ____ _  __ ___    ____  __ ____   ____ ___ 
  / |/ // __/| |/_// _ |  / /\ \/ //_  /  / __// _ \
 /    // _/ _>  < / __ | / /__\  /  / /_ / _/ / , _/
/_/|_//___//_/|_|/_/ |_|/____//_/  /___//___//_/|_| 
                                                    
```

# Nexalyzer v0.0.2

    This tool helps to gather the subdomains and the DNS records of all the active subdomains under the given domain
    Added directory bruteforcing option for active domains

## Requirements:

    This tool downloads necessary tools for search and downloads them for debian based linux OS [like kali, ubuntu, fedora, parrot]
    For Windows and other operating systems you have to install these tools manually and then try for this tool to work
    
    - subfinder
    - httpx
    - dig 
    - gobuster

## USAGE:
    ``` ./nexalyzer.sh [domain_name] ``` 

## Features:
    
    Subdomain Enumeration:
    - Checks for all the subdomains
    - Seperates up the active subdomain from the available subdomains

    Domain Records for active domains:
    - A record
    - AAAA record
    - CNAME record
    - CAA record
    - HINFO record
    - TXT record
    - MX record
    - SOA record

    Additional Feature:
    - Directory bruteforcing for active domains

## Built By:
    Mohamed Haneef R    
