#!/bin/bash
cp /usr/local/share/lightdm-msgs/message_center_standby.html /usr/share/lightdm-webkit/themes/ein-theme/message_center.html
chmod 666 /usr/share/lightdm-webkit/themes/ein-theme/message_center.html
sed -i "s/USERNAME/$USER/g" /usr/share/lightdm-webkit/themes/ein-theme/message_center.html
