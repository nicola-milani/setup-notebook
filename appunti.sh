#!/bin/bash

gsettings set org.gnome.desktop.interface text-scaling-factor '1.25'
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'libreoffice-writer.desktop', 'com.teamviewer.TeamViewer.desktop', 'geany.desktop', 'duplicate.desktop', 'termina-sessione.desktop', 'geogebra.desktop']"
gsettings get org.gnome.shell favorite-apps


