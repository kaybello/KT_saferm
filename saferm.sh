#!/bin/bash
homeDir="$HOME"
trashSafermName=".Trash_saferm"
trashSafermPath="$homeDir/$trashSafermName"
FilePath=$1
totalItemListing=$(ls -l "$FilePath")
# create .trash_saferm if it doesn't exist


#1 if it doesn't CREATE it
if [ ! -d "$trashSafermPath" ];
then
    mkdir "$trashSafermPath"
    # echo "$trashSafermName created"
fi


handleFiles() {

    read -p "do you want to remove $1?" reply
    #if the first letter of the reply is lower or upper case Y
    if [[ $reply =~ ^[y*/Y*]$  ]];
    then
        mv "$1" $trashSafermPath
        echo "$1 removed"
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

checkIfFilesOrDirectories(){
    if [[ -f "${1}" ]]
    then
        true
    else
        false
    fi
}


# if [[ $? -eq true ]]
# then
#     handleFiles $FilePath
# else
#     handleDirectories $FilePath
#
fi


vFlag=0
rFlag=0
dFlag=0

while getopts ":v:r:d:" opt; do

  case $opt in

  	v) #verbose
      vFlag=1
      vArg=$OPTARG
      if [[ $vFlag -eq 1 ]]; then
        # FilePath=$vArg
        echo "$vArg has been removed"
      fi

      ;;

    r) #recursive
      rFlag=1
      rArg=$OPTARG
      ;;

    d) #deleteAll
      dFlag=1
      dArg=$OPTARG
      ;;
  		#statements

  esac
	#statements
done
shift "$(($OPTIND -1))"


if [[ $rFlag -eq 1 ]]; then
  # FilePath=$rArg
  handleDirectories $rArg
fi

if [[ $dFlag -eq 1 ]]; then
# FilePath=$dArg
  mv $dArg $trashSafermPath

  exit
fi

 checkIfFilesOrDirectories $FilePath
