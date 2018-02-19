#!/bin/bash
# This is a bash script
home="$HOME"
trashSafermName=".Trash_saferm"
trashSafermPath="$home/$trashSafermName"
FilePath=$1
totalItemListing=$(ls -l "$FilePath" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' ) 


# create .trash_saferm if it does'nt exist


#1 if it doesn't CREATE it
if [ ! -d "$trashSafermPath" ];
then
     mkdir "$trashSafermPath"
     echo "$trashSafermName created"
else
     echo "$trashSafermName already exist"
fi



# check if the argument is a file or directory
if [[ -f "$1" ]];
then
        echo "$1 is a file"
elif [[ -d "$1" ]];
then
        echo "$1 is a directory"
else
        echo "$1 is not a file or directory"
fi

# Ask the user to delete the file or directory 

read -p "do you want to remove $1?" -n 2 -r
if [[ $REPLY =~ ^[y/Y]$  ]];
then
    mv $1 $HOME/.Trash_saferm
	echo "$1 removed"
elif [[ $REPLY =~ ^[n/N]$ ]];
then
	echo "can't be removed"
else
	echo "error"
	
fi

