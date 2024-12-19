# !/bin/bash

# ----------------------------------------------------------------------------
# Copyright (c) 2024 Mohamed Haneef
#
# Licensed under the MIT License.
# You may obtain a copy of the License at
#
#     https://opensource.org/licenses/MIT
#
# This software is provided "as is", without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability, 
# fitness for a particular purpose, and noninfringement. In no event shall the 
# authors or copyright holders be liable for any claim, damages, or other 
# liability, whether in an action of contract, tort, or otherwise, arising from, 
# out of, or in connection with the software or the use or other dealings in the 
# software.
# ----------------------------------------------------------------------------
# External tools:
# ----------------------------------------------------------------------------
# Subfinder
# Httpx
# Dig
# Gobuster
# ----------------------------------------------------------------------------


# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BRIGHT_PURPLE='\033[1;35m'
ORANGE='\033[38;5;208m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' 
# Test tool

# Font styles
BOLD='\033[1m'
ITALIC='\033[3m'
UNDERLINE='\033[4m'
RESET='\033[0m'

echo -e "${BRIGHT_PURPLE}"

cat << "EOF"
   _  __ ____ _  __ ___    ____  __ ____   ____ ___ 
  / |/ // __/| |/_// _ |  / /\ \/ //_  /  / __// _ \
 /    // _/ _>  < / __ | / /__\  /  / /_ / _/ / , _/
/_/|_//___//_/|_|/_/ |_|/____//_/  /___//___//_/|_| 
                                                    
EOF

echo
echo -e "${NC}[${RED}${BOLD}VERSION${NC}]: ${GREEN}v0.0.2${NC}"  
echo
install_package_go() {
    INSTALL_DIR="/usr/local"
    GO_TOOLS="$HOME/go/bin"
    GO_URL="https://golang.org/dl/go1.21.1.linux-amd64.tar.gz" 
    GO_TAR="go1.21.1.linux-amd64.tar.gz"

    # Ensure that /usr/local exists and is writable
    if [ ! -d "$INSTALL_DIR" ]; then
        echo "Installation directory $INSTALL_DIR does not exist."
        exit 1
    fi

    echo -e "${CYAN}Installing Go..."
    echo
    sudo wget -q --show-progress "$GO_URL" -O "/tmp/$GO_TAR"

    # Check if the download was successful
    if [ $? -ne 0 ]; then
        echo "Failed to download Go tarball."
        exit 1
    fi

    # Extracting the tar file to '/usr/local'
    echo "Extracting Go tarball..."
    sudo tar -C "$INSTALL_DIR" -xzf "/tmp/$GO_TAR"

    # Clean up the tarball
    sudo rm -rf "/tmp/$GO_TAR"
}

function install_package_subfinder(){
    echo -e "${CYAN}Installing subfinder...${NC}"
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest > /dev/null 2>&1
    echo -e "${GREEN}Successfully installed subfinder...${NC}"
}

function install_package_httpx(){
    echo -e "${CYAN}Installing httpx...${NC}"
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest > /dev/null 2>&1
    echo -e "${GREEN}Successfully installed httpx...${NC}"
}

function install_package_dig(){
    echo -e "${CYAN}Installing dig...${NC}"
    sudo apt install dnsutils > /dev/null 2>&1
    echo -e "${GREEN}Successfully installed dig...${NC}" 
}

function install_package_gobuster(){   
    echo -e "${CYAN}Installing gobuster...${NC}"
    sudo apt install gobuster > /dev/null 2>&1
    echo -e "${GREEN}Successfully installed gobuster...${NC}" 
}

# Usage 
if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage${NC}: ./nexalyer.sh [domain_name]"
    exit 1
fi

missing_packages=()


# install_package_go
if command -v subfinder >/dev/null 2>&1; then
    echo -e "${BOLD}REQUIRED PACKAGE: ${GREEN}subfinder is installed ...${NC}"
else
    echo -e "${BOLD}REQUIRED PACKAGE: ${RED}subfinder is not installed.${NC}"
    missing_packages+=("subfinder")
fi

if command -v httpx >/dev/null 2>&1; then
    echo -e "${BOLD}REQUIRED PACKAGE: ${GREEN}httpx is installed ...${NC}"
