#!/usr/bin/env bash

readonly ACTUAL_SCRIPT_FOLDER=$(readlink -f "$0");
#readonly MES_FOLDER=$(dirname $(dirname "$ACTUAL_SCRIPT_FOLDER"));
readonly MES_FOLDER=$(dirname "$ACTUAL_SCRIPT_FOLDER")"/Mes";
readonly ABI_FOLDER="$MES_FOLDER/ABI.Global";
readonly TYPE_DLL_DEBUG="Debug";
readonly TYPE_DLL_RELEASE="Release";
readonly FILE_EXIST="1";
readonly FILE_DOEST_EXIST="2";

ARR_DLL_TO_CHECK=("Core" "Modules");
ARR_LOCAL_TOSAVE=("$ABI_FOLDER/TrakSYS")
function check_folder_file_exist
{
	LOCAL_FILE=$1;
	if([ ! -f $LOCAL_FILE ])
		then	
			echo $FILE_DOEST_EXIST;
			exit;
	fi;
	echo $FILE_EXIST;
}
function copy_files_to_folder
{
	LOCAL_FILE=$1;
	LOCAL_TO_SAVE=$2;
	cp $LOCAL_FILE $LOCAL_TO_SAVE

	echo -e "$LOCAL_FILE save to $LOCAL_TO_SAVE \n"; 
}

if [ -z $1 ]
  then
    echo "You need informate the local name";
    exit;
fi

TYPE_DLL="$2";
if [ -z $TYPE_DLL ]
  then
    TYPE_DLL=$TYPE_DLL_DEBUG;
   else
   	TYPE_DLL=$TYPE_DLL_RELEASE;
fi

FOLDER_DLL="$ABI_FOLDER/ABI.Global.$1/bin/$TYPE_DLL";
if([ ! -d $FOLDER_DLL ])
	then	
		echo -e "$FOLDER_DLL DOES NOT EXIST \n\n";
		exit;
fi
echo -e "\n We will get the DLL IN $FOLDER_DLL \n\n";

for DLL in "${ARR_DLL_TO_CHECK[@]}"; do
	echo "********** Starting $DLL OPERATION ********************";
	echo -e "\n\n";
	FILE="$FOLDER_DLL/ABI.Global.$DLL.dll";

	echo $FILE;
	if [[ $(check_folder_file_exist $FILE) -eq $FILE_EXIST ]] ; 
        then
        	for LOCAL_TO_SAVE in "${ARR_LOCAL_TOSAVE[@]}"; do
        		if([ ! -d $LOCAL_TO_SAVE ])
				then	
					echo -e "$LOCAL_TO_SAVE Doens't Exist \n";
        		else
        			copy_files_to_folder $FILE $LOCAL_TO_SAVE;
				fi
        	done;
        else
        	echo "$FILE DOESN'T EXIST";
    fi
    echo -e "\n";
    echo "********** Finished $DLL OPERATION ********************";
	echo -e "\n\n";
done;