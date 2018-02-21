#!/bin/bash
trashSafermName=".Trash_saferm"
trashSafermPath="$HOME/$trashSafermName"
FilePath=$1
totalItemListing=$(ls -l "$FilePath")

# create .trash_saferm if it doesn't exist


#1 if it doesn't CREATE it
if [ ! -d "$trashSafermPath" ];
then
    mkdir "$trashSafermPath"
    echo "$trashSafermName created"
fi


if [[ -f $1 ]]
then
    echo "$1 is a file"
    read -p "do you want to remove $1?" reply
    #if the first letter of the reply is lower or upper case Y
    if [[ $reply =~ ^[y*/Y*]$  ]];
    then
        mv $1 $HOME/.Trash_saferm
        echo "$1 removed"
    #else if the first letter of the reply is lower or upper case N
    elif [[ $reply =~ ^[n*/N*]$ ]];
    then
        echo "can't be removed"
    else
        echo "error"
    fi

else
    #if its a directory
    echo "$1 is a directory"
    read -p "do you want to examine $1? " reply

    #if the first letter of the reply is lower or upper case Y
    if [[ $reply =~ ^[y*/Y*]$ ]]
    then
        #examine each file
        #ls $1
        for i in $( ls $1 ); do
           #Ask the user to delete the file or directory
            read -p "do you want to remove $1? "
            #if the first letter of the reply is lower or upper case Y
            if [[ $REPLY =~ ^[y*/Y*]$  ]];
            then
                mv $1 $HOME/.Trash_saferm
                echo "$1 removed"
            #if the first letter of the reply is lower or upper case N
            elif [[ $REPLY =~ ^[n*/N*]$ ]];
            then
                echo "can't be removed"
            else
                echo "error"
            fi
        done
    fi

fi

#ask to delete file
