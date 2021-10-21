#!/bin/zsh
# Devoper : Savvas Paragkamian
# Date    : 21/10/2021
# RUN     : ./export_png_from_avi.sh

while IFS= read -r video
do
#video="TLC00045"
# check if the folder exists from previous executions. If it doesn't it creates
# a folder in which all pictures are saved
    if [ ! -d "$video" ] 
    then 
        echo "Directory $video doesn't exists."
        echo "creating directory $video"
        photos_directory="${video}"
        mkdir ${photos_directory}
       #the < /dev/null is for the interaction with the stdin. Without it there is an error. 
        ffmpeg -i "${video}.AVI" "${photos_directory}/${video}%03d.png" < /dev/null

    else
        echo "moving on."
    fi
    # here all the names of avi files are (without the extention) 
    # are passed to while loop
done <<< $(ls -1 | grep -i "avi" | awk -F "." '$1 ~ /TLC/{ ORS="\n" ; print $1}')

echo "Finish"
