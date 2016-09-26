#!/bin/bash
changedFilesPath=~/Documents/changedFiles
projectFilesPath=~/Documents/projectFiles

changedFiles=($( ls -p $changedFilesPath | grep -v  / ))
changedFilesLength=0
for i in "${changedFiles[@]}" ; do
        let changedFilesLength=$changedFilesLength+1
done

projectFiles=($(find $projectFilesPath -name "*.txt" -printf "%f\n"))
projectFilesFullPaths=($(find $projectFilesPath -name "*.txt" -print))
projectFilesLength=0
for i in "${projectFiles[@]}"; do
        let projectFilesLength=$projectFilesLength+1
done


echo Running this script will change and create a backup of $changedFilesLength files out $projectFilesLength total project files. Files to be changed:
for i in "${changedFiles[@]}" ; do
        echo $i
done
echo

read -p "Do you want to continue? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	updateCount=0
	for projectFile in "${projectFiles[@]}" ; do
		for changedFile in "${changedFiles[@]}" ; do
			if [ $changedFile = $projectFile ]
			then
			let updateCount=$updateCount+1
			fi
		done
	done

	if [ $updateCount -gt $changedFilesLength ]
	then
	echo "File names are not distinct and this script is too dumb to handle that! You will have to do this manually bro."
	exit 0
	fi

	echo Updating $changedFilesLength files...
	echo
	now="$(date +%F_%T)"
	count=0
	updateCount=0
	for projectFile in "${projectFiles[@]}" ; do
		for changedFile in "${changedFiles[@]}" ; do
			if [ $changedFile = $projectFile ]
			then			
			sudo cp "${projectFilesFullPaths[count]}" "${projectFilesFullPaths[count]}".backup$now
			echo "${projectFilesFullPaths[count]}".backup$now has been created
			sudo cp $changedFilesPath/$changedFile "${projectFilesFullPaths[count]}"
			echo "${projectFilesFullPaths[count]}" has been changed
			let updateCount=$updateCount+1
			echo
			fi
		done
		let count=$count+1
	done
	echo $updateCount files successfully updated
fi


