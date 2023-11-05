#!/bin/bash
echo "---------------------------"
echo "User Name : KimMinHwan"
echo "Student Number : 12201703"
echo "[ Menu ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with age between 20 and 29 occupation as 'programmer'"
echo "9. Exit"
echo "---------------------------"

get_data_of_movie() {
	read -p "Please enter 'movie ID' (1~1682) : " ID
	awk -F '|' -v id="$ID" '$1 == id' u.item
}

get_action_genre() {
	read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n) : " yesno
	if [ "$yesno" = "y" ]
	then 
		awk -F '|' '$7 == 1 { print $1, $2; }' u.item | sort -n | head -n 10	
	fi
}

get_average_rating() {
	read -p "Please enter 'movie ID' (1~1682) : " ID
	total_rating=0
	total_users=0

	movie_rating=$(awk -F '\t' -v id="$ID" '$2 == id { print $3 }' u.data)

	for rating in ${movie_rating[@]}
	do
		total_rating=$(echo "$total_rating + $rating" | bc -l)
		total_users=$((total_users+1))
	done

	avg_rating=$(echo "$total_rating / $total_users" | bc -l)
	avg_rating_rounded=$(printf "%.6f\n" $avg_rating)
	printf "average rating of %s : %.5f\n" $ID $avg_rating_rounded
}

delete_URL() {
	read -p "Do you want to delete the 'IMDb URL' from 'u.item'? : (y/n) : " yesno
	if [ "$yesno" = "y" ]
	then
		awk -F '|' -v OFS='|' '{ $5 = "";  print$0 }' u.item | head -n 10
	fi
}

get_user_data() {
	read -p "Do you want to get the data about users from 'u.user'?(y/n) : " yesno
	if [ "$yesno" = "y" ]
	then
		head -n 10 u.user | awk -F '|' '{ 
			gender = ($3 == "M") ? "male" : "female";
			printf "user %d is %d years old %s %s\n", $1, $2, gender, $4;  }'
	fi 
}

modify_release_data() {
	read -p "Do you want to Modify the format of 'release data' in u.item?(y/n) : " yesno
	if [ "$yesno" = "y" ]
	then
		awk -F '|' 'BEGIN{ months["Jan"]="01"; months["Feb"]="02";months["Mar"]="03";months["Apr"]="04";months["May"]="05";months["Jun"]="06";months["Jul"]="07";months["Aug"]="08";months["Sep"]="09";months["Oct"]="10";months["Nov"]="11";months["Dec"]="12";} { split($3, date, "-"); $3=date[3] months[date[2]] date[1]; OFS="|"; print }' u.item | tail -n 10
	fi
}

get_movie_by_specific_userid() {
	read -p "Please enter the 'user id' (1~943) : " ID
	movie_ids=$(awk -F '\t' -v id="$ID" '$1 == id { print $2 }' u.data | sort -n)
	echo "$movie_ids" | tr '\n' '|'
	echo -e "\n"
	echo "$movie_ids" | while IFS= read -r movie_id; do
		movie_title=$(awk -F '|' -v id="$movie_id" '$1 == id { print $2 }' u.item)
		echo "$movie_id | $movie_title"
	done | head -n 10
}

get_rating_2029_programmer() {
	read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n) : " yesno
	if [ "$yesno" = "y" ]
	then
		awk -F '|' 'BEGIN{ OFS="|" } $4=="programmer" && $2>=20 && $2<=29 { print $1 }' u.user > programmers.data
		awk -F '\t' 'BEGIN{ OFS="\t" } NR==FNR { programmers[$1]=1 } NR>FNR && $1 in programmers { count[$2]++; sum[$2]+=$3 } END{ for (i in count) printf "%s %.6g\n",i,sum[i]/count[i] }' programmers.data u.data | sort -n -k 1	
		
		rm programmers.data
	fi
}

while true
do
	read -p "Enter your choice [ 1 - 9 ] : " choice
	case $choice in
	1) get_data_of_movie;;
	2) get_action_genre;;
	3) get_average_rating;;
	4) delete_URL;;
	5) get_user_data;;
	6) modify_release_data;;
	7) get_movie_by_specific_userid;;
	8) get_rating_2029_programmer;;
	9) echo "Bye!"
	   exit 0 ;;
	esac
done
