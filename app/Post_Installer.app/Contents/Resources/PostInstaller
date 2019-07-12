#!/bin/bash

PASSWORD=""

MyTTY=`tty | tr -d " dev/\n"`
if [[ ${MyTTY} = "ttys001" ]]; then
# Получаем uid и pid первой консоли
MY_uid=`echo $UID`; PID_ttys001=`echo $$`
# получаем pid нулевой консоли
temp=`ps -ef | grep ttys000 | grep $MY_uid`; PID_ttys000=`echo $temp | awk  '{print $2}'`
# вычисляем время жизни нашей консоли в секундах
Time001=`ps -p $PID_ttys001 -oetime= | tr '-' ':' | awk -F: '{ total=0; m=1; } { for (i=0; i < NF; i++) {total += $(NF-i)*m; m *= i >= 2 ? 24 : 60 }} {print total}'`
# Вычисляем время жизни нулевой консоли в секундах
Time000=`ps -p $PID_ttys000 -oetime= | tr '-' ':' | awk -F: '{ total=0; m=1; } { for (i=0; i < NF; i++) {total += $(NF-i)*m; m *= i >= 2 ? 24 : 60 }} {print total}'`
	if [[ ${Time001} -le ${Time000} ]]; then 
let "TimeDiff=Time000-Time001"
# Здесь задаётся постоянная в секундах по которой можно считать что нулевая консоль запущена сразу перед первой и потому её надо закрыть
		if [[ ${TimeDiff} -le 4 ]]; then osascript -e 'tell application "Terminal" to close second  window'; fi
	fi	
fi
term=`ps`;  MyTTYcount=`echo $term | grep -Eo $MyTTY | wc -l | tr - " \t\n"`
clear && printf '\e[3J' && printf '\033[0;0H'

osascript -e "tell application \"Terminal\" to set the font size of window 1 to 12"
osascript -e "tell application \"Terminal\" to set background color of window 1 to {1028, 12850, 10240}"
osascript -e "tell application \"Terminal\" to set normal text color of window 1 to {65535, 65535, 65535}"


lines=33
printf '\e[8;'${lines}';80t' && printf '\e[3J' && printf "\033[0;0H"

printf '\e[2m************** \e[0m\e[36mНастройка после установки мак ос на макбук 6,1/7,1\e[0m\e[2m **************\e[0m\n'
printf '\e[2m****** \e[0m\e[36mНаличие модуля Bluetooth HCI 4.0+ c LE для continuity обязательно\e[0m\e[2m *******\e[0m\n'
printf '\e[2m**************.................. \e[0m\e[36mВерсия 1,1\e[0m\e[2m ......................**************\e[0m\n'

printf '\n\e[2m                       Версия '
printf "`sw_vers -productName`"
printf ': '; printf "`sw_vers -productVersion`" 
printf '('
printf "`sw_vers -buildVersion`"
printf ') '
printf '     \n\n\e[0m'

csrset=$(csrutil status | grep "status:" | grep -ow "disabled")
if [[ ! $csrset = "disabled" ]]; then
        printf '           \e[1;31m!!!\e[0m   \e[1;36m Защита целостности системы включена\e[0m              \e[1;31m!!!\e[0m\n\n'
		printf '           \e[1;31m!!!\e[0m    \e[33mПродолжение установки невозможно\e[0m                 \e[1;31m!!!\e[0m\n'
		printf '           \e[1;31m!!!\e[0m    \e[33mПатч Continuity не сработает\e[0m                     \e[1;31m!!!\e[0m\n'
		printf '           \e[1;31m!!!\e[0m    \e[33mЗагрузитесь в Recovery\e[0m                           \e[1;31m!!!\e[0m\n'
		printf '           \e[1;31m!!!\e[0m    \e[33mЗапустите утилиту терминала и выполните\e[0m          \e[1;31m!!!\e[0m\n'
		printf '           \e[1;31m!!!\e[0m    \e[33mкоманду csrutil disable\e[0m                          \e[1;31m!!!\e[0m\n'
		printf '           \e[1;31m!!!\e[0m    \e[33mпосле перезагрузки запустите программу еще раз\e[0m   \e[1;31m!!!\e[0m\n'
		printf '\n'
        printf '                  \e[1;36mДля выхода нажмите любую клавишу.  \e[0m'
		read  -n 1 -s
        clear
        osascript -e 'tell application "Terminal" to close first window' & exit
fi 

# Возвращает в переменной TTYcount 0 если наш терминал один
CHECK_TTY_COUNT(){
term=`ps`
AllTTYcount=`echo $term | grep -Eo ttys[0-9][0-9][0-9] | wc -l | tr - " \t\n"`
let "TTYcount=AllTTYcount-MyTTYcount"
}

################## Выход из программы с проверкой - выгружать терминал из трея или нет #####################################################
EXIT_PROGRAM(){
################################## очистка на выходе #############################################################
cat  ~/.bash_history | sed -n '/PostInstaller/!p' >> ~/new_hist.txt; rm ~/.bash_history; mv ~/new_hist.txt ~/.bash_history
#####################################################################################################################
CHECK_TTY_COUNT	
if [[ ${TTYcount} = 0  ]]; then   osascript -e 'quit app "terminal.app"' & exit
	else
     osascript -e 'tell application "Terminal" to close first window' & exit
fi
}

GET_AUTH(){
cd $(dirname $0)
if [[ -f ~/.auth/auth.plist ]]; then
      login=`cat ~/.auth/auth.plist | grep -Eo "LoginPassword"  | tr -d '\n'`
    if [[ $login = "LoginPassword" ]]; then
PASSWORD=`cat ~/.auth/auth.plist | grep -A 1 "LoginPassword" | grep string | sed -e 's/.*>\(.*\)<.*/\1/' | tr -d '\n'`
    fi 
fi 
}

GET_PASSWORD(){

printf '\r\n\n'

if [[ $PASSWORD = "" ]]; then GET_AUTH; fi

if [[ ! $PASSWORD = "" ]]; then
    if echo $PASSWORD | sudo -Sk printf '' 2>/dev/null; then
        printf '\r                                       \r'
        echo "  Пароль из программы принят"
    else
        printf '\r                                       \r'
        echo "  Пароль из программы не подходит"
        echo
        PASSWORD=""
    fi
fi
if [[ $PASSWORD = "" ]]; then
 var=0
printf '\r                                             \r'
attempt=3
while [[ ! $var = 1 ]]; 
do
    CLEAR_PLACE
 printf "\033[?25h"
printf '\n\n  Введите пароль для продолжения: '
read -s PASSWORD
if [[ ! $PASSWORD = "" ]]; then 
if echo $PASSWORD | sudo -Sk printf '' 2>/dev/null; then 
    printf '\n\n  Пароль принят \n'
    var=1
else
    printf "\033[?25l"
    printf '\n\n  Неверный пароль \n'
    read -n 1 -s -t 1
    printf '\r\033[2A'
    printf ' %.0s' {1..80}; printf ' %.0s' {1..80}
    printf ' %.0s' {1..80}; printf ' %.0s' {1..80}
    printf '\r\033[4A'
    let "attempt--"
    if [[ $attempt = 0 ]]; then
        PASSWORD=""
        var=1
    fi
fi
else
    printf '\r'
fi
done
printf "\033[?25l"
fi

echo $PASSWORD | sudo -S printf '' 2>/dev/null
printf '\r\033[1A'
printf ' %.0s' {1..80}; printf ' %.0s' {1..80}; printf ' %.0s' {1..80}
printf '\r\033[3A'
}

SET_INPUT(){

layout_name=`defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | egrep -w 'KeyboardLayout Name' | sed -E 's/.+ = "?([^"]+)"?;/\1/' | tr -d "\n"`
xkbs=1

case ${layout_name} in
 "Russian"          ) xkbs=2 ;;
 "RussianWin"       ) xkbs=2 ;;
 "Russian-Phonetic" ) xkbs=2 ;;
 "Ukrainian"        ) xkbs=2 ;;
 "Ukrainian-PC"     ) xkbs=2 ;;
 "Byelorussian"     ) xkbs=2 ;;
 esac

if [[ $xkbs = 2 ]]; then 
cd $(dirname $0)
    if [[ -f "./tools/xkbswitch" ]]; then 
