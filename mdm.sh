#! /bin/bash

# First version of my download manager
# Get  start  and  end time and  download link via -s -e -l switches

# 


evaluation_time(){
     
     local hour="$1"
     local minute="$2"
     
     # remove 0 form  the beginnig of hour and minute
     
     hour=${hour#0} 
     minute=${minute#0}    
    
     # check hour and minute does not empty via -z 
    
     if [ -z "$hour" ];then
        hour="0"
     fi

     if [ -z "$minute" ];then
        minute="0"
     fi
     echo $(( hour *60 + minute ))
}
current_time(){

    ctime=$(date +%H:%M)
    # replace : with space in Ctime string
    ctime=${ctime/:/ }
    # you can use $(evaluation_time $Ctime) instead of ``
    eval_ctime=`evaluation_time $ctime`    

 }

 start_time(){
     
     local stime="$1"
     
     stime=${stime/:/ }
     eval_stime=`evaluation_time $stime`
     current_time
     
     while [ "$eval_stime" != "$eval_ctime" ];do
        echo $((eval_stime - eval_ctime )) "minutes until to start download ! "
        sleep 30
        current_time
     
     done
 }


download_link(){
    cd "$path"
    
    aria2c -c -x 16 -s 16 -k 1M "$link"
    echo "1" > /tmp/"$pid".txt
}
end_time(){
    local etime="$1"
    etime=${time/:/ }
    eval_etime=`evaluation_time $etime`
    current_time
    while [ "$eval_etime" != "$eval_ctime" ];do
        if [ -f /tmp/"$pid".txt ];then
            exit
        fi
        sleep 30
        current_time
    done    
    killall aria2c
}
clear_tmp_file(){

    if [ -f /tmp/"$pid".txt ];then
    rm  /tmp/"$pid".txt 
    fi
}

# script's body

clear
trap clear_tmp_file exit
pid="$$"
# create switch for script
while getopts "s:e:l:p:v" options
do 
    case "$options" in
        s)
            start_time_input="$OPTARG";;
        e)
            end_time_input="$OPTARG";;
        l)
            link="$OPTARG";;
        p)
            path="$OPTARG";;   
        v)
            echo " Hi ,this is first version of my download manager "
            exit;;
    esac        
done

if [ ! -z "$start_time_input" ];then
    start_time $start_time_input

fi

if [ ! -z "$end_time_input" ];then

    download_link & # with & command run in backgrund
    end_time $end_time_input

else
    download_link 
fi


