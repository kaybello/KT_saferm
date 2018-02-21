	#!/bin/bash
# This is a bash script
trashSafermName=".Trash_saferm"
trashSafermPath="$HOME/$trashSafermName"
FilePath=$1
totalItemListing=$(ls -l "$FilePath" | sort -k1,1 | awk -F " " '{print $NF}' | sed -e '$ d' )


# create .trash_saferm if it doesn't exist

#1 if it doesn't CREATE it
if [ ! -d "$trashSafermPath" ];
then
     mkdir "$trashSafermPath"
     echo "$trashSafermName created"
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


#for file
read -p "do you want to remove $i?"
if [[ $REPLY =~ ^[y*/Y*]$  ]];
then
    mv $1 $HOME/.Trash_saferm
    echo "$1 removed"
elif [[ $REPLY =~ ^[n*/N*]$ ]];
then
    echo "can't be removed"
else
    echo "error"

fi






#for directory

# to examine what is in the directory
if [[ -d "$1" ]]
then
    #ask to examine the directory
    read -p "do you want $1 to be examined"
    if [[ $REPLY =~ ^[y*/Y*]$ ]]
    then

            # examine each file
            ls $1
            for i in $( ls $1 ); do
            # Ask the user to delete the file or directory
            read -p "do you want to remove $i?"
            if [[ $REPLY =~ ^[y*/Y*]$  ]];
            then
            mv $1 $HOME/.Trash_saferm
            echo "$1 removed"
            elif [[ $REPLY =~ ^[n*/N*]$ ]];
            then
            echo "can't be removed"
            else
            echo "error"
            fi
            done
    else
            echo "why don't you want me to examine $1"
    fi
    #loop through each directory

fi


