#!/bin/bash

gsettings set org.gnome.desktop.interface text-scaling-factor '1.25'
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'libreoffice-writer.desktop', 'com.teamviewer.TeamViewer.desktop', 'geany.desktop', 'duplicate.desktop', 'termina-sessione.desktop', 'geogebra.desktop']"
gsettings get org.gnome.shell favorite-apps


apt-get install lightdm
wget https://download.opensuse.org/repositories/home:/antergos/xUbuntu_17.10/amd64/lightdm-webkit2-greeter_2.2.5-1+15.31_amd64.deb
dpkg -i lightdm-webkit2-greeter_2.2.5-1+15.31_amd64.deb
cat < /etc/lightdm/lightdm.conf << EOF
[Seat:*]
greeter-session=lightdm-webkit2-greeter
greeter-hide-users=true
greeter-show-manual-login=true

EOF
mv /usr/share/wayland-sessions/ubuntu-wayland.desktop /usr/share/wayland-sessions/ubuntu-wayland.desktop.back