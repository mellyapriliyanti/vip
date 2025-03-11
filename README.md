### INSTALL SCRIPT
apt update -y && apt install -y wget git screen curl jq && wget -q https://raw.githubusercontent.com/FaturRoh2112/vip/main/setup.sh && chmod +x setup.sh && screen -S install ./setup.sh

### UPDATE SCRIPT
wget -q https://raw.githubusercontent.com/FaturRoh2112/vip/main/menu/update.sh && chmod +x update.sh && ./update.sh
