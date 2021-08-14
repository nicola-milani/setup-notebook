#!/bin/bash
#Prepara la sessione di lavoro con alcuni accorgimenti
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

/usr/bin/02-dual-monitor.sh