declare -a layouts_names
layouts=`defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleInputSourceHistory | egrep -w 'KeyboardLayout Name' | sed -E 's/.+ = "?([^"]+)"?;/\1/' | tr  '\n' ';'`
IFS=";"; layouts_names=($layouts); unset IFS; num=${#layouts_names[@]}
keyboard="0"

while [ $num != 0 ]; do 
case ${layouts_names[$num]} in
 "ABC"                ) keyboard=${layouts_names[$num]} ;;
 "US Extended"        ) keyboard="USExtended" ;;
 "USInternational-PC" ) keyboard=${layouts_names[$num]} ;;
 "U.S."               ) keyboard="US" ;;
 "British"            ) keyboard=${layouts_names[$num]} ;;
 "British-PC"         ) keyboard=${layouts_names[$num]} ;;
esac

        if [[ ! $keyboard = "0" ]]; then num=1; fi
let "num--"
done

if [[ ! $keyboard = "0" ]]; then ./tools/xkbswitch -se $keyboard; fi
   else
        
printf '\r!!! Смените раскладку на латиницу !!! \n'
          
 fi
fi
}

function ProgressBar {

let _progress=(${1}*100/${2}*100)/100
let _done=(${_progress}*4)/10
let _left=40-$_done

_fill=$(printf "%${_done}s")
_empty=$(printf "%${_left}s")

printf "\r  Выполняется: ${_fill// /.}${_empty// / } ${_progress}%%"

}

CHECK_WHITELIST(){

board=`ioreg -lp IOService | grep board-id | awk -F"<" '{print $2}' | cut -c 2- | rev | cut -c 3- | rev`

legal=0
case "$board" in

"Mac-4BC72D62AD45599E" ) legal=1;;
"Mac-742912EFDBEE19B3" ) legal=1;;
"Mac-7BA5B2794B2CDB12" ) legal=1;;
"Mac-8ED6AF5B48C039E1" ) legal=1;;
"Mac-942452F5819B1C1B" ) legal=1;;
"Mac-942459F5819B171B" ) legal=1;;
"Mac-94245A3940C91C80" ) legal=1;;
"Mac-94245B3640C91C81" ) legal=1;;
"Mac-942B59F58194171B" ) legal=1;;
"Mac-942B5BF58194151B" ) legal=1;;
"Mac-942C5DF58193131B" ) legal=1;;
"Mac-C08A6BB70A942AC2" ) legal=1;;
"Mac-F2208EC8" ) legal=1;;
"Mac-F2218EA9" ) legal=1;;
"Mac-F2218EC8" ) legal=1;;
"Mac-F2218FA9" ) legal=1;;
"Mac-F2218FC8" ) legal=1;;
"Mac-F221BEC8" ) legal=1;;
"Mac-F221DCC8" ) legal=1;;
"Mac-F222BEC8" ) legal=1;;
"Mac-F2238AC8" ) legal=1;;
"Mac-F2238BAE" ) legal=1;;
"Mac-F22586C8" ) legal=1;;
"Mac-F22587A1" ) legal=1;;
"Mac-F22587C8" ) legal=1;;
"Mac-F22589C8" ) legal=1;;
"Mac-F2268AC8" ) legal=1;;
"Mac-F2268CC8" ) legal=1;;
"Mac-F2268DAE" ) legal=1;;
"Mac-F2268DC8" ) legal=1;;
"Mac-F2268EC8" ) legal=1;;
"Mac-F226BEC8" ) legal=1;;
"Mac-F22788AA" ) legal=1;;
"Mac-F227BEC8" ) legal=1;;
"Mac-F22C86C8" ) legal=1;;
"Mac-F22C89C8" ) legal=1;;
"Mac-F22C8AC8" ) legal=1;;
"Mac-F42C86C8" ) legal=1;;
"Mac-F42C89C8" ) legal=1;;
"Mac-F42C8CC8" ) legal=1;;
"Mac-F42D86A9" ) legal=1;;
"Mac-F42D86C8" ) legal=1;;
"Mac-F42D88C8" ) legal=1;;
"Mac-F42D89A9" ) legal=1;;
"Mac-F42D89C8" ) legal=1;;

esac

if [[ $legal = 0 ]]; then continuity=1
        else
scontinuity=`defaults read /System/Library/Frameworks/IOBluetooth.framework/Versions/A/Resources/SystemParameters.plist | grep -A 1 "$board" | grep ContinuitySupport`
continuity=`echo ${scontinuity//[^0-1]/}`
fi
if [[ $continuity = 1 ]]; then bt_check="сделано"; else bt_check="не сделано"; fi

}

SET_WHITELIST(){

cache_update=0
    if [[ $legal = 0 ]]; then sleep 0.1
        else 
            if [[ $continuity = 0 ]]; then 
               cp /System/Library/Frameworks/IOBluetooth.framework/Versions/A/Resources/SystemParameters.plist ~/.
               plutil -replace  $board.ContinuitySupport  -bool YES ~/SystemParameters.plist
               sudo cp ~/SystemParameters.plist /System/Library/Frameworks/IOBluetooth.framework/Versions/A/Resources/SystemParameters.plist
                rm -f ~/SystemParameters.plist
                cache_update=1
            fi
fi

sudo nvram bluetoothHostControllerSwitchBehavior=always

sleep 0.1

}

UNSET_WHITELIST(){

if [[ $legal = 0 ]]; then sleep 0.1
        else 
            if [[ $continuity = 1 ]]; then 
               cp /System/Library/Frameworks/IOBluetooth.framework/Versions/A/Resources/SystemParameters.plist ~/.
               plutil -replace  $board.ContinuitySupport  -bool NO ~/SystemParameters.plist
               sudo cp ~/SystemParameters.plist /System/Library/Frameworks/IOBluetooth.framework/Versions/A/Resources/SystemParameters.plist
                rm -f ~/SystemParameters.plist
                cache_update=1
            fi
fi
sleep 0.1

sudo nvram -d bluetoothHostControllerSwitchBehavior

}

