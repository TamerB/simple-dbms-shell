#!/usr/bin/ksh

createDb() {
	clear
	read name?"Enter Database Name: "
	if [[ ${name:0:1} == !([0-9]) && $(ls) != *"$name"* ]]
	then
		if [[ $name != *":"* && $name != *" "* && $name != *"\\"* ]]
				then
				mkdir $name
		echo "$name created"
				else
					echo ""
					echo "Sorry ... ':' '\'' and spaces are not allowed"
				fi

		
	else
		clear
		echo "Sorry... Existing names or names starting with numbers are invalid..."
	fi
	sleep 3
}

viewDb() {
	while true
	do
	clear
	echo -n Loading. ;sleep 0.5; echo -n .; sleep 0.5; echo -n .; sleep 0.5
	clear
	echo "Available databases: "
	
	for i in $(find */ -type d); do
		echo $i | cut -d'/' -f 1
	done
	echo "Choose from the following:"
	echo "1. Alter database name"
	echo "2. Select database"
	echo "3. drop database"
	echo "4. Go back"
	read choice?"You choosed: "
	
	case $choice in
		1) alterDbName ;;
		2) selectDb ;;
		3) dropDb ;;
		4) clear; break; echo -n Loading. ;sleep 0.5; echo -n .; sleep 0.5; echo -n .; sleep 0.5; break;;
		*) echo "Invalid input" ;;
	esac
done
}

alterDbName() {
	x="d"
	while true
		do
			read db?"Enter database you want to alter (Enter 'exit' to go back) : "
			if [[ $db == "exit" ]]
				then
				break
			fi
			if [[ $(find $db) == null ]]
				then
				clear
				echo "Database not found"
				sleep 3
				break
			fi
			read nn?"Enter database new name (Enter 'exit' to go back): "
			if [[ $nn == "exit" ]]
				then
				break
			fi

			if [[ $(find $nn) == null ]]
				then
				if [[ $nn != *":"* && $nn != *" "* && $nn != *"\\"* ]]
					then
					read c?"Are you shure you want to change $db to $nn ? (y/n): "
					case $c in
						y) sudo mv $db $nn; echo "$db has been altered to $nn"; sleep 3; break;;
						n) break;;
						*) echo "Invalid input";;
					esac
				else
					echo ""
					echo "Sorry ... ':' '\' and spaces are not allowed"
				fi
			else
				echo ""
				echo "Sorry ... $nn already exists"
			fi
			read x?
		done
}


#-----------------------------------------------------------START--------------------------------------------------------------

selectDb() {
	while true
	do
		clear
		read db?"Enter database name (Eneter 'exit' to go back) : "
		if [[ $db == "exit" ]]
			then
			break
		fi
		clear
		echo -n Loading. ;sleep 0.5; echo -n .; sleep 0.5; echo -n .; sleep 0.5
		clear
		echo "$db : "
		if [[ $(ls | grep -x $db) ]]
			then
			cd $db
			for i in $(find * -type f); do
				if [[ $i != *"_metadata"* ]]
					then
					echo $i
				fi
			done
			echo ""
			echo "Choose from the following:"
			echo "1. Create table"
			echo "2. Select table "
			echo "3. drop table"
			echo "4. Go back"
			read choice?"You choosed: "
				
			case $choice in
				1) createT ;;
				2) selectT ;;
				3) dropT ;;
				4) clear; cd ..; break; echo -n Loading. ;sleep 0.5; echo -n .; sleep 0.5; echo -n .; sleep 0.5; break;;
				*) echo "Invalid input" ;;
			esac
			cd ..
		else
			clear
			echo "Database not found"
			sleep 3
			break
		fi	
	done
}

createT(){
	clear
	read name?"Enter Table Name: "
	if [[ ${name:0:1} == !([0-9]) ]]
	then
		if [[ $(find *) != *"$name"* ]]
		then
			if [[ $name != *":"* && $name != *" "* && $name != *"\\"* ]]
					then
				touch $name
				while true
				do
					addC $name
					echo $s >> $name"_metadata"
					read r?"Repeat operation? (y/n) : "
					case $r in
						y);;
						n) break;;
						*) echo "Sorry... Invalid input"; sleep 3; break;;
					esac
				done
				echo "Table $name created"
			else
				echo ""
					echo "Sorry ... ':' '\'' and spaces are not allowed"
			fi
		else
			echo ""
			echo "Sorry... $name already exists"
		fi
	else
		echo ""
		echo "Sorry Names starting with numbers are invalid..."
	fi
	sleep 3
}

