#!/bin/bash
#Prepara la sessione di lavoro con alcuni accorgimenti
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 30
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface icon-theme "Papirus"
#set menu
gnome-extensions enable arc-menu@linxgem33.com
#gsettings set org.gnome.shell.extensions.arc-menu menu-layout "Plasma"
#gsettings set org.gnome.shell.extensions.arc-menu plasma-show-descriptions true
#gsettings set org.gnome.shell.extensions.arc-menu plasma-selected-color 'rgb(229,165,10)'#
#gsettings set org.gnome.shell.extensions.arc-menu show-external-devices true
#gsettings set org.gnome.shell.extensions.arc-menu extra-categories '[(0, true), (1, true), (2, true), (3, false)]'
#gsettings set org.gnome.shell.extensions.arc-menu reload-theme true
#gsettings set org.gnome.shell.extensions.arc-menu reload-theme false

#gsettings set org.gnome.shell.extensions.arc-menu menu-layout "Dashboard"
#gsettings set org.gnome.shell.extensions.arc-menu reload-theme true
#gsettings set org.gnome.shell.extensions.arc-menu reload-theme false


gsettings set org.gnome.shell.extensions.arc-menu menu-layout 'Brisk'
gsettings set org.gnome.shell.extensions.arc-menu disable-recently-installed-apps true
gsettings set org.gnome.shell.extensions.arc-menu brisk-shortcuts-list "['Downloads', 'ArcMenu_Downloads', 'ArcMenu_Downloads', 'Settings', 'preferences-system-symbolic', 'gnome-control-center.desktop']"
#gsettings set org.gnome.shell.extensions.arc-menu directory-shortcuts-list "[['Home', 'ArcMenu_Home', 'ArcMenu_Home'], ['Downloads', 'ArcMenu_Downloads', 'ArcMenu_Downloads']]"
gsettings set org.gnome.shell.extensions.arc-menu reload-theme true
gsettings set org.gnome.shell.extensions.arc-menu reload-theme false
gsettings set org.gnome.shell.extensions.arc-menu arc-menu-placement "DTD"
gsettings set org.gnome.shell.extensions.arc-menu enable-large-icons true
gsettings set org.gnome.shell.extensions.arc-menu disable-tooltips false
gsettings set org.gnome.shell.extensions.arc-menu disable-recently-installed-apps true
gsettings set org.gnome.shell.extensions.arc-menu enable-custom-arc-menu true
gsettings set org.gnome.shell.extensions.arc-menu separator-color 'rgb(189,86,53)'
gsettings set org.gnome.shell.extensions.arc-menu border-color 'rgb(189,86,53)'
gsettings set org.gnome.shell.extensions.arc-menu highlight-color 'rgba(247,186,36,0.405405)'
gsettings set org.gnome.shell.extensions.arc-menu highlight-foreground-color 'rgba(255,255,255,1)'
gsettings set org.gnome.shell.extensions.arc-menu menu-arrow-size 0
gsettings set org.gnome.shell.extensions.arc-menu menu-border-size 0
gsettings set org.gnome.shell.extensions.arc-menu menu-color 'rgb(46,52,54)'
gsettings set org.gnome.shell.extensions.arc-menu menu-corner-radius 8
gsettings set org.gnome.shell.extensions.arc-menu menu-font-size 12
gsettings set org.gnome.shell.extensions.arc-menu menu-foreground-color 'rgb(243,243,243)'
gsettings set org.gnome.shell.extensions.arc-menu menu-margin 24
gsettings set org.gnome.shell.extensions.arc-menu vert-separator true
gsettings set org.gnome.shell.extensions.arc-menu menu-height 700
gsettings set org.gnome.shell.extensions.arc-menu menu-width 360

gsettings set org.gnome.shell.extensions.arc-menu reload-theme true
gsettings set org.gnome.shell.extensions.arc-menu reload-theme false

gsettings set org.gnome.shell.extensions.ding show-home false
gsettings set org.gnome.shell.extensions.ding show-trash false
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'libreoffice-writer.desktop', 'code_code.desktop', 'kazam.desktop', 'org.gnome.Screenshot.desktop', 'scratch-desktop.desktop', 'duplicate.desktop', 'termina-sessione.desktop']"


#zenity --info --text "Ciao, ricordati che questo PC è di proprietà dell'Istituto Luigi Einaudi di Verona \n\nUsa questo PC solo per scopi didattici, per supporto scrivi a supporto-tecnico@einaudivr.it\n\nSalva i tuoi dati regolarmente su Google Drive o supporto usb esterno" --height "200" --width "400"
yad --info --image=/usr/share/icons/googleLogo.png --text "Ciao, ricordati che questo PC è di proprietà dell'Istituto Luigi Einaudi di Verona \n\nUsa questo PC solo per scopi didattici, per supporto scrivi a supporto-tecnico@einaudivr.it\n\nSalva i tuoi dati regolarmente su Google Drive o supporto usb esterno "  --button=gtk-ok:1 --title="Note sul salvataggio dei dati" --fixed --borders=30 --escape-ok --center

gsettings set org.gnome.desktop.a11y always-show-universal-access-status true
#dopo aver aggiungo l'icona sul supporto accessibilità, mettere un messaggio?
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'it'), ('ibus', 'libpinyin')]"
#zenity --info --text "In alto a destra viene aggiunto il supporto alla lingua cinese\n\nUsa \"Tasto windows\" + \"barra spaziatrice\" per cambiare lingua rapidamente\n\n" --height "200" --width "400"
yad --info --image=/usr/share/icons/language-selector.png --text "In alto a destra viene aggiunto il supporto alla lingua cinese\n\nUsa \"Tasto windows\" + \"barra spaziatrice\" per cambiare lingua rapidamente\n\n "  --button=gtk-ok:1 --title="Note sulla lingua di inserimento" --fixed --borders=30 --escape-ok --center

/usr/bin/02-dual-monitor.sh&
