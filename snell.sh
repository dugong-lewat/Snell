#!/usr/bin/env bash

clear
rm -rf /snell/
rm -rf /etc/snell
rm -r /usr/local/bin/snell-server
rm -r /etc/systemd/system/snell.service
clear
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
mkdir /snell/
mkdir /etc/snell
IP=$(wget -qO- icanhazip.com);
SERVICE="/etc/systemd/system/snell.service"
CONF="/etc/snell/snell-server.conf"
echo " "
read -p "Masukan Port pilihan anda: " port
read -p "Masukan Password kesukaan anda: " password
echo "${port}" >> /snell/port
echo "${password}" >> /snell/password
sleep 1
clear
apt install unzip lolcat -y
wget --no-check-certificate -O snell.zip https://github.com/surge-networks/snell/releases/download/v3.0.1/snell-server-v3.0.1-linux-amd64.zip
unzip -o snell.zip
chmod +x snell-server
mv snell-server /usr/local/bin/
echo "[Unit]" >> ${SERVICE}
echo "Description=Snell Proxy Service" >> ${SERVICE}
echo "After=network.target" >> ${SERVICE}
echo " " >> ${SERVICE}
echo "[Service]" >> ${SERVICE}
echo "Type=simple" >> ${SERVICE}
echo "LimitNOFILE=32768" >> ${SERVICE}
echo "Type=simple" >> ${SERVICE}
echo "ExecStart=/usr/local/bin/snell-server -c /etc/snell/snell-server.conf" >>${SERVICE}
echo " " >>${SERVICE}
echo "[Install]" >>${SERVICE}
echo "WantedBy=multi-user.target" >>${SERVICE}
echo "[snell-server]" >>${CONF}
echo "listen = 0.0.0.0:${port}" >>${CONF}
echo "psk = ${password}" >>${CONF}
echo "obfs = tls" >>${CONF}
systemctl daemon-reload
systemctl restart snell
systemctl enable snell
systemctl start snell
sleep 1
clear
echo "=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•="
echo "|         Informasi Snell Server        |"
echo "=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•="
echo " "
echo "  ->> IP = ${IP}              " | lolcat
echo "  ->> PORT = ${port}          " | lolcat
echo "  ->> Password = ${password}  " | lolcat
echo "  ->> OBFS = TLS              " | lolcat
echo "=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•=•="
rm -f ./snell.sh
rm -f snell.zip
cd