addC(){
	echo ""
	s=""
	name=$1
	if [[ $(ls) == *$name"_metadata"* ]]
		then
		cols=$(awk -F: '{print $0}' $name"_metadata")
	fi

		read nam?"Enter column name: "
		if [[ $cols != *"$nam"* ]]
			then
			if [[ $nam != *":"* && $nam != *" "* && $nam != *"\\"* ]]
					then
					s+=$nam
					while true
					do
						read t?"Set type : number , characters or mixed) : "
						case $t in
							"number") s+=":"$t; break;;
							"characters") s+=":"$t; break;;
							"mixed") s+=":"$t; break;;
							*) echo "Sorry... Invalid input";;
						esac
					done
				
					if [[ $cols != *"primaryKey"* ]]
						then
						read y?"Do you want to set $name as primary key? (y/n) :"
						case $y in
							y) s+=":primaryKey";;
							n);;
							*) echo "Invalid input";;
						esac
					fi
				else
					echo ""
					echo "Sorry ... ':' '\'' and spaces are not allowed"
			fi
		else
			echo "Sorry... $name already exists"
			sleep 2
		fi
	export s
}

changeCN(){
	while true
	do
	echo ""
	name=$1
	echo $name
	read nam?"Enter column name (Enter 'exit' to go back) : "
	if [[ $nam == "exit" ]]
		then
		break
	fi

	if [[ $(awk -F: '$1' $name"_metadata" | grep -w $nam) ]]
		then
		read nam2?"Enter new column name: "
		if [[ $nam2 != *":"* && $nam2 != *" "* && $nam2 != *"\\"* ]]
					then
		read rep?"Are you sure you want to replace $nam with $nam2 ? (y/n) : "
		case $rep in
			y) echo $(sed 's/'$nam'/'$nam2'/g' $name'_metadata'); echo $(sed 's/'$nam'/'$nam2'/g' $name'_metadata') > $name"_metadata"; echo $nam" has been replaced with "$nam2; read x? ;;
			*) break;;
		esac
		else
				echo ""
					echo "Sorry ... ':' '\'' and spaces are not allowed"
			fi
	else
		echo "Sorry... $nam not found"
	fi
	read x?
done
}

removeCN(){
	echo ""
	name=$1
	echo $name
	read nam?"Enter column name: "

	if [[ $(awk -F: '$1' $name"_metadata" | grep -w $nam) ]]
		then
		read del?"Are you sure you want do remove $name ? (y/n) : "
		case $del in
			y) echo $(sed '/'$nam'/d' $name'_metadata') > $name"_metadata"; echo $nam" has been removed "; read x?;;
			*) break;;
		esac
		
		else
			echo "Sorry... $nam not found"
			read x?
	fi
}

insertR(){
	clear
	s=""
	x="a"
	doit=true
		table=$1
		clear
		echo -n Loading. ;sleep 0.5; echo -n .; sleep 0.5; echo -n .; sleep 0.5
		clear
		echo "$table : "
		if [[ $(ls) != *$table* ]]
				then
				clear
				echo "Table not found"
				sleep 3
				break
			else
				cols=$(awk -F: '{print $0}' $table"_metadata")
			for i in $cols
			do
				col=$(echo $i | cut -d':' -f 1)
				typ=$(echo $i | cut -d':' -f 2)
				p=$(echo $i | cut -d':' -f 3)
				echo $col
				read item?"Enter $col : "
				if [[ $item != *":"* && $item != *" "* && $item != *"\\"* ]]
					then
					case $typ in
						"number") if [[ $item != +([0-9]) ]]; then; echo "Sorry... $col must be a number"; read x? ; doit=false;break; fi ;;
						"characters") if [[ $item != +([a-zA-Z]) ]]; then; echo "Sorry... $col must be a characters"; read x? ;doit=false break ; fi ;;
						*) ;;
					esac
					if [[ $p == "primaryKey" && $(awk -F: '{print $1}' $table | grep -w $item) ]]
						then
							echo "Sorry... $item must be unique"
							read x?
							break
						else
							s+=$item":"
					fi	
				else
					echo ""
					echo "Sorry ... ':' '\'' and spaces are not allowed"
					break
			fi			
			done
			if [[ $doit == true ]]
				then
				echo $s >> $table
			fi
		fi
		read x?
}

#updateR(){

#}