else
    echo -e "${BOLD}REQUIRED PACKAGE: ${RED}httpx is not installed.${NC}"
    missing_packages+=("httpx")
fi

if command -v dig >/dev/null 2>&1; then
    echo -e "${BOLD}REQUIRED PACKAGE: ${GREEN}dig is installed ...${NC}"
else
    echo -e "${BOLD}REQUIRED PACKAGE: ${RED}dig is not installed.${NC}"
    missing_packages+=("dig")
fi

if command -v gobuster >/dev/null 2>&1; then
    echo -e "${BOLD}REQUIRED PACKAGE: ${GREEN}gobuster is installed ...${NC}"
else
    echo -e "${BOLD}REQUIRED PACKAGE: ${RED}gobuster is not installed.${NC}"
    missing_packages+=("gobuster")
fi

if [ "${#missing_packages[@]}" -eq 0 ]; then
    echo -e "${GREEN}All packages are present proceeding to search!"
else
    if command -v apt >/dev/null 2>&1; then
        echo -e "${YELLOW}Packages need to be installed"
        for modules in "${missing_packages[@]}"; do
            echo -e "${YELLOW}# ${RED}$modules${NC}"
        done
        echo -e "${BOLD}${YELLOW}Try this as root or You have to be admin to access this resource${NC}"
        echo -e "${BOLD}${YELLOW}If you are an admin You'll be asked to enter your password to set it as temporary PATH variable${NC}" 
        echo "Do you want to install these packages [Y/N]:"
        read install_permission

        install_permission=$(echo "$install_permission" | tr '[:lower:]' '[:upper:]')

        if [ "$install_permission" == "Y" ]; then
            if command -v go > /dev/null 2>&1; then 
                echo -e "${GREEN}Go is already installed.${NC}"

                # Adding PATH variables for subfinder and httpx
                echo 'export PATH="$PATH:/$HOME/go/bin"' >> ~/.bashrc
                export PATH="$PATH:/$HOME/go/bin"
            else 
                install_package_go

                # Adding PATH variables for go to ~/.bashrc
                echo 'export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"' >> ~/.bashrc
                export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
                echo -e "${GREEN}Go has been installed and PATH updated.${NC}"
            fi
            source ~/.bashrc

            for modules in "${missing_packages[@]}"; do
                func_name="install_package_${modules}"
                eval "${func_name}"
            done
        elif [ "$install_permission" == "N" ]; then
            echo -e "${RED}Installation aborted."
            exit 0
        else
            echo -e "${RED}Invalid input. Please enter 'Y' for Yes or 'N' for No. Process terminating.."
            exit 0
        fi
    else
        echo -e "${RED}Auto-installation available only for debian based OS. For other OS You need to install '${CYAN}subfinder${NC}' and '${CYAN}httpx${NC}' manually."
        exit 0
    fi
fi



# Check for the results folder and subfiles, if none present create them
availabledomains="./result/availabledomains.txt"
activedomains="./result/activedomains.txt"
domaininfo="./result/domaininfo.txt"

if [ ! -d "./result" ]; then
    echo "Creating './result'"
    mkdir ./result
fi

if [ ! -e "$availabledomains" ]; then
    echo "Creating './result/availabledomains.txt'"
    touch "$availabledomains"
fi

if [ ! -e "$activedomains" ]; then
    echo "Creating './result/activedomains.txt'"
    touch "$activedomains"
fi

if [ ! -e "$domaininfo" ]; then
    echo "Creating './result/domaininfo.txt'"
    touch "$domaininfo"
fi

# Check for all the available domains
echo -e "${BOLD}${BLUE}Checking for the available subdomains for: ${NC}${YELLOW}$1${NC}"
echo -e "${BOLD}${YELLOW}Please wait this may take a while..${NC}"
subfinder -d "$1" -silent > "$availabledomains"

