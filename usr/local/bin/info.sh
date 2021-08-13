#!/bin/bash
#Prepara la sessione di lavoro con alcuni accorgimenti
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'libreoffice-writer.desktop', 'code_code.desktop', 'kazam.desktop', 'org.gnome.Screenshot.desktop', 'scratch-desktop.desktop', 'duplicate.desktop', 'termina-sessione.desktop']"
zenity --info --text "Ciao, ricordati che questo PC è di proprietà dell'Istituto Luigi Einaudi di Verona \n\nUsa questo PC solo per scopi didattici, per supporto scrivi a supporto-tecnico@einaudivr.it\n\nSalva i tuoi dati regolarmente su drive o supporto esterno" --height "200" --width "400"
zenity --info --text "In alto a destra viene aggiunto il supporto alla lingua cinese\n\nUsa \"Tasto windows\" + \"barra spaziatrice\" per cambiare lingua rapidamente,\n\n" --height "200" --width "400"
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'it'), ('ibus', 'libpinyin')]"
gsettings set org.gnome.desktop.a11y always-show-universal-access-status true
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.mutter center-new-windows true
/usr/bin/02-dual-monitor.sh
