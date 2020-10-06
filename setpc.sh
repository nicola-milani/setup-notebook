#!/bin/bash
function message()
{
    local MSG="$1"
    echo -e "\e[32m$MSG\e[39m"
}

function error_message()
{
    local MSG="$1"
    echo -e "\e[31m$MSG\e[39m"
}

message "Update repositories..."
apt-get update
if [ $? -gt 0 ]; then
  echo "Error, can't update repo"
  exit 1
fi
apt-get upgrade -y
if [ $? -gt 0 ]; then
  echo "Error, can't upgrade "
  exit 1
fi
apt-get dist-upgrade -y
if [ $? -gt 0 ]; then
  echo "Error, can't upgrade"
  exit 1
fi
if [ -f teamviewer_amd64.deb ]; then
  rm teamviewer_amd64.deb
fi
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
if [ $? -gt 0 ]; then
  echo "Error, can't download teamviewer"
  exit 1
fi
dpkg --force-depends -i teamviewer_amd64.deb
apt-get install -y -f
apt --fix-broken install -y
if [ $? -gt 0 ]; then
  echo "Error, can't fix depends"
  exit 1
fi
whereis thunderbird | grep usr
if [ $? -eq 0 ]; then
  apt-get purge -y thunderbird*
  if [ $? -gt 0 ]; then
    echo "Error, can't remove thunderbird"
    exit 1
  fi
fi
apt purge -y gnome-online-accounts gnome-initial-setup
apt-get install -y chromium-browser crudini nfs-common git geany libreoffice resolvconf ifupdown net-tools gnome-system-tools openssh-server htop iftop tmux
if [ $? -gt 0 ]; then
  echo "Error, can't install package"
  exit 1
fi
yes | snap install code --classic
if [ $? -gt 0 ]; then
  echo "Error, can't install code"
  exit 1
fi
yes | snap install remmina
if [ $? -gt 0 ]; then
  echo "Error, can't install remmina"
  exit 1
fi
yes | snap install vlc
if [ $? -gt 0 ]; then
  echo "Error, can't install vlc"
  exit 1
fi
yes | snap install audacity
if [ $? -gt 0 ]; then
  echo "Error, can't install audacity"
  exit 1
fi
service apport stop
sed -ibak -e s/^enabled\=1$/enabled\=0/ /etc/default/apport

systemctl --user mask tracker-store.service tracker-miner-fs.service tracker-miner-rss.service tracker-extract.service tracker-miner-apps.service tracker-writeback.service

sudo sed -i 's/APT::Periodic::Update-Package-Lists "1"/APT::Periodic::Update-Package-Lists "0"/' /etc/apt/apt.conf.d/20auto-upgrades
sudo sed -i 's/APT::Periodic::Unattended-Upgrade "1"/APT::Periodic::Unattended-Upgrade "0"/' /etc/apt/apt.conf.d/20auto-upgrades

cat > /usr/share/glib-2.0/schemas/90_einaudi.gschema.override << QWK
[org.gnome.shell]
favorite-apps = [ 'firefox.desktop', 'org.gnome.Nautilus.desktop', 'libreoffice-writer.desktop', 'com.teamviewer.TeamViewer.desktop', 'geany.desktop','duplicate.desktop' ,'termina-sessione.desktop']

QWK
cat > /usr/share/glib-2.0/schemas/10_gnome-shell.gschema.override << QWK
[org.gnome.shell]
favorite-apps = [ 'firefox.desktop', 'org.gnome.Nautilus.desktop', 'libreoffice-writer.desktop', 'com.teamviewer.TeamViewer.desktop', 'geany.desktop','duplicate.desktop' ,'termina-sessione.desktop' ]

QWK

cat /etc/passwd | grep studente
if [ $? -eq 0 ]; then
  echo -e "studente\nstudente" | passwd studente
  usermod -p $(openssl passwd -1 "studente") studente
  usermod -a -G dialout,cdrom,floppy,tape,audio,dip,video,plugdev,netdev,lpadmin,scanner,sambashare studente
else
  useradd -s /bin/bash --create-home studente
  echo -e "studente\nstudente" | passwd studente
  usermod -p $(openssl passwd -1 "studente") studente
  usermod -a -G dialout,cdrom,floppy,tape,audio,dip,video,plugdev,netdev,lpadmin,scanner,sambashare studente
fi

cat /etc/passwd | grep docente
if [ $? -eq 0 ]; then
  echo -e "docente\ndocente" | passwd docente
  usermod -p $(openssl passwd -1 "docente") docente
  usermod -a -G dialout,cdrom,floppy,tape,audio,dip,video,plugdev,netdev,lpadmin,scanner,sambashare docente
else
  useradd -s /bin/bash --create-home docente
  echo -e "docente\ndocente" | passwd docente
  usermod -p $(openssl passwd -1 "docente") docente
  usermod -a -G dialout,cdrom,floppy,tape,audio,dip,video,plugdev,netdev,lpadmin,scanner,sambashare docente
fi

