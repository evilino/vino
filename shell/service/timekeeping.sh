#!/bin/bash

rootDir=$(cd "$(dirname "$0")/.."; pwd)
. $rootDir/utility.sh

declare -a FLAG_ARR
#identify whether over a day or not
OVERDAY=false

function flagInit (){
    for (( i = 0; i < 24; i++ )); do
        FLAG_ARR[i]=1                   #1:unkept #0:kept
    done
}

function timeKeeping (){
    #init
    MINUTE=`date +%M`
    HOUR=`date +%H`
    TMP=''

    #when occur at XX:01 XX:59 XX:00
    if [[ $MINUTE -eq 1 ]] || [[ $MINUTE -eq 59 ]] || [[ $MINUTE -eq 0 ]]; then
        # last hour , so need add one clock
        if [[ $MINUTE -eq 59 ]]; then
            TMP=$(echo $HOUR+1 | bc)
        else
            TMP=$HOUR
        fi

        #fix a bug when hour is less then 10, it's value is '09' 
        #It will be treat as octal
        TMP=$((10#$TMP))

        #when occur at 23:59 the 24 is wrong ,the right is 0
        if [[ $TMP -eq 24 ]]; then
            TMP=0
            #if 0 a new day , so re-init
            flagInit
            OVERDAY=true
        fi

        #when hour is zero but OVERDAY is false 
        #(when sleep great then 60s , may be not hit 23:59)
        if [[ $TMP -eq 0 ]] && [[ ! $OVERDAY ]]; then
            #if 0 a new day , so re-init
            flagInit
            OVERDAY=true
        fi

        #reset OVERDAY=false
        if [ $TMP -ne 0 ]; then
            OVERDAY=false
        fi

        #when run as deamon , if has be reported then do nothing
        if [[ ${FLAG_ARR[$TMP]} -eq 1 ]]; then
            speak "Now, "$TMP$" o'clock"
            FLAG_ARR[$TMP]=0
        fi

    fi
}

function timeKeeping_deamon (){
    while [ true ]; do
    
        timeKeeping

        sleep 60

    done    
}

#init flag for run as deamon
flagInit


if [[ $# -eq 0 ]]; then
    speak 'timeKeeping'
    timeKeeping
    exit 0
fi

while getopts ":d" optname
do
    case "$optname" in
    "d")
        echo "timeKeeping_deamon"
        timeKeeping_deamon
    ;;
    *)
        echo "others"
    ;;
    esac
done



    



