#!/bin/sh

clear

echo "Проверяем наличие подозрительных файлов: "

printf 'LaunchDaemons/com.apple.MRTd.plist ......... '
if [[ -f /Volumes/OSX/System/Library/LaunchDaemons/com.apple.MRTd.plist ]]; then printf 'есть\n'; else printf 'нету\n'; fi
printf 'LaunchDaemons/com.apple.mrt.uiagent.plist ......... '  
if [[ -f /Volumes/OSX/System/Library/LaunchDaemons/com.apple.mrt.uiagent.plist ]]; then printf 'есть\n'; else printf 'нету\n'; fi 
printf 'CoreServices/MRTAgent.app ......... '
if [[ -d /Volumes/OSX/System/Library/CoreServices/MRTAgent.app ]]; then printf 'есть\n'; else printf 'нету\n'; fi
printf 'CoreServices/MRT.app ......... ' 
if [[ -d /Volumes/OSX/System/Library/CoreServices/MRT.app ]]; then printf 'есть\n'; else printf 'нету\n'; fi
 printf 'LaunchAgents/com.apple.MRTa.plist .............. '
if [[ -f /Volumes/OSX/System/Library/LaunchAgents/com.apple.MRTa.plist ]]; then printf 'есть\n'; else printf 'нету\n'; fi    



echo; printf 'Для выхода нажмите любую клавишу  '
read -n 1 demo


osascript -e 'tell application "Terminal" to close first window' & exit