# If the file 'availabledomains' is not empty then check for active domains
if [ -s "$availabledomains" ]; then
    echo -e "${GREEN}Got a list of subdomains${NC}"

    # Print the available domains
    echo
    echo -e "${BOLD}${CYAN}Available subdomains:${NC}"
    echo
    while IFS= read -r available_domain
    do
        echo -e "${MAGENTA}${available_domain}${NC}"
    done < "$availabledomains"
    echo
    echo -e "${BOLD}${GREEN}Checking for the active subdomains...${NC}"
    echo -e "${BOLD}${YELLOW}Please wait this may take a while..${NC}"
    httpx -l "$availabledomains" -o "$activedomains" -silent > /dev/null

    # If the file 'activedomains.txt' is not empty then check for active domains
    if [ -s "$activedomains" ]; then
        echo -e "${GREEN}Here's a list of active subdomains${NC}"
        echo
        echo -e "${BOLD}${CYAN}Active subdomains:${NC}"
        echo
        while IFS= read -r active_domain
        do
            echo -e "${MAGENTA}${active_domain}${NC}"
        done < "$activedomains"
    else
        echo -e "${BOLD}${RED}No active subdomains found. Terminating the process${NC}"
        exit 1
    fi
else
    echo -e "${BOLD}${RED}No available subdomains found. Terminating the process.${NC}"
    exit 1
fi

# Check the DNS records of all the active domains
while IFS= read -r domain
do
    domain=$(echo "$domain" | sed -e 's|https\?://||')

    a_record=$(dig "$domain" A +short)
    aaaa_record=$(dig "$domain" AAAA +short)
    cname_record=$(dig "$domain" CNAME +short)
    caa_record=$(dig "$domain" CAA +short)
    hinfo_record=$(dig "$domain" HINFO +short)
    txt_record=$(dig "$domain" TXT +short)
    mx_record=$(dig "$domain" MX +short)
    soa_record=$(dig "$domain" SOA +short)
    
    echo
    echo -e "${BOLD}${ORANGE}DNS records for subdomain: ${NC}${GREEN}$domain${NC}"
    echo    
    
    declare -A dns_records=(
        ["A record"]="$a_record"
        ["AAAA record"]="$aaaa_record"
        ["CNAME record"]="$cname_record"
        ["CAA record"]="$caa_record"
        ["HINFO record"]="$hinfo_record"
        ["TXT record"]="$txt_record"
        ["MX record"]="$mx_record"
        ["SOA record"]="$soa_record"
    )

    for record_name in "${!dns_records[@]}"; do
        record_value="${dns_records[$record_name]}"
        if [ -n "$record_value" ]; then
            echo -e "${BRIGHT_PURPLE}$record_name: ${NC}$record_value"
        fi
    done
done < "$activedomains"

while true; do
    echo
    echo -ne "${BRIGHT_PURPLE}Do you want to continue with Directory Bruteforcing ${YELLOW}[Y/N]:${YELLOW}"
    read -n 1 bruteforce_permission
    echo

    bruteforce_permission=$(echo "$bruteforce_permission" | tr '[:upper:]' '[:lower:]')

    if [[ "$bruteforce_permission" == "y" ]]; then
        echo -e "${GREEN}Starting Directory Brute-Forcing${NC}..."

        domains=()
        domains+=("$1")

        if [[ -f "$activedomains" ]]; then
            while IFS= read -r domain; do
                domains+=("$domain")
            done < "$activedomains"
        else
            echo -e "${RED}Error: File '$activedomains' does not exist!${NC}"
            exit 1
        fi

        i=1
        for domain in "${domains[@]}"; do
            echo -e "${MAGENTA}$i. $domain${NC}"
            i=$((i+1))
        done
        echo
        echo -e "${BOLD}${BLUE}Which of these do you want to Directory Bruteforce?"
        echo -ne "${YELLOW}Select from 1-$((i-1)):${NC}"  
        read -n 1 bruteforce_choice
        echo

        if [[ "$bruteforce_choice" -ge 1 && "$bruteforce_choice" -le $((i-1)) ]]; then
            selected_domain="${domains[$((bruteforce_choice-1))]}"
            echo -e "${CYAN}${BOLD}Directory Bruteforcing selected domain: ${GREEN}$selected_domain${NC}${RESET}"
            gobuster dir -u "$selected_domain" -w ./wordlist/wordlist.txt -t 200 -q  
        else
            echo -e "${RED}Invalid selection! Exiting.${NC}"
            exit 1
        fi
        exit 0;

    elif [[ "$bruteforce_permission" == "n" ]]; then
        echo -e "${RED}Exiting the process.${NC}"
        exit 0  

    else
        echo -e "${ORANGE}Invalid option, please enter 'Y' or 'N'.${NC}"
    fi
done
