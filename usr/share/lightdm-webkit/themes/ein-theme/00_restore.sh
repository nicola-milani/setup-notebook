#!/bin/bash
ps -aux | grep gnome-shell | grep -v root
if [ $? -eq 0 ]; then
 cp /usr/local/share/lightdm-msgs/message_center_standby.html /usr/share/lightdm-webkit/themes/ein-theme/message_center.html
 chmod 666 /usr/share/lightdm-webkit/themes/ein-theme/message_center.html
 sed -i "s/USERNAME/$USER/g" /usr/share/lightdm-webkit/themes/ein-theme/message_center.html
else
 cp /usr/local/share/lightdm-msgs/message_center_default.html /usr/share/lightdm-webkit/themes/ein-theme/message_center.html
 chmod 666 /usr/share/lightdm-webkit/themes/ein-theme/message_center.html
fi
