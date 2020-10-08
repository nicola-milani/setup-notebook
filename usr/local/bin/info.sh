#!/bin/bash
#Prepara la sessione di lavoro con alcuni accorgimenti
/usr/share/lightdm-webkit/themes/ein-theme/00_init.sh
sed -i "s/USERNAME/$USER/g" /usr/share/lightdm-webkit/themes/ein-theme/message_center.html

zenity --info --text "Ciao, ricordati che questo PC è di proprietà dell'Istituto Luigi Einaudi di Verona \n\nUsa questo PC solo per scopi didattici, per supporto scrivi a supporto-tecnico@einaudivr.it\n\nSalva i tuoi dati regolarmente su drive o supporto esterno" --height "200" --width "400"
zenity --info --text "In alto a destra viene aggiunto il supporto alla lingua cinese\n\nUsa \"Tasto windows\" + \"barra spaziatrice\" per cambiare lingua rapidamente,\n\n" --height "200" --width "400"
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'it'), ('ibus', 'libpinyin')]"
gsettings set org.gnome.desktop.a11y always-show-universal-access-status true