selectR(){

	echo ""
	name=$1
	x="a"
	while true
	do
		echo $name
		read nam?"Based on which column ? : "
		if [[ $nam == "exit" ]]
			then
			break
		fi
	
		if [[ $(awk -F: '$1' $name"_metadata" | grep -w $nam) ]]
			then
			i= $(sed -n '/$nam/=' $name'_metadata')
			echo $i

			read val?"Enter matched value: "

			if [[ $(awk -F: '$i' $name | grep -w $val) ]]
				then
				echo -n Loading. ;sleep 0.5; echo -n .; sleep 0.5; echo -n .; sleep 0.5
				echo ""
				echo $(awk -F: '$i' $name | grep -w $val)
				read x?
				else
					echo "Sorry... $val not found"
					read x?
			fi
		else
			echo "Sorry... $nam not found"
			read x?
		fi
	done
}

removeR(){
	echo ""
	x="a"
	while true
	do
	name=$1
	echo $name
	read nam?"Enter row name: "
	case $nam in
		"exit") break;;
	esac

	if [[ $(awk -F: '$1' $name | grep -w $nam) ]]
		then
		read del?"Are you sure you want do remove $name ? (y/n) : "
		case $del in
			y) echo $(sed '/'$nam'/d' $name) > $name; echo $nam" has been removed "; read x?;;
			*) break;;
		esac
		
		else
			echo "Sorry... $nam not found"
			read x?
	fi
	done
}

selectT(){
	x="a"
	while true
	do
	clear
		read table?"Enter Table name: "
		clear
		echo -n Loading. ;sleep 0.5; echo -n .; sleep 0.5; echo -n .; sleep 0.5
		clear
		echo "$table : "
		if [[ $(ls) != *$table* ]]
			then
			clear
			echo "Table not found"
			sleep 3
			break
		else
			cols=$(awk -F: '{print $0}' $table"_metadata")
		for i in $cols
		do
			col=$(echo $i | cut -d':' -f 1)
			typ=$(echo $i | cut -d':' -f 2)
			p=$(echo $i | cut -d':' -f 3)
			echo $col" : "$typ" ("$p")"
		done

		echo "Choose from the following:"
		echo ""
		echo "1. Change column name"
		echo "2. Add column"
		echo "3. Delete column"
		echo "4. Insert rows"
		echo "5. Delete rows"
		#echo "6. Update rows"
		echo "7. Select rows"
		echo "8. Go back"
		read choice?"You choosed: "
		
		case $choice in
			1) changeCN $table;;
			2) addC $table ; echo $s >> $table"_metadata" ; echo $s" added"; read x?;;
			3) removeCN $table ;;
			4) insertR $table;;
			5) removeR $table ;;
			#6) updateR $table;;
			7) selectR $table;;
			8) clear; break ;;
			*) echo "Invalid input" ;;
		esac

		fi
	done
}

dropT(){
	while true
	do
	read db?"Enter the name of the table you want to drop: "
	if [[ $(ls) != *$db* ]]
		then
		clear
		echo "table not found"
		sleep 3
		break
	fi
	read c?"Are you shure you want to drop $db ? (y/n): "
	case $c in
		y) sudo rm $db; echo "$db has been droped"; sleep 3; break;;
		n) break;;
		*) echo "Invalid input";;
	esac
done
}

# ------------------------------------------------------END-----------------------------------------------------
dropDb() {
	while true
	do
	read db?"Enter database you want to drop (Enter 'exit' to go back): "
	if [[ $db == "exit" ]]
		then
		break
	fi
	if [[ $(ls) != *$db* ]]
		then
		clear
		echo "Database not found"
		sleep 3
		break
	fi
	read c?"Are you shure you want to drop $db ? (y/n): "
	case $c in
		y) sudo rm -r $db; echo "$db has been droped"; sleep 3; break;;
		n) break;;
		*) echo "Invalid input";;
esac
done 
}

#start=true
cd ~/Documents/shell/dbms/
clear
while true
	clear
	do

	#if [ $start == true ]
	#	then
	#	start=false
	#	else
	#		sleep 3
	#fi

	echo "Choose from the following:"
	echo "1. Create database"
	echo "2. View databases"
	echo "3. Alter database name"
	echo "4. Select database"
	echo "5. drop database"
	echo "6. Exit"
	read choice?"You choosed: "
	
	case $choice in
		1) createDb;;
		2) viewDb ;;
		3) alterDbName ;;
		4) selectDb ;;
		5) dropDb ;;
		6) clear; echo "Thank you"; sleep 3; clear; exit ;;
		*) echo "Invalid input" ;;
	esac
done
