#!/bin/bash
presentWD=$(pwd)
homeDir="$HOME"
trashSafermName=".Trash_saferm"
trashSafermPath="$homeDir/$trashSafermName"
filePath=$1
totalItemListing=$(ls -l "$filePath")
# create .trash_saferm if it doesn't exist


#1 if it doesn't CREATE it
if [ ! -d "$trashSafermPath" ];
then
    mkdir "$trashSafermPath"
    # echo "$trashSafermName created"
fi

checkIfFilesOrDirectories(){
    if [[ -f "${1}" ]]
    then
        true
    else
        false
    fi
}

handleFiles() {

    read -p "remove $1?" reply
    #if the first letter of the reply is lower or upper case Y
    if [[ $reply =~ ^[y*/Y*]$  ]];
    then
        mv "$1" $trashSafermPath
        echo "$1"
    #else if the first letter of the reply is lower or upper case N
    #elif [[ $reply =~ ^[n*/N*]$ ]];
    #then
        #echo "$1 not removed"
    else
        echo "error"
    fi
}

handleDirectories() {
    currrentDir=$1
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


        else
            echo "directory empyt"
            #delete the directory
          #  handleFiles $currrentDir
            #currrentDir=$(dirName $currrentDir)

        fi
          if [ "currrentDir" != "." ]; then
            handleFiles $currrentDir
          fi
    fi

    #move back one folder
    currrentDir=$(dirName $currrentDir)
}

actionForIfFileOrDirectory (){
  if [[ -f "$1" && $rFlag -eq 0 ]]
  then
      handleFiles $1
  elif [[ -d "$1" && $rFlag -eq 0 ]];
  then
      handleDirectories $1
  fi
}
 actionForIfFileOrDirectory $1
# if [[ $? -eq true ]]
# then
#     handleFiles $1
# else
#     handleDirectories $1
#
# fi





vFlag=0
rFlag=0
dFlag=0

while getopts ":v:r:d:R:" opt; do

  case $opt in

  	v) #verbose
      vFlag=1
      vArg=$OPTARG
      if [[ $vFlag -eq 1 && -f "$vArg" ]];
      then
        # filePath=$vArg
        echo "$vArg"
        mv $vArg $trashSafermPath
      else
        echo "$vArg is a directory"
      fi

      ;;

    r) #recursive
      rFlag=1
      rArg=$OPTARG
      if [[ $rFlag -eq 1 ]] && [[ -f "$rArg" ]];
      then
        handleFiles $rArg
        #mv $rArg $trashSafermPath
        #echo "removed"
        # filePath=$rArg
      else
         handleDirectories $rArg
      fi
      ;;

    d) #deleteAll
      dFlag=1
      dArg=$OPTARG
      directoryItemsCount=$( ls -l "$dArg" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' | wc -l | xargs)
      if [[ $dFlag -eq 1 && -f "$dArg" ]];
      then
      # filePath=$dArg
        mv $dArg $trashSafermPath
      elif [[ $dFlag -eq 1 && -d "$dArg" ]];
      then
          if [[ $directoryItemsCount -gt true ]];
          then
            echo "directory not empty"
          else
          #  echo "removed"
            mv $dArg $trashSafermPath
          fi
        exit
      fi
      ;;

    	#recovery
    R)
      Rflag=1
      RArg=$OPTARG
      itemPath=$presentWD/$RArg
      objectPath=$(dirname $itemPath)
      trash=$trashSafermPath/$RArg

      if [[ $Rflag -eq 1 ]]
      then
        read -p "do you want to recover $RArg ?" reply
        #if the first letter of the reply is lower or upper case Y
        if [[ $reply =~ ^[y*/Y*]$  ]];
        then
          # echo "$objectPath"
          # echo "$trash"
          mv $trash $objectPath
          echo "$RArg recovered"
        else
          echo "$RArg not recovered"
        fi
      fi

  esac
done
shift "$(($OPTIND -1))"








 # checkIfFilesOrDirectories $filePath



 # if [[ $? -eq true ]]
 # then
 #     handleFiles $1
 # else
 #     handleDirectories $1
 #
 # fi
