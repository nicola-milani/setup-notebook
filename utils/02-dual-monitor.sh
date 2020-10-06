#!/bin/bash
video_dev=$(xrandr | grep -w "connected" | wc -l )
primary=$(xrandr | grep -w "connected" | cut -d " " -f1 | head -1 )
secondary=$(xrandr | grep -w "connected" | cut -d " " -f1 | tail -1 )

if [ $video_dev -gt 1 ]; then
   zenity --info --text "Tentativo di duplicazione schermo..." --height "200" --width "400"&
   pid=$! 
   xrandr --output $secondary --same-as $primary
   sleep 2
   kill -9 $pid
else
   zenity --info --text "Non ho rilevato un secondo monitor/proiettore, riprova" --height "200" --width "400"&
fi
