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

handleFiles() {
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
}

handleDirectories() {
    echo "$1 is a directory"
    read -p "examine files in directory $1? " reply

    #if the first letter of the reply is lower or upper case Y
    if [[ $reply =~ ^[y*/Y*]$ ]]
    then
        #examine each file

        for item in $(ls -l "$1" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' ); do

            #check if item is a file or directory
            checkIfFilesOrDirectories "$1/$item"

            if [[ $? -eq true ]]
            then

                handleFiles "$1/$item"

 directoryItemsCount=$(ls -l "$1" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l )

            else
                handleDirectories "$1/$item"
                if [[ $directoryItemsCount -gt 0 ]]
                then
                    echo "directory not empyt"

                else
                    echo "directory empyt"

                fi
            fi
        done

    fi
}

checkIfFilesOrDirectories(){
    if [[ -f "${1}" ]]
    then
        true
    else
        false
    fi
}

checkIfFilesOrDirectories $1

if [[ $? -eq true ]]
then
    handleFiles $1
else
    handleDirectories $1
fi
