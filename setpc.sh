#!/bin/bash
N_STEP=21
STEP=0
function message(){
    local MSG="$1"
    echo -e "\e[32m$MSG\e[39m"
}

function error_message(){
    local MSG="$1"
    echo -e "\e[31m$MSG\e[39m"
}

function do_set_language(){
   locale-gen it_IT.UTF-8
   locale-gen en_GB.UTF-8
   update-locale LANG=it_IT.UTF-8 LANGUAGE=it:en_GB:en
   echo Europe/Rome > /etc/timezone 
   cat /etc/timezone 
   cp /usr/share/zoneinfo/Europe/Rome /etc/localtime 

}
function checkroot(){
  if [ $(id -u) -gt 0 ]; then
    sleep 1.5
    error_message "You are not root"
    sleep 0.5
    error_message "Please become root before continue"
    sleep 1.5
    exit 1
  fi
}


function checkconnection(){
  ping -q -w1 -c1 google.com &>/dev/null && message online || echo offline
  wget -q --spider http://google.com
  if [ $? -eq 0 ]; then
    message "Online"
  else
    error_message "Offline"
    exit 1
  fi
}

function do_checkupdate(){
  apt-get update > /dev/null
  if [ $? -gt 0 ]; then
    error_message "Error, can't update repo"
    exit 1
  fi
}

function do_add_repositories(){
  message "Add libreoffice repositories"
  sudo add-apt-repository ppa:libreoffice/ppa -y > /dev/null
  if [ $? -gt 0 ]; then
    error_message "Error, can't update repo"
    exit 1
  fi
}

function do_full_upgrade_system(){
  message "Upgrade system..."
  apt-get upgrade -y > /dev/null
  if [ $? -gt 0 ]; then
    error_message "Error, can't upgrade "
    exit 1
  fi
  message "Upgrade from all repository..."
  apt-get dist-upgrade -y > /dev/null
  if [ $? -gt 0 ]; then
    error_message "Error, can't upgrade"
    exit 1
  fi
}

function do_install_custom_software(){
  message "Install teamviewer..."
  if [ ! -f teamviewer_amd64.deb ]; then
    #rm teamviewer_amd64.deb
    wget -O teamviewer_amd64.deb https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
    if [ $? -gt 0 ]; then
      error_message "Error, can't download teamviewer"
      exit 1
    fi
  fi
  dpkg --force-depends -i teamviewer_amd64.deb > /dev/null
  apt-get install -y -f > /dev/null
  apt --fix-broken install -y > /dev/null
  if [ $? -gt 0 ]; then
    error_message "Error, can't fix depends"
    exit 1
  fi

  message "Install scratch..."
  if [ ! -f scratch-desktop_3.15.0_amd64.deb ]; then
    # rm scratch-desktop_3.15.0_amd64.deb
    wget -O scratch-desktop_3.15.0_amd64.deb https://sourceforge.net/projects/scratch-deb/files/scratch-desktop_3.15.0_amd64.deb
    if [ $? -gt 0 ]; then
      error_message "Error, can't download scratch"
      exit 1
    fi
  fi
  dpkg -i scratch-desktop_3.15.0_amd64.deb > /dev/null
  apt-get install -y -f > /dev/null
  apt --fix-broken install -y > /dev/null
  if [ $? -gt 0 ]; then
    error_message "Error, can't fix depends"
    exit 1
  fi

  
}

function do_install_lightdm(){
  DEBIAN_FRONTEND=noninteractive apt-get install -y lightdm
  wget https://download.opensuse.org/repositories/home:/antergos/xUbuntu_17.10/amd64/lightdm-webkit2-greeter_2.2.5-1+15.31_amd64.deb
  dpkg -i lightdm-webkit2-greeter_2.2.5-1+15.31_amd64.deb
  touch /etc/lightdm/lightdm.conf
cat > /etc/lightdm/lightdm.conf << EOF
[Seat:*]
greeter-session=lightdm-webkit2-greeter
greeter-hide-users=true
greeter-show-manual-login=true
session-setup-script=/usr/share/lightdm-webkit/themes/ein-theme/00_init.sh
session-cleanup-script=/usr/share/lightdm-webkit/themes/ein-theme/00_restore.sh
autologin-user=classe

EOF
mv /usr/share/wayland-sessions/ubuntu-wayland.desktop /usr/share/wayland-sessions/ubuntu-wayland.desktop.back
echo "/usr/sbin/lightdm" > /etc/X11/default-display-manager
DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure lightdm
echo set shared/default-x-display-manager lightdm | debconf-communicate

#DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure gdm3
#echo set shared/default-x-display-manager gdm3 | debconf-communicate
}