CHECK_CONTINUITY(){
liluset=0; arptset=0; bt4leset=0; sle=0
if [[  -f "/System/Library/Extensions/Lilu.kext/Contents/Info.plist" ]]; then 
        sle=1; liluset=1 
        liluver=`plutil -p /System/Library/Extensions/Lilu.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
fi
if [[  -f "/System/Library/Extensions/AirportBrcmFixup.kext/Contents/Info.plist" ]]; then 
        sle=1; arptset=1 
        arpver=`plutil -p /System/Library/Extensions/AirportBrcmFixup.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
fi
if [  -f "/System/Library/Extensions/BT4LEContiunityFixup.kext/Contents/Info.plist" ]; then 
        sle=1; bt4leset=1
        bt4lever=`plutil -p /System/Library/Extensions/BT4LEContiunityFixup.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
 
fi
if [  -f "/System/Library/Extensions/BT4LEContinuityFixup.kext/Contents/Info.plist" ]; then 
        sle=1; bt4leset=1 
        bt4lever=`plutil -p /System/Library/Extensions/BT4LEContinuityFixup.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`

fi
if [  -f "/Library/Extensions/Lilu.kext/Contents/Info.plist" ]; then  
        liluset=1 
        liluver=`plutil -p /Library/Extensions/Lilu.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
fi
if [  -f "/Library/Extensions/AirportBrcmFixup.kext/Contents/Info.plist" ]; then  
        arptset=1 
        arpver=`plutil -p /Library/Extensions/AirportBrcmFixup.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
fi
if [  -f "/Library/Extensions/BT4LEContiunityFixup.kext/Contents/Info.plist" ]; then  
        bt4leset=1
        bt4lever=`plutil -p /Library/Extensions/BT4LEContiunityFixup.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
fi
if [  -f "/Library/Extensions/BT4LEContinuityFixup.kext/Contents/Info.plist" ]; then  
        bt4leset=1
        bt4lever=`plutil -p /Library/Extensions/BT4LEContinuityFixup.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
fi

if [ $liluset == 1 ] && [ $arptset == 1 ] && [ $bt4leset == 1 ]; then conti_check="установлены"; else conti_check="не установлены";  fi



}

CLEAR_PLACE(){

                    printf "\033[H"
                    printf "\033['$free_lines';0f"
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf '\r\033[9A'

}

DOWNLOAD_KEXTS(){

while :;do printf '.' ;sleep 0.5;done &
trap "kill $!" EXIT 
mkdir temp; cd temp
lilu_release=$(curl -s https://api.github.com/repos/acidanthera/Lilu/releases/latest | grep browser_download_url  | grep RELEASE | cut -d '"' -f 4)
curl -L -s -o new.zip $lilu_release 2>/dev/null
unzip  -o -qq new.zip 2>/dev/null
if [[ -d Lilu.kext ]]; then mv Lilu.kext ../Lilu.kext; fi
cd ..
rm -R -f temp/*
cd temp 
airpt_release=$(curl -s https://api.github.com/repos/acidanthera/AirportBrcmFixup/releases/latest | grep browser_download_url  | grep RELEASE | cut -d '"' -f 4)
curl -L -s -o new.zip $airpt_release 2>/dev/null
unzip  -o -qq new.zip 2>/dev/null
if [[ -d AirportBrcmFixup.kext ]]; then mv AirportBrcmFixup.kext ../AirportBrcmFixup.kext; fi
cd ..
rm -R -f temp/*
cd temp 
bt4le=$(curl -s https://api.github.com/repos/acidanthera/BT4LEContinuityFixup/releases/latest | grep browser_download_url  | grep RELEASE | cut -d '"' -f 4)
curl -L -s -o new.zip $bt4le 2>/dev/null
unzip  -o -qq new.zip 2>/dev/null
if [[ -d BT4LEContinuityFixup.kext ]]; then mv BT4LEContinuityFixup.kext ../BT4LEContinuityFixup.kext; fi
cd ..
rm -R temp
kill $!
wait $! 2>/dev/null
trap " " EXIT

}


SET_CONTINUITY(){
loca=0
if [[ ! -d ~/kexts ]]; then 
loca=1
printf '\n\n  Локально кексты не найдены! Проверяем интернет соединение!\n'
    if ping -c 1 google.com >> /dev/null 2>&1; then 
printf '\n  Загружаем кексты с github .'
mkdir ~/kexts; cd ~/kexts
DOWNLOAD_KEXTS
printf '.\n'
CLEAR_PLACE
cd ..
    else 
    printf '\n  \e[1;31mИнтернет соединение не доступно !!!\e[0m\n'
    sleep 6
    CLEAR_PLACE
    fi

fi

 if [[  -d ~/kexts/Lilu.kext ]] && [[ -d ~/kexts/BT4LEContinuityFixup.kext ]] && [[ -d ~/kexts/AirportBrcmFixup.kext ]]; then 
    printf '\n\n  Кексты получены.                                         \n'; sleep 0.5; ready=1
    



CLEAR_PLACE
printf '\n\n  Устанавливаем кексты для Continuity \n'

_start=1

_end=100

printf '\n\n'

if [[ $sle = 1 ]]; then
sleep 0.1 
number=1
ProgressBar ${number} ${_end}
sudo rm -R -f /System/Library/Extensions/BT4LEContiunityFixup.kext
sleep 0.1
number=3
ProgressBar ${number} ${_end}
sudo rm -R -f /System/Library/Extensions/BT4LEContinuityFixup.kext
sleep 0.1
number=5
ProgressBar ${number} ${_end}
sudo rm -R -f /System/Library/Extensions/Lilu.kext
sleep 0.1
number=7
ProgressBar ${number} ${_end}
sudo rm -R -f /System/Library/Extensions/AirportBrcmFixup.kext
fi
sleep 0.1
number=10
ProgressBar ${number} ${_end}
sudo rm -R -f /Library/Extensions/BT4LEContiunityFixup.kext
sleep 0.1
number=13
ProgressBar ${number} ${_end}
sudo rm -R -f /Library/Extensions/BT4LEContinuityFixup.kext
sleep 0.1
number=17
ProgressBar ${number} ${_end}
sudo rm -R -f /Library/Extensions/Lilu.kext
sleep 0.1
number=20
ProgressBar ${number} ${_end}
sudo rm -R -f /Library/Extensions/AirportBrcmFixup.kext
sleep 0.1
number=25
ProgressBar ${number} ${_end}
sudo cp -R ~/kexts/Lilu.kext /Library/Extensions/
sleep 0.1
number=30
ProgressBar ${number} ${_end}
sudo chown -R 0:0 /Library/Extensions/Lilu.kext
sleep 0.1
number=35
ProgressBar ${number} ${_end}
sudo chmod -R 755 /Library/Extensions/Lilu.kext
sleep 0.1
number=40
ProgressBar ${number} ${_end}
sudo cp -R ~/kexts/BT4LEContinuityFixup.kext /Library/Extensions/
sleep 0.1
number=50
ProgressBar ${number} ${_end}
sudo chown -R 0:0 /Library/Extensions/BT4LEContinuityFixup.kext
sleep 0.1
number=60
ProgressBar ${number} ${_end}
sudo chmod -R 755 /Library/Extensions/BT4LEContinuityFixup.kext
sleep 0.1
number=70
ProgressBar ${number} ${_end}
sudo cp -R ~/kexts/AirportBrcmFixup.kext /Library/Extensions/
sleep 0.1
number=80
ProgressBar ${number} ${_end}
sudo chown -R 0:0 /Library/Extensions/AirportBrcmFixup.kext
sleep 0.1
number=90
ProgressBar ${number} ${_end}
sudo chmod -R 755 /Library/Extensions/AirportBrcmFixup.kext
sleep 0.1
number=100
ProgressBar ${number} ${_end}
sleep 0.1

else
    ready=0
    printf  '\n\n    Кексты не загружены. Что-то пошло не так !!!\n'

fi


}

UNSET_CONTINUITY(){

_start=1

_end=100

printf '\n\n'

if [[ $sle = 1 ]]; then
sleep 0.1 
number=1
ProgressBar ${number} ${_end}
sudo rm -R -f /System/Library/Extensions/BT4LEContiunityFixup.kext
sleep 0.1
number=13
ProgressBar ${number} ${_end}
sudo rm -R -f /System/Library/Extensions/BT4LEContinuityFixup.kext
sleep 0.1
number=26
ProgressBar ${number} ${_end}
sudo rm -R -f /System/Library/Extensions/Lilu.kext
sleep 0.1
number=39
ProgressBar ${number} ${_end}
sudo rm -R -f /System/Library/Extensions/AirportBrcmFixup.kext
fi
sleep 0.1
number=45
ProgressBar ${number} ${_end}
sudo rm -R -f /Library/Extensions/BT4LEContiunityFixup.kext
sleep 0.1
number=58
ProgressBar ${number} ${_end}
sudo rm -R -f /Library/Extensions/BT4LEContinuityFixup.kext
sleep 0.1
number=70
ProgressBar ${number} ${_end}
sudo rm -R -f /Library/Extensions/Lilu.kext
sleep 0.1
number=85
ProgressBar ${number} ${_end}
sudo rm -R -f /Library/Extensions/AirportBrcmFixup.kext
sleep 0.1
number=100
ProgressBar ${number} ${_end}
sleep 0.5

ready=1
}

CHECK_SPINDUMP(){
spin_check="остановлены"
if [[ -f /System/Library/LaunchDaemons/com.apple.spindump.plist ]]; then spin_check="не остановлены"; fi
if [[ -f /System/Library/LaunchDaemons/com.apple.tailspind.plist ]]; then spin_check="не остановлены"; fi
}

UNSET_SPINDUMP(){
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.spindump.plist >&- 2>&-
sudo mv /System/Library/LaunchDaemons/com.apple.spindump.plist /System/Library/LaunchDaemons/com.apple.spindump.plist.bak >&- 2>&-
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.tailspind.plist >&- 2>&-
sudo mv /System/Library/LaunchDaemons/com.apple.tailspind.plist /System/Library/LaunchDaemons/com.apple.tailspind.plist.bak >&- 2>&-
sleep 0.1

}

SET_SPINDUMP(){
sudo mv /System/Library/LaunchDaemons/com.apple.spindump.plist.bak /System/Library/LaunchDaemons/com.apple.spindump.plist >&- 2>&-
sudo mv /System/Library/LaunchDaemons/com.apple.tailspind.plist.bak /System/Library/LaunchDaemons/com.apple.tailspind.plist >&- 2>&-
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.spindump.plist >&- 2>&-
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.tailspind.plist >&- 2>&-
sleep 0.1
}

CHECK_ERROR_REPORT(){
err_check="сделано"
if [[ -f /System/Library/LaunchAgents/com.apple.ReportCrash.plist ]]; then err_check="не сделано"; fi
if [[ -f /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist ]]; then err_check="не сделано"; fi

}

UNSET_ERROR_REPORT(){
sudo launchctl unload -w /System/Library/LaunchAgents/com.apple.ReportCrash.plist  >&- 2>&-
sudo mv /System/Library/LaunchAgents/com.apple.ReportCrash.plist /System/Library/LaunchAgents/com.apple.ReportCrash.plist.back  >&- 2>&-
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist  >&- 2>&-
sudo mv /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist.back  >&- 2>&-
sleep 0.1
}

SET_ERROR_REPORT(){
sudo mv /System/Library/LaunchAgents/com.apple.ReportCrash.plist.back /System/Library/LaunchAgents/com.apple.ReportCrash.plist  >&- 2>&-
sudo mv /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist.back /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist  >&- 2>&-
sudo launchctl load -w /System/Library/LaunchAgents/com.apple.ReportCrash.plist
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist  >&- 2>&-
}

CHECK_DASH(){
dash=$(defaults read  com.apple.dashboard mcx-disabled  2>/dev/null)
if [[ $dash = 1 ]]; then dash_check="сделано"; else dash_check="не сделано"; fi
}

UNSET_DASH(){
defaults write com.apple.dashboard mcx-disabled -boolean TRUE 
killall Dock
}

SET_DASH(){
defaults delete com.apple.dashboard mcx-disabled >&- 2>&-
killall Dock >&- 2>&-
sleep 0.1
}

CHECK_AUTODOCK(){
dock=$(defaults read  com.apple.dock autohide-delay 2>/dev/null)
if [[ $dock = 0 ]]; then dock_check="сделано"; else dock_check="не сделано"; fi

}

SET_AUTODOCK(){
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
killall Dock
sleep 0.1
}

UNSET_AUTODOCK(){
defaults write com.apple.dock autohide-delay -float 1 
defaults delete com.apple.dock autohide-time-modifier 
killall Dock 
sleep 0.1
}

CHECK_KEYS(){
unset bakt; unset tild
keys_check="не сделан"
if [[ -d ~/Library/KeyBindings ]]; then 
    if [[ -f ~/Library/KeyBindings/DefaultKeyBinding.dict ]]; then
         bakt=$(cat ~/Library/KeyBindings/DefaultKeyBinding.dict | grep '`')
        if [[ "$bakt" = '"§" = ("insertText:", "`");' ]]; then bakt=1; else bakt=0; fi
         tild=$(cat ~/Library/KeyBindings/DefaultKeyBinding.dict | grep '~')
        if [[ "$tild" = '"±" = ("insertText:", "~");' ]]; then tild=1; else tild=0; fi
    fi
fi
if [[ $bakt = 1 ]] && [[ $tild = 1 ]]; then keys_check="сделан"; fi

}

