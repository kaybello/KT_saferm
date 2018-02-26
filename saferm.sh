#!/bin/bash
homeDir=$( pwd )
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

    read -p "do you want to remove $1?" reply
    #if the first letter of the reply is lower or upper case Y
    if [[ $reply =~ ^[y*/Y*]$  ]];
    then
        mv $1 $trashSafermPath
        echo "$1 removed"
    #else if the first letter of the reply is lower or upper case N
    elif [[ $reply =~ ^[n*/N*]$ ]];
    then
        echo "$1 can't be removed"
    else
        echo "error"
    fi
}




handleDirectories() {
    currrentDir=$1
    echo "$1 is a directory"
    read -p "examine files in directory $1? " reply

    #if the first letter of the reply is lower or upper case Y
    if [[ $reply =~ ^[y*/Y*]$ ]]
    then
        #examine each file
        directoryItems=$(ls -l "$1" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' )
        directoryItemsCount=$( ls -l "$1" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)
        # currrentDir=$1
        if [[ $directoryItemsCount -gt true ]]
        then
            echo "directory not empty"

            for item in $directoryItems; do

                #check if item is a file or directory
                checkIfFilesOrDirectories "$currrentDir/$item"

                if [[ $? -eq true ]]
                then
                        handleFiles "$currrentDir/$item"
                else

                  handleDirectories "$currrentDir/$item"

                #  currrentDir=$(dirName $currrentDir)

                fi
            done
            #currrentDir=$(dirName $currrentDir)
            #previousDir

        else
            echo "directory empyt"
            #delete the directory
            handleFiles $currrentDir
            #currrentDir=$(dirName $currrentDir)

        fi
          if [ "currrentDir" != "." ]; then
            handleFiles $currrentDir
          fi
    fi

    #move back one folder
    currrentDir=$(dirName $currrentDir)
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