function do_set_ligthdm_theme(){
  sed -i 's/antergos/ein-theme/g' /etc/lightdm/lightdm-webkit2-greeter.conf
  chmod -R 647 /usr/local/share/lightdm-msgs/
  cp /usr/local/share/lightdm-msgs/message_center.html /usr/share/lightdm-webkit/themes/ein-theme/message_center.html
  chmod +x /usr/share/lightdm-webkit/themes/ein-theme/00_restore.sh
  chmod +x /usr/share/lightdm-webkit/themes/ein-theme/00_init.sh

}

function do_remove_some_software(){
  message "Remove thunderbird..."
  whereis thunderbird | grep usr
  if [ $? -eq 0 ]; then
    apt-get purge -y thunderbird* > /dev/null
    if [ $? -gt 0 ]; then
      error_message "Error, can't remove thunderbird"
      exit 1
    fi
  fi

  message "Remove gnome-online-accounts and gnome-initial-setup..."
  apt purge -y gnome-online-accounts gnome-initial-setup  > /dev/null
}

function do_install_apt(){
  message "Install default list of APT packages..."
  N_APT=$(cat $APT_PACKAGE_LIST | grep -v '#' | wc -l )
  i=0
  for package in $(cat $APT_PACKAGE_LIST | grep -v '#'); do
    i=$((i+1))
    message "Download $i of ${N_APT}: $package"
    apt-get install -dy $package > /dev/null 
    if [ $? -gt 0 ]; then
      error_message "Error, can't install package"
      exit 1
    fi
  done
  for package in $(cat $APT_PACKAGE_LIST | grep -v '#'); do
    i=$((i+1))
    message "Install $i of ${N_APT}: $package"
    apt-get install -y $package > /dev/null
    if [ $? -gt 0 ]; then
      error_message "Error, can't install package"
      exit 1
    fi
  done
  apt install -f >> $LOG_FILE
}

function do_install_snap(){
  message "Install default list of SNAP packages..."
  N_SNAP=$(cat $SNAP_PACKAGE_LIST | grep -v '#' | wc -l )
  i=0
  message "Install default list of SNAP packages..."
  while read package; do
    echo $package | grep '#' > /dev/null
    if [ $? -gt 0 ]; then
      i=$((i+1))
      message "Install $i of ${N_SNAP}: $package"
      yes | snap install $package
      if [ $? -gt 0 ]; then
        error_message "Error, can't install $package"
        exit 1
      fi
    fi
  done < $SNAP_PACKAGE_LIST
}

function do_remove_services(){
  message "Remove apport services"
  service apport stop
  sed -ibak -e s/^enabled\=1$/enabled\=0/ /etc/default/apport

  message "Remove tracker services"
  systemctl --user mask tracker-store.service tracker-miner-fs.service tracker-miner-rss.service tracker-extract.service tracker-miner-apps.service tracker-writeback.service
}

function do_disable_update(){
  message "Remove autoupdate tracker services"
  sudo sed -i 's/APT::Periodic::Update-Package-Lists "1"/APT::Periodic::Update-Package-Lists "0"/' /etc/apt/apt.conf.d/20auto-upgrades
  sudo sed -i 's/APT::Periodic::Unattended-Upgrade "1"/APT::Periodic::Unattended-Upgrade "0"/' /etc/apt/apt.conf.d/20auto-upgrades
}

function do_custom_dock(){
message "Add favorites to dock"
cat > /usr/share/glib-2.0/schemas/90_einaudi.gschema.override << QWK
[org.gnome.shell]
favorite-apps = [ 'firefox.desktop', 'org.gnome.Nautilus.desktop', 'libreoffice-writer.desktop', 'com.teamviewer.TeamViewer.desktop', 'geany.desktop','duplicate.desktop' ,'termina-sessione.desktop']

QWK

cat > /usr/share/glib-2.0/schemas/10_gnome-shell.gschema.override << QWK
[org.gnome.shell]
favorite-apps = [ 'firefox.desktop', 'org.gnome.Nautilus.desktop', 'libreoffice-writer.desktop', 'com.teamviewer.TeamViewer.desktop', 'geany.desktop','duplicate.desktop' ,'termina-sessione.desktop' ]

QWK

  message "Install custom scripts"
  rsync -av ./usr/ /usr/
  chmod -R a+w /usr/share/lightdm-webkit/themes/ein-theme
  chmod +x /usr/local/bin/info.sh
  chmod +x /usr/bin/02-dual-monitor.sh
  cp ./images/duplica-monitor.png /usr/share/icons/duplica-monitor.png
  cp ./images/googleLogo.png /usr/share/icons/googleLogo.png
  message "Rebuild glibs"
  glib-compile-schemas /usr/share/glib-2.0/schemas/
}