UNSET_KEYS(){
rm -f ~/Library/KeyBindings/DefaultKeyBinding.dict
}

SET_KEYS(){
if [[ ! -d ~/Library/KeyBindings ]]; then mkdir ~/Library/KeyBindings; fi
echo '"§" = ("insertText:", "`");' >> ~/Library/KeyBindings/DefaultKeyBinding.dict
echo '"±" = ("insertText:", "~");' >> ~/Library/KeyBindings/DefaultKeyBinding.dict
sleep 0.1

}

CHECK_MRT(){
mrt=0
if [[ -f /System/Library/LaunchDaemons/com.apple.MRTd.plist ]]; then mrt=1; fi
if [[ -d /System/Library/CoreServices/MRT.app ]]; then mrt=1; fi
if [[ -f /System/Library/LaunchAgents/com.apple.MRTa.plist ]]; then mrt=1; fi
if [[ $mrt = 1 ]]; then mrt_chk="не сделано"; else mrt_chk="сделано"; fi
}

UNSET_MRT(){
if [[ $(sudo ps xca | grep MRT | grep -oE '[^ ]+$' | tr -d " \n") = "MRT" ]]; then sudo killall MRT ; fi 2>&-
sudo mv /System/Library/CoreServices/MRT.app /System/Library/CoreServices/MRT.app.bak >&- 2>&-
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.MRTd.plist >&- 2>&-
sudo launchctl unload -w /System/Library/LaunchAgents/com.apple.MRTa.plist  >&- 2>&-
sudo mv /System/Library/LaunchDaemons/com.apple.MRTd.plist /System/Library/LaunchDaemons/com.apple.MRTd.plist.bak >&- 2>&-
sudo mv /System/Library/LaunchAgents/com.apple.MRTa.plist /System/Library/LaunchAgents/com.apple.MRTa.plist.bak >&- 2>&-
}

SET_MRT(){
if [[ -f /System/Library/LaunchAgents/com.apple.MRTa.plist.bak ]]; then 
         sudo mv /System/Library/LaunchAgents/com.apple.MRTa.plist.bak /System/Library/LaunchAgents/com.apple.MRTa.plist >&- 2>&-
         sudo launchctl load -w /System/Library/LaunchAgents/com.apple.MRTa.plist >&- 2>&-
fi
if [[ -d /System/Library/CoreServices/MRT.app.bak ]]; then
       sudo mv /System/Library/CoreServices/MRT.app.bak /System/Library/CoreServices/MRT.app >&- 2>&-
fi
if [[ -f /System/Library/LaunchDaemons/com.apple.MRTd.plist.bak ]]; then 
        sudo mv /System/Library/LaunchDaemons/com.apple.MRTd.plist.bak /System/Library/LaunchDaemons/com.apple.MRTd.plist >&- 2>&-
        sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.MRTd.plist >&- 2>&-
fi
sleep 1
if [[ $(sudo ps xca | grep MRT | grep -oE '[^ ]+$' | tr -d " \n") = "MRT" ]]; then sudo killall MRT ; fi 2>&-
}

GET_INPUT(){

unset inputs
while [[ ! ${inputs} =~ ^[0-9qQaAbBcC]+$ ]]; do
printf "\033[?25l"
SET_INPUT              
printf '  Введите символ от \e[1;33m0\e[0m до \e[1;36mC\e[0m, (или \e[1;35mQ\e[0m - выход ):   ' ; printf '                             '
			
printf "%"80"s"'\n'"%"80"s"'\n'"%"80"s"'\n'"%"80"s"
printf "\033[4A"
printf "\r\033[46C"
printf "\033[?25h"
IFS="±"; read -n 1 inputs ; unset IFS 
if [[ ${inputs} = "" ]]; then printf "\033[1A"; fi
printf "\r"
done
printf "\033[?25l"

}

