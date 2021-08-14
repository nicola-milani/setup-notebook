#!/bin/bash
video_dev=$(xrandr | grep -w "connected" | wc -l )
primary=$(xrandr | grep -w "connected" | cut -d " " -f1 | head -1 )
secondary=$(xrandr | grep -w "connected" | cut -d " " -f1 | tail -1 )
titleTry="Cerco un proiettore o un monitor esterno"
textTry="Tentativo di duplicazione schermo..."
titleFailed="Monitor esterno non trovato"
textFailed="Non ho rilevato un secondo monitor/proiettore.\nSe ti serve ancora, collega il cavo HDMI ed usa il pulsante sulla barra a sinistra per attivare la proiezione"
if [ $video_dev -gt 1 ]; then
   yad --info --image=/usr/share/icons/duplica-monitor-64.png --text "${textTry}" --button=gtk-ok:1 --title="${titleTry}" --width=400 --height=100 --fixed --borders=30 --escape-ok --center&
   pid=$! 
   xrandr --output $secondary --same-as $primary
   xrandr --output $secondary --mode 1280x720
   xrandr --output $primary --mode 1280x720
   sleep 2
   kill -9 $pid
else
   yad --info --image=/usr/share/icons/duplica-monitor-64.png  --text="${textFailed}" --button=gtk-ok:1 --title="${titleTry}" --width=400 --fixed --borders=30 --escape-ok --center&
fi