function do_fix_network(){
  message "Add custom dns as default dns"

  N_DNS=$(cat $DNS_LIST | grep -v '#' | wc -l )
  i=0
  string=""
  for dns in $(cat $DNS_LIST | grep -v '#'); do
    i=$((c+1))
    if [ -f /etc/resolvconf/resolv.conf.d/head ]; then
      sed -i '/$dns/d' /etc/resolvconf/resolv.conf.d/head
    fi
    echo "nameserver $dns" >> /etc/resolvconf/resolv.conf.d/head
    sed -i '/$dns/d' /etc/dhcp/dhclient.conf
    if [ -z $string ]; then
      string=$dns
    else
      string=$string,$dns
    fi
  done

  echo "supersede domain-name-servers $string" >> /etc/dhcp/dhclient.conf
  touch /etc/NetworkManager/conf.d/20-connectivity-ubuntu.conf
}

function do_custom_skel(){
  message "Add custom mozilla skel for all users"
  rm -rf .mozilla
  unzip ./utils/mozilla.zip
  rm -rf /etc/skel/.mozilla
  mv .mozilla /etc/skel/

  message "Add autostart for all users"
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
}

function do_set_default_login(){
  message "Find default user"
  for user in $(cat $USERS_LIST | grep -v '#' ); do
    if [ $(echo $user | cut -d ";" -f5) -gt 0 ]; then
      username=$(echo $user | cut -d ";" -f1)
      password=$(echo $user | cut -d ";" -f2)
    fi
    message "Default user is: $username"
  done
  cp -rf /etc/gdm3/greeter.dconf-defaults /etc/gdm3/greeter.dconf-defaults.backup
  message "Fix gmd menu"
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
 banner-message-text='Benvenuto su ${HOSTNAME} - username "$username" e password: "$password"'


# Automatic suspend
# =================
[org/gnome/settings-daemon/plugins/power]
QWK

  message "Copy new wallpapers"
  cp -rf ./images/wallpaper.png /usr/share/images/wallpaper.png
  mv /usr/share/backgrounds/warty-final-ubuntu.png /usr/share/backgrounds/warty-final.png
  cp -fRv /usr/share/images/wallpaper.png /usr/share/backgrounds/warty-final-ubuntu.png
  message "Set autologin for default user"

  groupadd nopasswdlogin
  usermod -a -G nopasswdlogin $username
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
AutomaticLogin = $username

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
}

function do_create_users(){
  message "Add users or reset users password and clean home"
  N_USERS=$(cat $USERS_LIST | grep -v '#' | wc -l )
  i=0
  for user in $(cat $USERS_LIST | grep -v '#'); do
    username=$(echo $user | cut -d ";" -f1 )
    password=$(echo $user | cut -d ";" -f2 )
    groups=$(echo $user | cut -d ";" -f3 )
    clean_home=$(echo $user | cut -d ";" -f4 )
    i=$((i+1))
    cat /etc/passwd | grep $username
    if [ $? -eq 0 ]; then
      if [ $clean_home -gt 0 ]; then
        message "Clean home for user: $username"
        rm -rf /home/$username
        mkdir /home/$username
        cp -rf -r /etc/skel/.config/ /home/$username/
        cp -rf -r /etc/skel/.mozilla/ /home/$username/
        chown -R $username:$username /home/$username
      fi
      message "Reset password for user $username"
      echo -e "$password\n$password" | passwd $username
      usermod -p $(openssl passwd -1 "$password") $username
      usermod -a -G $groups $username
    else
      message "Add user n° $i of $N_USERS: $username"
      useradd -s /bin/bash --create-home $username
      echo -e "$password\n$password" | passwd $username
      usermod -p $(openssl passwd -1 "$password") $username
      usermod -a -G $groups $username
    fi
  done

}

function do_custom_gdm_wallpaper(){
  message "Change gdm wallpaper"
  cd /root/setup-notebook
  chmod +x ./utils/ubuntu-20.04-change-gdm-background
  sudo bash -c "yes | ./utils/ubuntu-20.04-change-gdm-background ./images/wallpaper.png"
}

function do_create_services(){
  message "Create service for autoclean home at reboot"
  echo "#!/bin/bash" > /usr/bin/01_clean_home
  for user in $(cat $USERS_LIST | grep -v '#'); do
    username=$(echo $user | cut -d ";" -f1 )
    clean_home=$(echo $user | cut -d ";" -f4 )
    if [ $clean_home -gt 0 ]; then

    echo "rm -r /home/$username" >> /usr/bin/01_clean_home
    echo "mkdir /home/$username"  >> /usr/bin/01_clean_home
    echo "cp -rf -r /etc/skel/.config/ /home/$username/"  >> /usr/bin/01_clean_home
    echo "cp -rf -r /etc/skel/.mozilla/ /home/$username/" >> /usr/bin/01_clean_home
    echo "chown -R $username:$username /home/$username" >> /usr/bin/01_clean_home

    fi
  done

  chmod 744 /usr/bin/01_clean_home

cat <<EOT > /etc/systemd/system/01_clean_home.service
[Unit]
After=network.service

[Service]
ExecStart=/usr/bin/01_clean_home

[Install]
WantedBy=default.target
EOT

}