SHOW_MENU(){

CHECK_CONTINUITY
CHECK_WHITELIST
CHECK_SPINDUMP
CHECK_ERROR_REPORT
CHECK_AUTODOCK
CHECK_DASH
CHECK_KEYS
CHECK_MRT

free_lines=21

printf '\e[8;'${lines}';80t' && printf '\e[3J' && printf "\033[0;0H"

printf '\e[2m************** \e[0m\e[36mНастройка после установки мак ос на макбук 6,1/7,1\e[0m\e[2m **************\e[0m\n'
printf '\e[2m****** \e[0m\e[36mНаличие модуля Bluetooth HCI 4.0+ c LE для continuity обязательно\e[0m\e[2m *******\e[0m\n'
printf '\e[2m**************.................. \e[0m\e[36mВерсия 1,1\e[0m\e[2m ......................**************\e[0m\n'

printf '\n\e[2m                       Версия '
printf "`sw_vers -productName`"
printf ': '; printf "`sw_vers -productVersion`" 
printf '('
printf "`sw_vers -buildVersion`"
printf ') '
printf '     \n\n\e[0m'


printf '          \e[33m1.\e[0m Расширения ядра для Continuity \e[1;33m'"$conti_check"'\e[0m.                   \n'
                        if [[ $liluset = 1 ]]; then 
printf '                \e[1;32mLilu.kext v. '$liluver'\e[0m                                           \n'; let "free_lines++"; fi
                        if [[ $arptset = 1 ]]; then
printf '                \e[1;32mAirportBrcmFixup.kext v. '$arpver'\e[0m                               \n'; let "free_lines++"; fi
                        if [[ $bt4leset = 1 ]]; then
printf '                \e[1;32mBT4LEContinuityFixup.kext v. '$bt4lever'\e[0m                           \n'; let "free_lines++"; fi

printf '          \e[1;33m2.\e[0m Разрешение сценария Continuity \e[1;33m'"$bt_check"'\e[0m.                       \n'
printf '          \e[1;33m3.\e[0m Дамперы процессов spindump и tailspin \e[1;33m'"$spin_check"'\e[0m.            \n'

printf '          \e[1;33m4.\e[0m Отключение процесса ErrorReport \e[1;33m'"$err_check"'\e[0m.                      \n'

printf '          \e[1;33m5.\e[0m Ускорить автопоявление дока \e[1;33m'"$dock_check"'\e[0m.                          \n'
printf '          \e[1;33m6.\e[0m Отключить Dashboard         \e[1;33m'"$dash_check"'\e[0m.                          \n'
printf '          \e[1;33m7.\e[0m Патч для тильды и бактика \e[1;33m'"$keys_check"'\e[0m.                             \n'
printf '          \e[1;33m8.\e[0m Удаление Apple Malware Removal Tool \e[1;33m'"$mrt_chk"'\e[0m.                  \n'
printf '          \e[1;36m9.\e[0m Обновление кекстов для Continuity через интернет                 \n'
printf '          \e[1;36mA.\e[0m Применить все изменения пунктов с \e[1;33m1.\e[0m по \e[1;33m8.\e[0m                       \n'
printf '          \e[1;36mB.\e[0m Отменить все изменения пунктов с \e[1;33m1.\e[0m по \e[1;33m8.\e[0m                        \n'
printf '          \e[1;36mС.\e[0m Хранить пароль в программе                                       \n'
printf ' %.0s' {1..80}
printf '\n'
}

DO_ALL(){
rm -f  ~/.pi_temp.txt
printf '\n\n  Выполнить все исправления по списку с 1 - 8 ( Y/n )? '
read -n 1 -s 
if [[ $REPLY =~ ^[yY]$ ]] || [[ $REPLY = "" ]]; then 
CLEAR_PLACE 
GET_PASSWORD
if [[ ! $PASSWORD = "" ]]; then
CLEAR_PLACE
printf '\n\n     Отключаем spindump и tailspin     ... '
printf '\n\n     Отключаем spindump и tailspin     ...   \e[1;32mOK!\e[0m \n' >> ~/.pi_temp.txt
CHECK_SPINDUMP
    if [[ ! $spin_check = "остановлены" ]]; then
        UNSET_SPINDUMP
    fi
sleep 0.3
printf '  \e[1;32mOK!\e[0m \n'
printf '     Отключаем ErrorReporter           ... '
printf '     Отключаем ErrorReporter           ...   \e[1;32mOK!\e[0m \n' >> ~/.pi_temp.txt
CHECK_ERROR_REPORT
    if [[ ! $err_check = "сделано" ]]; then
        UNSET_ERROR_REPORT
    fi
sleep 0.3
printf '  \e[1;32mOK!\e[0m \n'
printf '     Ускоряем автоскрытие дока         ... '
printf '     Ускоряем автоскрытие дока         ...   \e[1;32mOK!\e[0m \n' >> ~/.pi_temp.txt
CHECK_AUTODOCK
        if [[ ! $dock = 0 ]]; then
            SET_AUTODOCK
        fi
sleep 0.3
printf '  \e[1;32mOK!\e[0m \n'

printf '     Отключаем Dashboard               ... '
printf '     Отключаем Dashboard               ...   \e[1;32mOK!\e[0m \n' >> ~/.pi_temp.txt
CHECK_DASH
    if [[ ! $dash_check = "сделано" ]]; then
        UNSET_DASH
    fi
sleep 0.3
printf '  \e[1;32mOK!\e[0m \n'

printf '     Прописываем тильду и бактик       ... '
printf '     Прописываем тильду и бактик       ...   \e[1;32mOK!\e[0m \n' >> ~/.pi_temp.txt
CHECK_KEYS
        if [[ ! $keys_check = "сделан" ]]; then
            SET_KEYS
        fi
sleep 0.3
printf '  \e[1;32mOK!\e[0m \n'

printf '     Отключаем MRT                     ... '
printf '     Отключаем MRT                     ...   \e[1;32mOK!\e[0m \n' >> ~/.pi_temp.txt
 CHECK_MRT
            if [[ $mrt = 1 ]]; then
                    UNSET_MRT
            fi
sleep 0.3
printf '  \e[1;32mOK!\e[0m \n'

printf '     Разрешаем сценарий Continuity     ... '
printf '     Разрешаем сценарий Continuity     ... ' >> ~/.pi_temp.txt
CHECK_WHITELIST
    if [[ ! $legal = 0 ]]; then
            if [[ ! $continuity = 1 ]]; then
                SET_WHITELIST
                CLEAR_PLACE
                printf '\n\n  Обновляем кэш системных сценариев\n'
                    printf '\n  Выполняется: '
                    while :;do printf '.';sleep 3;done &
                    trap "kill $!" EXIT 
                    sudo update_dyld_shared_cache -debug -force -root / 2>/dev/null
                    kill $!
                    wait $! 2>/dev/null
                    trap " " EXIT
                    
                    CLEAR_PLACE
                    printf '\n\n  Необходимый таймаут !\n\n'
                    TIMEOUT
                    CLEAR_PLACE
                    cat ~/.pi_temp.txt
                          
            fi
    fi
sleep 0.3
printf '  \e[1;32mOK!\e[0m \n'
printf '  \e[1;32mOK!\e[0m \n' >> ~/.pi_temp.txt
sleep 0.5
printf '     Установка кекстов для Continuity  ... '
printf '     Установка кекстов для Continuity  ... ' >> ~/.pi_temp.txt
CHECK_CONTINUITY
            if [[ ! $conti_check = "установлены" ]]; then
                CLEAR_PLACE
                printf '\n\n  Устанавливаем кексты для Continuity'
                SET_CONTINUITY
                if [[ $ready = 1 ]]; then 
                    CLEAR_PLACE
                    printf '\n\n  Обновляем системный кэш.\n'
                    printf '\n  Выполняется: '
                    while :;do printf '.' ;sleep 3;done &
                    trap "kill $!" EXIT 
                    sudo touch /Library/Extensions >&- 2>&-
                    sudo kextcache -i /  >&- 2>&-
                    kill $!
                    wait $! 2>/dev/null
                    trap " " EXIT
                    CLEAR_PLACE
                    printf '\n\n  Необходимый таймаут !\n\n'
                    TIMEOUT
                fi
                    CLEAR_PLACE
                    cat ~/.pi_temp.txt
                else
                    ready=1
             fi
if [[ $ready = 1 ]]; then
printf '  \e[1;32mOK!\e[0m '
printf '  \e[1;32mOK!\e[0m ' >> ~/.pi_temp.txt
else
printf '  \e[1;31mНЕУДАЧА!\e[0m '
printf '  \e[1;31mНЕУДАЧА!\e[0m ' >> ~/.pi_temp.txt
fi

read -n 1 -r -t 5
fi
fi
CLEAR_PLACE
rm -f  ~/.pi_temp.txt
}

