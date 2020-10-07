#!/bin/bash
source ./config
source $VERSION_FILE
system_manufacturer=$(dmidecode -s system-manufacturer)
system_family=$(dmidecode -s system-family)
system_product_name=$(dmidecode -s system-product-name)
system_serial_number=$(dmidecode -s system-serial-number)
hostname=$(hostname)
rotation=$(cat /sys/block/sda/queue/rotational)
version=$VERSION
source /etc/lsb-release
echo "$hostname;$DISTRIB_DESCRIPTION;$rotation;$system_manufacturer;$system_family;$system_product_name;$system_serial_number;$SCRIPT_VERSION" 