cat /etc/passwd | grep classe
if [ $? -eq 0 ]; then
  echo -e "classe\nclasse" | passwd classe
  usermod -p $(openssl passwd -1 "classe") docente
  usermod -a -G dialout,cdrom,floppy,tape,audio,dip,video,plugdev,netdev,lpadmin,scanner,sambashare classe
else
  useradd -s /bin/bash --create-home classe
  echo -e "classe\nclasse" | passwd classe
  usermod -p $(openssl passwd -1 "classe") docente
  usermod -a -G dialout,cdrom,floppy,tape,audio,dip,video,plugdev,netdev,lpadmin,scanner,sambashare classe
fi

if [ -f /etc/resolvconf/resolv.conf.d/head ]; then
  sed -i '/208.67/d' /etc/resolvconf/resolv.conf.d/head
fi
echo "nameserver 208.67.222.123" >> /etc/resolvconf/resolv.conf.d/head
echo "nameserver 208.67.220.123" >> /etc/resolvconf/resolv.conf.d/head
sed -i '/208.67/d' /etc/dhcp/dhclient.conf
echo "supersede domain-name-servers 208.67.222.123,208.67.220.123" >> /etc/dhcp/dhclient.conf


rm -rf .mozilla
unzip ./utils/mozilla.zip
rm -rf /etc/skel/.mozilla
mv .mozilla /etc/skel/
mkdir -p /etc/skel/.config/autostart

cat > /etc/skel/.config/autostart/info.desktop << QWK
[Desktop Entry]
Type=Application
Exec=/usr/local/bin/info.sh
Hidden=false
X-GNOME-Autostart-enabled=true
Name=home_info
Comment=some info about pc
QWK


cat > /usr/local/bin/info.sh << QWK
#!/bin/bash
#Mostra un messaggio

zenity --info --text "Ciao, ricordati che questo PC è di proprietà dell'Istituto Luigi Einaudi di Verona \n\nUsa questo PC solo per scopi didattici, per supporto scrivi a supporto-tecnico@einaudivr.it\n\nSalva i tuoi dati regolarmente su drive o supporto esterno" --height "200" --width "400"

QWK

chmod +x /usr/local/bin/info.sh

cat > /usr/share/applications/termina-sessione.desktop << QWK
[Desktop Entry]
Name=Logout
Comment=Termina sessione
Exec=gnome-session-quit --logout
Icon=/usr/share/icons/Humanity/actions/48/system-log-out.svg
Terminal=false
Type=Application
StartupNotify=true

QWK

cp ./images/duplicate.svg /usr/share/icons/duplicate.svg
cp ./utils/02-dual-monitor.sh /usr/bin/02-dual-monitor.sh
chmod +x /usr/bin/02-dual-monitor.sh

cat > /usr/share/applications/duplicate.desktop << QWK
[Desktop Entry]
Name=Double screen
Comment=Duplica schermo
Exec=/usr/bin/02-dual-monitor.sh
Icon=/usr/share/icons/duplicate.svg
Terminal=false
Type=Application
StartupNotify=true

QWK

glib-compile-schemas /usr/share/glib-2.0/schemas/

rm -r /home/studente
mkdir /home/studente
cp -rf -r /etc/skel/.config/ /home/studente/
cp -rf -r /etc/skel/.mozilla/ /home/studente/
chown -R studente:studente /home/studente

rm -r /home/docente
mkdir /home/docente
cp -rf -r /etc/skel/.config/ /home/docente/
cp -rf -r /etc/skel/.mozilla/ /home/docente/
chown -R docente:docente /home/docente

rm -r /home/classe
mkdir /home/classe
cp -rf -r /etc/skel/.config/ /home/classe/
cp -rf -r /etc/skel/.mozilla/ /home/classe/
chown -R classe:classe /home/classe

mkdir -p /usr/share/images
cp -rf ./images/logo_transparent.png /usr/share/images/logo.png
#wget -O /usr/share/images/logo.png https://raw.githubusercontent.com/nicola-milani/setup-notebook/master/images/logo_transparent.png
cp -rf /etc/gdm3/greeter.dconf-defaults /etc/gdm3/greeter.dconf-defaults.backup
cat > /etc/gdm3/greeter.dconf-defaults << QWK
#  - Change the GTK+ theme
[org/gnome/desktop/interface]
# gtk-theme='Adwaita'
#  - Use another background
[org/gnome/desktop/background]
# picture-uri='file:///usr/share/themes/Adwaita/backgrounds/stripes.jpg'
# picture-options='zoom'
#  - Or no background at all
[org/gnome/desktop/background]
# picture-options='none'
#primary-color='#000000'

# Login manager options
# =====================
[org/gnome/login-screen]
logo='/usr/share/images/logo.png'

# - Disable user list
 disable-user-list=true
# - Show a login welcome message
 banner-message-enable=true
 banner-message-text='Benvenuto su ${HOSTNAME} - username e password: "classe"'


# Automatic suspend
# =================
[org/gnome/settings-daemon/plugins/power]
QWK

cp -rf ./images/wallpaper.png /usr/share/images/wallpaper.png