function do_enable_services(){
  chmod 664 /etc/systemd/system/01_clean_home.service
  sudo systemctl daemon-reload
  sudo systemctl enable 01_clean_home.service
}

function do_custom_boot(){
  message "Install new boot theme"
  if [ -d persona_all_plymouth ]; then
    rm -rf persona_all_plymouth
  fi
  git clone https://github.com/nicola-milani/persona_all_plymouth.git
  cd persona_all_plymouth
  cp -fRv persona_bar /usr/share/plymouth/themes/
  cp -fRv persona_bar_text /usr/share/plymouth/themes/
  cp -Rfv persona_circle /usr/share/plymouth/themes/
  sed -i 's/Hi, M. Syarief Hidayatulloh/Benvenuto da ITES Luigi Einaudi/g' /usr/share/plymouth/themes/persona_bar_text/persona_bar_text.script
  sed -i 's/Have a Nice Day, Goodbye/A presto!/g' /usr/share/plymouth/themes/persona_bar_text/persona_bar_text.script
  cp -Rfv /root/setup-notebook/images/ply-wall.png /usr/share/plymouth/themes/persona_bar_text/ply-wall.png
  cp -Rfv /root/setup-notebook/images/personanew.png /usr/share/plymouth/themes/persona_bar_text/persona.png
  sed -i 's/persona_background.png/ply-wall.png/g' /usr/share/plymouth/themes/persona_bar_text/persona_bar_text.script
  update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/persona_bar/persona_bar.plymouth 100
  update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/persona_bar_text/persona_bar_text.plymouth 100
  update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/persona_circle/persona_circle.plymouth 100
  update-alternatives --set default.plymouth /usr/share/plymouth/themes/persona_bar_text/persona_bar_text.plymouth
  update-initramfs -u
  sleep 2
  message "Remove grub timeout"
  sed -i 's/GRUB_RECORDFAIL_TIMEOUT:-30/GRUB_RECORDFAIL_TIMEOUT:-1/g' /etc/grub.d/00_header
  update-grub
  sleep 2
}

function do_save_version(){
  touch $VERSION_FILE
  echo  $VERSION > $VERSION_FILE
  . $VERSION_FILE
  sed -i "s/hostname/$HOSTNAME/g" /usr/share/lightdm-webkit/themes/ein-theme/message_right.html
  sed -i "s/version/$SCRIPT_VERSION/g" /usr/share/lightdm-webkit/themes/ein-theme/message_right.html
}

STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Get configuration"
. ./config

checkroot

message "Create log direcotory and log file"
mkdir -p $LOG_PATH
today=$(date +'%Y-%m-%d')
LOG_FILE=$LOG_PATH/${today}.log
message "Check status log in $LOG_FILE"
touch $LOG_FILE

#check for software update
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Update repositories..."
do_checkupdate
#add custom repositories
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - add custom repositories"
do_add_repositories
#full upgrade the OS and software
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Upgrade all software"
do_full_upgrade_system
#Remove some software
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Remove unused software"
do_remove_some_software
#Install from list of APT packages define in .config file
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Install list of APT package"
do_install_apt
#Install from list of SNAP packages define in .config file
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Install list of SNAP package"
do_install_snap
#Install teamviewer,scratch
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Install custom software"
do_install_custom_software
#Remove some services (tracker and apport)
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Disable services"
do_remove_services
#Disable autoupdate
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Disable auto update"
do_disable_update
#ADD favorites to dock
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Customize dock and lightdm"
#do_install_lightdm
do_custom_dock
#do_set_ligthdm_theme
#Fix some network details
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Fix some network details"
do_fix_network
#Add custom skel for users
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Customize skel for users"
do_custom_skel
#Add or reset users and fix login screen
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Create default users"
do_create_users
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Set default login"
do_set_default_login
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Create custom services"
do_create_services
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Enable services"
do_enable_services
#Install new custom boot theme
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - New custom boot theme"
do_custom_boot
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Customize GDM"
do_custom_gdm_wallpaper
STEP=$((STEP+1))
message "Step $STEP of $N_STEP - Set Language and localtime"
do_set_language

message "Step $STEP of $N_STEP - Update current version"
#do_save_version

sleep 3
message "Ok all is ok, autoreboot now"
reboot
