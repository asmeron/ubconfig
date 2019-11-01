#/bin/sh

cd config
modules=($moules[@] $(ls -d */ | cut -d'/' -f1 | grep -v modules) )

for i in $@
 do
	cd $i
	sed -i 3d "$i.info"
	echo "Status = Active" >> "$i.info"
	modules=("${modules[@]/$i}")
	cd ..
done

for i in ${modules[@]}; 
do
	if [ "$i" != "[@]" ]; then
		cd $i
		sed -i 3d "$i.info"
		echo "Status = Disable" >> "$i.info"
		cd ..
	fi
done