UNDO_ALL(){
rm -f  ~/.pi_temp.txt
printf '\n\n  Отменить все исправления по списку с 1 - 8 ( Y/n )? '
read -n 1 -s 
if [[ $REPLY =~ ^[yY]$ ]] || [[ $REPLY = "" ]]; then 
CLEAR_PLACE 
GET_PASSWORD
if [[ ! $PASSWORD = "" ]]; then
CLEAR_PLACE
printf '\n\n     Включаем spindump и tailspin      ... '
printf '\n\n     Включаем spindump и tailspin      ...   \e[1;32mOK!\e[0m \n' >> ~/.pi_temp.txt
CHECK_SPINDUMP
    if [[ $spin_check = "остановлены" ]]; then
        SET_SPINDUMP
    fi
sleep 0.3
printf '  \e[1;32mOK!\e[0m \n'
printf '     Включаем ErrorReporter            ... '
printf '     Включаем ErrorReporter            ...   \e[1;32mOK!\e[0m \n' >> ~/.pi_temp.txt
CHECK_ERROR_REPORT
    if [[ $err_check = "сделано" ]]; then
        SET_ERROR_REPORT
    fi
sleep 0.3
printf '  \e[1;32mOK!\e[0m \n'
printf '     Замедляем автоскрытие дока        ... '
printf '     Замедляем автоскрытие дока        ...   \e[1;32mOK!\e[0m \n' >> ~/.pi_temp.txt
CHECK_AUTODOCK
        if [[ $dock = 0 ]]; then
            UNSET_AUTODOCK
        fi
sleep 0.3
printf '  \e[1;32mOK!\e[0m \n'
printf '     Включаем Dashboard                ... '
printf '     Включаем Dashboard                ...   \e[1;32mOK!\e[0m \n' >> ~/.pi_temp.txt
CHECK_DASH
    if [[ $dash_check = "сделано" ]]; then
          SET_DASH
    fi
sleep 0.3
printf '  \e[1;32mOK!\e[0m \n'

printf '     Отменяем пропись тильды и бактикa ... '
printf '     Отменяем пропись тильды и бактикa ...   \e[1;32mOK!\e[0m \n' >> ~/.pi_temp.txt
CHECK_KEYS
        if [[ $keys_check = "сделан" ]]; then
            UNSET_KEYS
        fi
sleep 0.3
printf '  \e[1;32mOK!\e[0m \n'

printf '     Включаем MRT                      ... '
printf '     Включаем MRT                      ...   \e[1;32mOK!\e[0m \n' >> ~/.pi_temp.txt
 CHECK_MRT
            if [[ ! $mrt = 1 ]]; then
                    SET_MRT
            fi
sleep 0.3
printf '  \e[1;32mOK!\e[0m \n'

printf '     Запрещаем сценарий Continuity     ... '
printf '     Запрещаем сценарий Continuity     ... ' >> ~/.pi_temp.txt
CHECK_WHITELIST
    if [[ ! $legal = 0 ]]; then
            if [[ $continuity = 1 ]]; then
                UNSET_WHITELIST
                CLEAR_PLACE
                printf '\n\n  Обновляем кэш системных сценариев\n'
                    printf '\n  Выполняется: '
                    while :;do printf '.';sleep 3;done &
                    trap "kill $!" EXIT 
                    sudo update_dyld_shared_cache -debug -force -root / 2>/dev/null
                    kill $!
                    wait $! 2>/dev/null
                    trap " " EXIT
                    
                    CLEAR_PLACE
                    printf '\n\n  Необходимый таймаут !\n\n'
                    TIMEOUT
                    CLEAR_PLACE
                    cat ~/.pi_temp.txt
                          
            fi
    fi
sleep 0.3
printf '  \e[1;32mOK!\e[0m \n'
printf '  \e[1;32mOK!\e[0m \n' >> ~/.pi_temp.txt
sleep 0.5
printf '     Удаление кекстов для Continuity   ... '
printf '     Удаление кекстов для Continuity   ... ' >> ~/.pi_temp.txt
CHECK_CONTINUITY
            if [[ $conti_check = "установлены" ]]; then
                CLEAR_PLACE
                printf '\n\n  Удаляем кексты для Continuity'
                UNSET_CONTINUITY
                    CLEAR_PLACE
                    printf '\n\n  Обновляем системный кэш.\n'
                    printf '\n  Выполняется: '
                    while :;do printf '.' ;sleep 3;done &
                    trap "kill $!" EXIT 
                    sudo touch /Library/Extensions >&- 2>&-
                    sudo kextcache -i /  >&- 2>&-
                    kill $!
                    wait $! 2>/dev/null
                    trap " " EXIT
                    CLEAR_PLACE
                    printf '\n\n  Необходимый таймаут !\n\n'
                    TIMEOUT
                    CLEAR_PLACE
                    cat ~/.pi_temp.txt
             fi
printf '  \e[1;32mOK!\e[0m '
printf '  \e[1;32mOK!\e[0m ' >> ~/.pi_temp.txt

read -n 1 -r -t 5
CLEAR_PLACE
rm -f  ~/.pi_temp.txt
fi
fi
}

TIMEOUT(){

_start=1

_end=100

for number in $(seq ${_start} ${_end})
do
sleep 0.4
ProgressBar ${number} ${_end}
done

}

