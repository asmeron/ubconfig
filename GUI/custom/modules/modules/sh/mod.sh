#/bin/sh

cd ..
cd ..
cd custom
cd modules
modules=($moules[@] $(ls -d */ | cut -d'/' -f1 | grep -v modules) )

for i in $@
 do
	cd $i
	sed -i 3d "base.info"
	echo "Status = Active" >> "base.info"
	modules=("${modules[@]/$i}")
	cd ..
done

for i in ${modules[@]}; 
do
	if [ "$i" != "[@]" ]; then
		cd $i
		sed -i 3d "base.info"
		echo "Status = Disable" >> "base.info"
		cd ..
	fi
done