#wget -O /usr/share/images/wallpaper.png https://raw.githubusercontent.com/nicola-milani/setup-notebook/master/images/wallpaper.png
#before 20.04
#cat <<EOT >> /usr/share/gnome-shell/theme/gdm3.css
##lockDialogGroup {
#   background: #2c001e url(file:///usr/share/images/wallpaper.png);
#   background-repeat: no-repeat;
#   background-size: cover;
#   background-position: center;
#}
#EOT

mv /usr/share/backgrounds/warty-final-ubuntu.png /usr/share/backgrounds/warty-final.png
cp -fRv /usr/share/images/wallpaper.png /usr/share/backgrounds/warty-final-ubuntu.png

if [ -d persona_all_plymouth ]; then
 rm -rf persona_all_plymouth
fi
git clone https://github.com/nicola-milani/persona_all_plymouth.git
cd persona_all_plymouth
if ((${EUID:-0} || "$(id -u)")); then
  
  sleep 1.5
  echo "You are not root"
  sleep 0.5
  echo "Please run using sudo command"
  sleep 1.5
  exit 1
else
  
  sleep 1.5
  echo "Now you're root user"
  sleep 3
  echo "Please be careful!!"
  sleep 1.5
  cp -fRv persona_bar /usr/share/plymouth/themes/
  cp -fRv persona_bar_text /usr/share/plymouth/themes/
  cp -Rfv persona_circle /usr/share/plymouth/themes/

  sed -i 's/Hi, M. Syarief Hidayatulloh/Benvenuto da ITES Luigi Einaudi/g' /usr/share/plymouth/themes/persona_bar_text/persona_bar_text.script
  sed -i 's/Have a Nice Day, Goodbye/A presto!/g' /usr/share/plymouth/themes/persona_bar_text/persona_bar_text.script
  cp -Rfv /root/setup-notebook/images/ply-wall.png /usr/share/plymouth/themes/persona_bar_text/ply-wall.png
  sed -i 's/persona_background.png/ply-wall.png/g' /usr/share/plymouth/themes/persona_bar_text/persona_bar_text.script

  update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/persona_bar/persona_bar.plymouth 100
  update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/persona_bar_text/persona_bar_text.plymouth 100
  update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/persona_circle/persona_circle.plymouth 100
  update-alternatives --set default.plymouth /usr/share/plymouth/themes/persona_bar_text/persona_bar_text.plymouth
  update-initramfs -u
fi

groupadd nopasswdlogin
usermod -a -G nopasswdlogin classe
sed -i '/nopasswdlogin/d' /etc/dhcp/dhclient.conf
echo "auth sufficient pam_succeed_if.so user ingroup nopasswdlogin" >> /etc/pam.d/gdm-password
cat <<EOT > /etc/gdm3/custom.conf 
# GDM configuration storage
#
# See /usr/share/gdm/gdm.schemas for a list of available options.

[daemon]
# Uncomment the line below to force the login screen to use Xorg
#WaylandEnable=false

#Enabling automatic login
AutomaticLoginEnable = true
AutomaticLogin = classe

#Enabling timed login
#TimedLoginEnable = true
#TimedLogin = classe
#TimedLoginDelay = 1

[security]

[xdmcp -rf]

[chooser]

[debug]
# Uncomment the line below to turn on debugging
# More verbose logs
# Additionally lets the X server dump core if it crashes
#Enable=true
EOT

echo "finish"

cat <<EOT > /usr/bin/01_clean_home
#!/bin/bash
#ifStart=`date '+%d'`
#if [ $ifStart == 11 ]; then
rm -r /home/studente
mkdir /home/studente
cp -rf -r /etc/skel/.config/ /home/studente/
cp -rf -r /etc/skel/.mozilla/ /home/studente/
chown -R studente:studente /home/studente

rm -r /home/docente
mkdir /home/docente
cp -rf -r /etc/skel/.config/ /home/docente/
cp -rf -r /etc/skel/.mozilla/ /home/docente/
chown -R docente:docente /home/docente

rm -r /home/classe
mkdir /home/classe
cp -rf -r /etc/skel/.config/ /home/classe/
cp -rf -r /etc/skel/.mozilla/ /home/classe/
chown -R classe:classe /home/classe
#fi
EOT

chmod 744 /usr/bin/01_clean_home
cat <<EOT > /etc/systemd/system/01_clean_home.service
[Unit]
After=network.service

[Service]
ExecStart=/usr/bin/01_clean_home

[Install]
WantedBy=default.target
EOT

chmod 664 /etc/systemd/system/01_clean_home.service
sudo systemctl daemon-reload
sudo systemctl enable 01_clean_home.service

cd /root/setup-notebook
chmod +x ./utils/ubuntu-20.04-change-gdm-background
sudo bash -c "yes | ./utils/ubuntu-20.04-change-gdm-background ./images/wallpaper.png"

touch /etc/NetworkManager/conf.d/20-connectivity-ubuntu.conf

echo "finish finish"

sed -i 's/GRUB_RECORDFAIL_TIMEOUT:-30/GRUB_RECORDFAIL_TIMEOUT:-1/g' /etc/grub.d/00_header
update-grub

sleep 2

reboot