GET_GITHUB_VERSIONS(){
printf '\n  Проверяем интернет соединение!\n'
    if ping -c 1 google.com >> /dev/null 2>&1; then 
        net=1
printf '\n  Читаем версии кекстов на github .'
lilu_git=$( curl -s https://api.github.com/repos/acidanthera/Lilu/releases/latest | grep browser_download_url  | grep RELEASE | cut -d '"' -f 4 | rev | cut -d '/' -f1  | rev | sed s/[^0-9]//g | tr -d ' \n\t')
arpt_git=$(curl -s https://api.github.com/repos/acidanthera/AirportBrcmFixup/releases/latest | grep browser_download_url  | grep RELE | cut -d '"' -f 4 | rev | cut -d '/' -f1  | rev | sed s/[^0-9]//g | tr -d ' \n\t')
bt_git=$(curl -s https://api.github.com/repos/acidanthera/BT4LEContinuityFixup/releases/latest | grep browser_download_url  | grep EASE | cut -d '"' -f 4 | rev | cut -d '/' -f1  | rev | sed s/[^0-9]//g | tr -d ' \n\t')
    else
        net=0
        printf '\n  \e[1;31mИнтернет соединение недоступно !!!\e[0m\n'
fi 
}

GET_INSTALLED_VERSIONS(){
lilu_sver="0.0.0"
if [[ -d /System/Library/Extensions/Lilu.kext ]]; then
lilu_sver=`plutil -p /System/Library/Extensions/Lilu.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
else
    if [[ -d /Library/Extensions/Lilu.kext ]]; then
lilu_sver=`plutil -p /Library/Extensions/Lilu.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
    fi
fi
lilu_ver=$(echo $lilu_sver | sed s/[^0-9]//g | tr -d ' \n\t'); if [[ $lilu_ver = "000" ]]; then lilu_ver=0; fi

arpt_sver="0.0.0"
if [[ -d /System/Library/Extensions/AirportBrcmFixup.kext ]]; then
arpt_sver=`plutil -p /System/Library/Extensions/AirportBrcmFixup.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
else
    if [[ -d /Library/Extensions/AirportBrcmFixup.kext ]]; then
arpt_sver=`plutil -p /Library/Extensions/AirportBrcmFixup.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
    fi
fi
arpt_ver=$(echo $arpt_sver | sed s/[^0-9]//g | tr -d ' \n\t'); if [[ $arpt_ver = "000" ]]; then arpt_ver=0; fi

bt_sver="0.0.0"
if [[ -d /System/Library/Extensions/BT4LEContinuityFixup.kext ]]; then
bt_sver=`plutil -p /System/Library/Extensions/BT4LEContinuityFixup.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
else
    if [[ -d /Library/Extensions/BT4LEContinuityFixup.kext ]]; then
bt_sver=`plutil -p /Library/Extensions/BT4LEContinuityFixup.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
    fi
fi
bt_ver=$(echo $bt_sver | sed s/[^0-9]//g | tr -d ' \n\t'); if [[ $bt_ver = "000" ]]; then bt_ver=0; fi

if [[ $bt_sver = "0.0.0" ]]; then

    if [[ -d /System/Library/Extensions/BT4LEContiunityFixup.kext ]]; then
    bt_sver=`plutil -p /System/Library/Extensions/BT4LEContiunityFixup.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
    else
        if [[ -d /Library/Extensions/BT4LEContiunityFixup.kext ]]; then
        bt_sver=`plutil -p /Library/Extensions/BT4LEContiunityFixup.kext/Contents/Info.plist | grep CFBundleVersion | awk -F"=> " '{print $2}' | cut -c 2- | rev | cut -c 2- | rev`
        fi
    fi
  bt_ver=$(echo $bt_sver | sed s/[^0-9]//g | tr -d ' \n\t'); if [[ $bt_ver = "000" ]]; then bt_ver=0; fi
fi
}

SHOW_KEXTS_VERSIONS(){
b_col=33
if [[ $bt_ver = 0 ]] && [[ ! $bt_git = 0 ]]; then bt_show="можно установить"
    else
if [[ $bt_ver -lt $bt_git ]]; then bt_show="можно обновить";  else bt_show="не нужно обновлять"; b_col=32; fi 
fi

l_col=33
if [[ $lilu_ver = 0 ]] && [[ ! $lilu_git = 0 ]]; then lilu_show="можно установить"
    else
if [[ $lilu_ver -lt $lilu_git ]]; then lilu_show="можно обновить"; else lilu_show="не нужно обновлять"; l_col=32; fi 
fi

a_col=33
if [[ $arpt_ver = 0 ]] && [[ ! $arpt_git = 0 ]]; then arpt_show="можно установить"
    else
if [[ $arpt_ver -lt $arpt_git ]]; then arpt_show="можно обновить"; else arpt_show="не нужно обновлять"; a_col=32; fi 
fi


printf '\n\n  Доступны версии кекстов: \n\n'
printf '      \e[1;32mLilu.kext\e[0m                  v. '${lilu_git:0:1}'.'${lilu_git:1:1}'.'${lilu_git:2:1}'   \e[1;'$l_col'm'"$lilu_show"'\e[0m\n'
printf '      \e[1;32mAirportBrcmFixup.kext\e[0m      v. '${arpt_git:0:1}'.'${arpt_git:1:1}'.'${arpt_git:2:1}'   \e[1;'$a_col'm'"$arpt_show"'\e[0m\n'
printf '      \e[1;32mBT4LEContinuityFixup.kext\e[0m  v. '${bt_git:0:1}'.'${bt_git:1:1}'.'${bt_git:2:1}'   \e[1;'$b_col'm'"$bt_show"'\e[0m\n\n'

}

GET_GITHUB_KEXTS(){
printf '\n\n  Проверяем интернет соединение!\n'
    if ping -c 1 google.com >> /dev/null 2>&1; then 
        net=1
printf '\n  Загружаем кексты с github .'

rm -R -f ~/net_kexts
mkdir ~/net_kexts; cd ~/net_kexts
DOWNLOAD_KEXTS
printf '.\n'
cd ..
    else 
        net=0
        printf '\n  \e[1;31mИнтернет соединение недоступно !!!\e[0m\n\n'
fi

}

UPDATE_KEXTS(){

while :;do printf '.'; sleep 0.1; done &
trap "kill $!" EXIT 
sleep 0.2
if [[ $b_col = 32 ]] && [[ $a_col = 32 ]] && [[ $l_col = 32 ]] && [[  $REPLY =~ ^[yY]$ ]]; then b_col=33; a_col=33; l_col=33; fi
if [[ $b_col = 33 ]]; then
    if [[ -d ~/net_kexts/BT4LEContinuityFixup.kext ]]; then
        sudo rm -R -f /System/Library/Extensions/BT4LEContiunityFixup.kext
        sudo rm -R -f /System/Library/Extensions/BT4LEContinuityFixup.kext
        sudo rm -R -f /Library/Extensions/BT4LEContiunityFixup.kext
        sudo rm -R -f /Library/Extensions/BT4LEContinuityFixup.kext
        sudo mv ~/net_kexts/BT4LEContinuityFixup.kext /Library/Extensions/BT4LEContinuityFixup.kext
        sudo chown -R 0:0 /Library/Extensions/BT4LEContinuityFixup.kext 
        sudo chmod -R 755 /Library/Extensions/BT4LEContinuityFixup.kext
    fi
fi
sleep 0.2

if [[ $l_col = 33 ]]; then
    if [[ -d ~/net_kexts/Lilu.kext ]]; then
        sudo rm -R -f /System/Library/Extensions/Lilu.kext
        sudo rm -R -f /Library/Extensions/Lilu.kext
        sudo mv ~/net_kexts/Lilu.kext /Library/Extensions/Lilu.kext
        sudo chown -R 0:0 /Library/Extensions/Lilu.kext 
        sudo chmod -R 755 /Library/Extensions/Lilu.kext
    fi
fi
sleep 0.2

if [[ $a_col = 33 ]]; then
    if [[ -d ~/net_kexts/AirportBrcmFixup.kext ]]; then
        sudo rm -R -f /System/Library/Extensions/AirportBrcmFixup.kext
        sudo rm -R -f /Library/Extensions/AirportBrcmFixup.kext
        sudo mv ~/net_kexts/AirportBrcmFixup.kext /Library/Extensions/AirportBrcmFixup.kext
        sudo chown -R 0:0 /Library/Extensions/AirportBrcmFixup.kext 
        sudo chmod -R 755 /Library/Extensions/AirportBrcmFixup.kext
    fi
fi
sleep 0.2
kill $!
wait $! 2>/dev/null
trap " " EXIT
rm -R -f ~/net_kexts        
}

# Установка/удаление пароля для sudo через конфиг
SET_USER_PASSWORD(){

login=`cat ~/.auth/auth.plist | grep -Eo "LoginPassword"  | tr -d '\n'`
    if [[ $login = "LoginPassword" ]]; then
                printf '\n\n'
                printf '  \e[35mУдалить\e[0m сохранённый пароль из программы \e[35m?\e[0m \e[1;33m(y/N)\e[0m \n'
                
                read  -n 1 -r -s
                if [[ $REPLY =~ ^[yY]$ ]]; then
                plutil -remove LoginPassword ~/.auth/auth.plist
                CLEAR_PLACE
                printf '\n\n'
                printf '  \e[35mПароль удалён.\e[0m нажмите любую клавишу для выхода в меню ...\n'
                read -n 1 demo
                fi
        else
                var2=3
                while [[ ! $var2 = 0 ]] 
                do
                CLEAR_PLACE
                printf "\033[?25h"
                printf '\n\n  Введите ваш пароль для постоянного хранения: '
                read -s mypassword
                printf "\033[?25l"
                if [[ $mypassword = "" ]]; then mypassword="?"; fi
                if echo $mypassword | sudo -Sk printf '' 2>/dev/null; then
                var2=0
                plutil -replace LoginPassword -string $mypassword ~/.auth/auth.plist
                
                printf '\n\n  Пароль \e[32m'$mypassword'\e[0m сохранён.                \n'
                PASSWORD="${mypassword}"
                read -n 1 -s -t 2
                else
                printf '\n\n  Не верный пароль \e[33m'$mypassword'\e[0m не сохранён.      \n'
                let "var2--"
                read -n 1 -s -t 2
                 
            fi 
                 done
                 CLEAR_PLACE
                
        fi
    

}
######################################## MAIN ##########################################################################################

var4=0
while [ $var4 != 1 ] 
do
printf '\e[3J' && printf "\033[0;0H" 
printf "\033[?25l"
SHOW_MENU
GET_INPUT

if [[ $inputs = 1 ]]; then
        CHECK_CONTINUITY
        GET_PASSWORD
    if [[ ! $PASSWORD = "" ]]; then
        CLEAR_PLACE
            if [[ $conti_check = "установлены" ]]; then
                printf '\n\n  Удаляем кексты для Continuity'
                UNSET_CONTINUITY
            else
                printf '\n\n  Устанавливаем кексты для Continuity'
                SET_CONTINUITY
            fi
                if [[ $ready = 1 ]]; then 
                    CLEAR_PLACE
                    printf '\n\n  Необходимо обновить кэш кекстов.\n' 
                    printf '\n  Выполнить? ( Y/n ) '
                    printf "\033[?25h"
                    read  -n 1 -r -s
                    printf "\033[?25l"
                    printf '\r\033[3A'
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf '\r\033[3A'
                    if [[  $REPLY =~ ^[yY]$ ]] || [[  $REPLY = "" ]]; then  
                    printf '\n  Обновляем системный кэш.\n'
                    printf '\n  Выполняется: '
                    while :;do printf '.' ;sleep 3;done &
                    trap "kill $!" EXIT 
                    sudo touch /Library/Extensions >&- 2>&-
                    sudo kextcache -i /  >&- 2>&-
                    kill $!
                    wait $! 2>/dev/null
                    trap " " EXIT
                    CLEAR_PLACE
                    printf '\n\n  Необходимый таймаут !\n\n'
                    TIMEOUT
                    CLEAR_PLACE
                    fi
            printf '\n\n  \e[1;33mИзменения наступят после перезагрузки Mac !\e[0m\n'
            else
                printf '\n    Загрузите кексты вручную в папку kexts в папке программы\n'
                printf '    И повторите установку. \n'
            fi
            printf '\n  Нажмите любую клавишу для возврата к меню \n'
            read  -n 1 -r -s  
            
            CLEAR_PLACE
       fi     
fi

if [[ $inputs = 2 ]]; then
        CHECK_WHITELIST
        GET_PASSWORD
    if [[ ! $PASSWORD = "" ]]; then
        CLEAR_PLACE
            if [[ $continuity = 1 ]]; then
                UNSET_WHITELIST
            else
                SET_WHITELIST
            fi
        if [[ $legal = 0 ]]; then 
            printf '\n\n  Этой модели Mac нет в чёрном списке для Continuity.\n'
        else
                    printf '\n\n  Необходимо обновить кэш системных сценариев.\n' 
                    printf '\n  Выполнить? ( Y/n ) '
                    printf "\033[?25h"
                    read  -n 1 -r -s
                    printf "\033[?25l"
                    printf '\r\033[3A'
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf '\r\033[3A'
                 if [[  $REPLY =~ ^[yY]$ ]] || [[  $REPLY = "" ]]; then  
                    printf '\n  Обновляем кэш системных сценариев\n'
                    printf '\n  Выполняется: '
                    while :;do printf '.';sleep 3;done &
                    trap "kill $!" EXIT 
                    sudo update_dyld_shared_cache -debug -force -root / 2>/dev/null
                    kill $!
                    wait $! 2>/dev/null
                    trap " " EXIT
                    
                    CLEAR_PLACE
                    printf '\n\n  Необходимый таймаут !\n\n'
                    TIMEOUT
                    CLEAR_PLACE
                    printf '\n\n  \e[1;33mИзменения наступят после перезагрузки Mac !\e[0m\n'
                    printf '\n  Нажмите любую клавишу для возврата к меню \n'
                    read  -n 1 -r -s 
                fi
                    
          fi
    fi
fi



if [[ $inputs = 3 ]]; then
    GET_PASSWORD
 if [[ ! $PASSWORD = "" ]]; then
    CHECK_SPINDUMP
    if [[ $spin_check = "остановлены" ]]; then
        SET_SPINDUMP
    else
        UNSET_SPINDUMP
    fi
  fi
fi

if [[ $inputs = 4 ]]; then
    GET_PASSWORD
 if [[ ! $PASSWORD = "" ]]; then
    CHECK_ERROR_REPORT
    if [[ $err_check = "сделано" ]]; then
        SET_ERROR_REPORT
    else
        UNSET_ERROR_REPORT
    fi
  fi
fi

if [[ $inputs = 5 ]]; then
        CHECK_AUTODOCK
        if [[ $dock = 0 ]]; then
            UNSET_AUTODOCK
        else
            SET_AUTODOCK
        fi
fi
        

if [[ $inputs = 6 ]]; then
    CHECK_DASH
    if [[ $dash_check = "сделано" ]]; then
        SET_DASH
    else
        UNSET_DASH
    fi
fi

if [[ $inputs = 7 ]]; then
    CHECK_KEYS
        if [[ $keys_check = "сделан" ]]; then
            UNSET_KEYS
        else
            SET_KEYS
        fi
    printf '\n\n  Для применения изменений надо перелогиниться !\n\n'
    read -p "  Для возврата к меню нажмите любую клавишу      " -n 1 -r
    CLEAR_PLACE
    
fi

if [[ $inputs = 8 ]]; then
        GET_PASSWORD
    if [[ ! $PASSWORD = "" ]]; then
        CHECK_MRT
            if [[ $mrt = 1 ]]; then
                    UNSET_MRT
            else
                    SET_MRT
            fi
    fi
fi

if [[ $inputs = 9 ]]; then
        GET_PASSWORD
    if [[ ! $PASSWORD = "" ]]; then
        GET_GITHUB_VERSIONS
        ext=0
        if [[ $net = 1 ]]; then 
            GET_INSTALLED_VERSIONS
            CLEAR_PLACE
            SHOW_KEXTS_VERSIONS
            if [[ $a_col = 33 ]] || [[ $b_col = 33 ]] || [[ $l_col = 33 ]]; then
                printf '  Обновить или установить кексты c github ? ( y/N ) '
                    else
                printf '  Загрузить и установить кекcты c github ? ( y/N ) '
            fi
                printf "\033[?25h"
                read -s -n 1 -r 
                printf "\033[?25l"
              if [[  $REPLY =~ ^[yY]$ ]]; then
                CLEAR_PLACE
                GET_GITHUB_KEXTS
                if [[ $net = 0 ]]; then
                       #printf '\n\n  Интернет соединение недоступно \n'
                        read -p "  Для возврата к меню нажмите любую клавишу      " -n 1 -r
                        else 
                    if [[  -d ~/net_kexts/Lilu.kext ]] && [[ -d ~/net_kexts/BT4LEContinuityFixup.kext ]] && [[ -d ~/net_kexts/AirportBrcmFixup.kext ]]; then
                        CLEAR_PLACE
                        printf '\n\n  Кексты получены. Устанавливаем .'
                        UPDATE_KEXTS
                        printf '.\n'
                        CLEAR_PLACE
                    printf '\n\n  Необходимо обновить кэш кекстов.\n' 
                    printf '\n  Выполнить? ( Y/n ) '
                    printf "\033[?25h"
                    read  -n 1 -r -s
                    printf "\033[?25l"
                    printf '\r\033[3A'
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf '\r\033[3A'
                    if [[  $REPLY =~ ^[yY]$ ]] || [[  $REPLY = "" ]]; then  
                    printf '\n  Обновляем системный кэш.\n'
                    printf '\n  Выполняется: '
                    while :;do printf '.' ;sleep 3;done &
                    trap "kill $!" EXIT 
                    sudo touch /Library/Extensions >&- 2>&-
                    sudo kextcache -i /  >&- 2>&-
                    kill $!
                    wait $! 2>/dev/null
                    trap " " EXIT
                    CLEAR_PLACE
                    printf '\n\n  Необходимый таймаут !\n\n'
                    TIMEOUT
                    CLEAR_PLACE
                    printf '\n\n  \e[1;33mИзменения наступят после перезагрузки Mac !\e[0m\n\n'    
                    fi
                    else
                        rm -R -f ~/net_kexts
                        CLEAR_PLACE
                        printf '\n\n  Кексты не получены. Что-то пошло не так \n\n'
                        read -p "  Для возврата к меню нажмите любую клавишу      " -n 1 -r  
                 fi
                fi
              fi
            ext=1
        fi
    if [[ $ext = 0 ]]; then
    printf '\n'
    read -p "  Для возврата к меню нажмите любую клавишу      " -n 1 -r
    fi
    CLEAR_PLACE
    fi
fi


if [[ $inputs = [cC] ]]; then

    if [[ ! -d ~/.auth ]]; then mkdir ~/.auth
            echo '<?xml version="1.0" encoding="UTF-8"?>' >> ~/.auth/auth.plist
            echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> ~/.auth/auth.plist
            echo '<plist version="1.0">' >> ~/.auth/auth.plist
            echo '<dict>' >> ~/.auth/auth.plist
            echo '</dict>' >> ~/.auth/auth.plist
            echo '</plist>' >> ~/.auth/auth.plist
     fi
    
    SET_USER_PASSWORD
fi



if [[ $inputs = [aA] ]]; then DO_ALL; fi
if [[ $inputs = [bB] ]]; then UNDO_ALL; fi
if [[ $inputs = [qQ] ]]; then var4=1; fi

done

clear

EXIT_PROGRAM






