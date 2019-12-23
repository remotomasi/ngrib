#!/bin/bash

cat final.txt | cut -d',' -f1,41,43,44,45,48,39,67,68,69 | sed '/03:00/d;/09:00/d;/15:00/d;/21:00/d' > sw.csv
sed -i -e '/03:00/d;/09:00/d;/15:00/d;/21:00/d' sw.csv
#sed '/00:00/d;/03:00/d;/15:00/d;/21:00/d' final.html > finalImages2.html
#sed '1d;2d;3d;27d;28d' finalImages2.html > finalImages3.html
#sed 's/<\/td><td>/|/g' finalImages3.html > finalImages4.html

# restoration of some title for Wind and WindDirection
#sed -i -e 's/ PRMSL ,,/ PRMSL , WIND , WINDIR/g' sw.csv
#sed -i -e 's/ mean_sea ,,/ mean_sea , 10m , 10m/g' sw.csv

# some operations on the values
awk 'BEGIN{FS=OFS=","}
function windDirection(x) {
	if ((x > 335) || (x <= 25)) {
		print $1,int($3),int($4),int((sqrt($5*$5+$6*$6))),"N",$7,$8,$9,$10,$2*100
    }
	else if	((x > 25) && (x <= 65)) {
		print $1,int($3),int($4),int((sqrt($5*$5+$6*$6))),"NE",$7,$8,$9,$10,$2*10
    }
	else if ((x > 65) && (x <= 115)) {
		print $1,int($3),int($4),int((sqrt($5*$5+$6*$6))),"E",$7,$8,$9,$10,$2*100
    }
	else if ((x > 115) && (x <= 155)) {
		print $1,int($3),int($4),int((sqrt($5*$5+$6*$6))),"SE",$7,$8,$9,$10,$2*100
    }
	else if ((x > 155) && (x <= 205)) {
		print $1,int($3),int($4),int((sqrt($5*$5+$6*$6))),"S",$7,$8,$9,$10,$2*100
    }
	else if ((x > 205) && (x <= 245)) {
		print $1,int($3),int($4),int((sqrt($5*$5+$6*$6))),"SE",$7,$8,$9,$10,$2*100
    }
	else if ((x > 245) && (x <= 295)) {
		print $1,int($3),int($4),int((sqrt($5*$5+$6*$6))),"W",$7,$8,$9,$10,$2*100
    }
	else if ((x > 295) && (x <= 335)) {
		print $1,int($3),int($4),int((sqrt($5*$5+$6*$6))),"NW",$7,$8,$9,$10,$2*100
    }
}
{if (NR>=3) print windDirection((atan2($5,$6)*57.3+180)) }'  sw.csv > swImages1.csv		# added function that transform direction from degree to a capital letter
awk 'BEGIN{FS=OFS=","}{if (NR<3) print $1,$3,$4,$5,$6,$7,$8,$9,$10,$2 }' sw.csv > swImages.csv

cat swImages1.csv >> swImages.csv

echo -e "<html><head><link rel="stylesheet" href="graphic.css"></head><body><table style='font-family:Arial; font-size:75%; white-space:nowrap; overflow: hidden; border-collapse: collapse; text-align:center' border='1' align='center'>" > sw.html
    while read INPUT ; do
            echo "<tr><td>${INPUT//,/</td><td>}</td></tr>" >> sw.html;
    done < swImages.csv;
echo -e "</font></table></body></html>" >> sw.html

# substitution of Labels
sed -i -e 's/UGRD/Vento(Km\/h)/g' sw.html
sed -i -e 's/VGRD/Vento Dir./g' sw.html
sed -i -e 's/TMP/Temp.(deg)/g' sw.html
sed -i -e 's/RH/Umidita(%)/g' sw.html
sed -i -e 's/PRATE/Pioggia(mm\/h)/g' sw.html
sed -i -e 's/TCDC/Nuvolosita(%)/g' sw.html
sed -i -e 's/SNOD/Neve(cm)/g' sw.html
sed -i -e 's/surface/Superficie/g' sw.html
sed -i -e 's/low_cloud/Bassa/g' sw.html
sed -i -e 's/middle_cloud/Media/g' sw.html
sed -i -e 's/high_cloud/Alta/g' sw.html

# restoration of some title: 100 -> TCDC // 100 -> high_cloud
sed -i -e 's/TCDC <\/td><td>100</TCDC <\/td><td> TCDC </g' sw.html
sed -i -e 's/middle_cloud <\/td><td>100</middle_cloud <\/td><td> high_cloud </g' sw.html

# enumeration of the id tags
awk '{gsub("<td>","\n<td>"); print}' sw.html > swMiddle.html
awk '{gsub("<td>","<td id=" ++n ">"); print}' swMiddle.html > sw.html

# Wind direction
sed -i -e 's/>N</><img src="icons\/n.png" class="center" height="20" width="20"><\/img></g' sw.html
sed -i -e 's/>NE</><img src="icons\/ne.png" class="center" height="20" width="20"><\/img></g' sw.html
sed -i -e 's/>E</><img src="icons\/e.png" class="center" height="20" width="20"><\/img></g' sw.html
sed -i -e 's/>SE</><img src="icons\/se.png" class="center" height="20" width="20"><\/img></g' sw.html
sed -i -e 's/>S</><img src="icons\/s.png" class="center" height="20" width="20"><\/img></g' sw.html
sed -i -e 's/>SW</><img src="icons\/sw.png" class="center" height="20" width="20"><\/img></g' sw.html
sed -i -e 's/>W</><img src="icons\/w.png" class="center" height="20" width="20"><\/img></g' sw.html
sed -i -e 's/>NW</><img src="icons\/nw.png" class="center" height="20" width="20"><\/img></g' sw.html

# Titles
h=()
for l in {4..12..1}
    do h+=($l)
done

for i in "${h[@]}"
do
    sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: darkblue; color: white\"/g" sw.html
done

# Temperatures
h=()
for l in {26..299..13}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat sw.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val <= -10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: black; color: white\"/g" sw.html
    elif (( $(echo "$val > -10" |bc -l) && $(echo "$val <= -5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: navy; color: white\"/g" sw.html
    elif (( $(echo "$val > -5" |bc -l) && $(echo "$val <= 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: blue; color: white\"/g" sw.html
    elif (( $(echo "$val > 0" |bc -l) && $(echo "$val <= 5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: teal; color: white\"/g" sw.html
    elif (( $(echo "$val > 5" |bc -l) && $(echo "$val <= 10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: aqua; color: black\"/g" sw.html
    elif (( $(echo "$val > 10" |bc -l) && $(echo "$val <= 15" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: lime; color: black\"/g" sw.html
    elif (( $(echo "$val > 15" |bc -l) && $(echo "$val <= 20" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: yellow; color: black\"/g" sw.html
    elif (( $(echo "$val > 20" |bc -l) && $(echo "$val <= 25" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: orange; color: black\"/g" sw.html
    elif (( $(echo "$val > 25" |bc -l) && $(echo "$val <= 30" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: red; color: black\"/g" sw.html
    elif (( $(echo "$val > 30" |bc -l) && $(echo "$val <= 35" |bc -l) ))
        then sed -i -e "s/d=$(echo $i)\>/id=$(echo $i) style=\"background-color: maroon; color: black\"/g" sw.html
    elif (( $(echo "$val > 35" |bc -l) && $(echo "$val <= 40" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: fuchsia; color: black\"/g" sw.html
    elif (( $(echo "$val > 40" |bc -l) && $(echo "$val <= 45" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: purple; color: black\"/g" sw.html
    elif (( $(echo "$val > 45" |bc -l) && $(echo "$val <= 50" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: fuchsia; color: black\"/g" sw.html
    elif (( $(echo "$val > 50" |bc -l) && $(echo "$val <= 55" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: purple; color: black\"/g" sw.html
    fi
done

# Humidity
h=()
for l in {27..300..13}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat sw.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val >=0" |bc -l) && $(echo "$val <= 20" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: LightCyan; color: black\"/g" sw.html
    elif (( $(echo "$val > 20" |bc -l) && $(echo "$val <= 40" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Lavender; color: black\"/g" sw.html
    elif (( $(echo "$val > 40" |bc -l) && $(echo "$val <= 60" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: LightBlue; color: black\"/g" sw.html
    elif (( $(echo "$val > 60" |bc -l) && $(echo "$val <= 80" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: DeepSkyBlue; color: black\"/g" sw.html
    elif (( $(echo "$val > 80" |bc -l) && $(echo "$val <= 100" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Blue; color: white\"/g" sw.html
    fi
done

# Wind power
h=()
for l in {28..301..13}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat sw.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val <= 1" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #ffffff; color: black\"/g" sw.html
    elif (( $(echo "$val > 1" |bc -l) && $(echo "$val <= 5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #e6ffe6; color: black\"/g" sw.html
    elif (( $(echo "$val > 5" |bc -l) && $(echo "$val <= 11" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #ccffcc; color: black\"/g" sw.html
    elif (( $(echo "$val > 11" |bc -l) && $(echo "$val <= 19" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #b3ffb3; color: black\"/g" sw.html
    elif (( $(echo "$val > 19" |bc -l) && $(echo "$val <= 28" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #99ff99; color: black\"/g" sw.html
    elif (( $(echo "$val > 28" |bc -l) && $(echo "$val <= 38" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #80ff80; color: black\"/g" sw.html
    elif (( $(echo "$val > 38" |bc -l) && $(echo "$val <= 49" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #66ff66; color: black\"/g" sw.html
    elif (( $(echo "$val > 49" |bc -l) && $(echo "$val <= 61" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #4dff4d; color: black\"/g" sw.html
    elif (( $(echo "$val > 61" |bc -l) && $(echo "$val <= 74" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #33ff33; color: black\"/g" sw.html
    elif (( $(echo "$val > 74" |bc -l) && $(echo "$val <= 88" |bc -l) ))
        then sed -i -e "s45d=$(echo $i)\>/id=$(echo $i) style=\"background-color: #1aff1a; color: black\"/g" sw.html
    elif (( $(echo "$val > 88" |bc -l) && $(echo "$val <= 102" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #00ff00; color: black\"/g" sw.html
    elif (( $(echo "$val > 102" |bc -l) && $(echo "$val <= 117" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #00e600; color: black\"/g" sw.html
    elif (( $(echo "$val > 117" |bc -l) && $(echo "$val <= 176" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #00cc00; color: black\"/g" sw.html
    elif (( $(echo "$val > 176" |bc -l) && $(echo "$val <= 204" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #00b300; color: black\"/g" sw.html
    elif (( $(echo "$val > 204" |bc -l) && $(echo "$val <= 241" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #009900; color: black\"/g" sw.html
    elif (( $(echo "$val > 241" |bc -l) && $(echo "$val <= 287" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #008000; color: black\"/g" sw.html
    elif (( $(echo "$val > 287" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #006600; color: black\"/g" sw.html
    fi
done


# Precipitations rate
h=()
for l in {30..303..13}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat sw.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val == 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: White; color: black\"/g" sw.html
    elif (( $(echo "$val > 0" |bc -l) && $(echo "$val < 1" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #CCFAF4; color: black\"/g" sw.html
    elif (( $(echo "$val >= 1" |bc -l) && $(echo "$val < 2.5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #A8DBEA; color: black\"/g" sw.html
    elif (( $(echo "$val >= 2.5" |bc -l) && $(echo "$val < 10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Blue; color: white\"/g" sw.html
    elif (( $(echo "$val >= 10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Dark-Blue; color: white\"/g" sw.html
    fi
done

# Cloud cover low
h=()
for l in {31..304..13}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat sw.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val >= 0" |bc -l) && $(echo "$val <= 5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #FFFFFF; color: black\"/g" sw.html
    elif (( $(echo "$val > 5" |bc -l) && $(echo "$val <= 10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: LightGray; color: black\"/g" sw.html
    elif (( $(echo "$val > 10" |bc -l) && $(echo "$val <= 30" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Silver; color: black\"/g" sw.html
    elif (( $(echo "$val > 30" |bc -l) && $(echo "$val <= 60" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Gray; color: white\"/g" sw.html
    elif (( $(echo "$val > 60" |bc -l) && $(echo "$val <= 85" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: DarkGray; color: white\"/g" sw.html
    elif (( $(echo "$val > 85" |bc -l) && $(echo "$val <= 100" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Gray; color: white\"/g" sw.html
    fi
done

# Cloud cover middle
h=()
for l in {32..305..13}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat sw.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val >= 0" |bc -l) && $(echo "$val <= 5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #FFFFFF; color: black\"/g" sw.html
    elif (( $(echo "$val > 5" |bc -l) && $(echo "$val <= 10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: LightGray; color: black\"/g" sw.html
    elif (( $(echo "$val > 10" |bc -l) && $(echo "$val <= 30" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Silver; color: black\"/g" sw.html
    elif (( $(echo "$val > 30" |bc -l) && $(echo "$val <= 60" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Gray; color: white\"/g" sw.html
    elif (( $(echo "$val > 60" |bc -l) && $(echo "$val <= 85" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: DarkGray; color: white\"/g" sw.html
    elif (( $(echo "$val > 85" |bc -l) && $(echo "$val <= 100" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Gray; color: white\"/g" sw.html
    fi
done

# Cloud cover high
h=()
for l in {33..306..13}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat sw.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val >= 0" |bc -l) && $(echo "$val <= 5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #FFFFFF; color: black\"/g" sw.html
    elif (( $(echo "$val > 5" |bc -l) && $(echo "$val <= 10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: LightGray; color: black\"/g" sw.html
    elif (( $(echo "$val > 10" |bc -l) && $(echo "$val <= 30" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Silver; color: black\"/g" sw.html
    elif (( $(echo "$val > 30" |bc -l) && $(echo "$val <= 60" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Gray; color: white\"/g" sw.html
    elif (( $(echo "$val > 60" |bc -l) && $(echo "$val <= 85" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: DarkGray; color: white\"/g" sw.html
    elif (( $(echo "$val > 85" |bc -l) && $(echo "$val <= 100" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Gray; color: white\"/g" sw.html
    fi
done

# Snow
h=()
for l in {34..307..13}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat sw.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val == 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: White; color: black\"/g" sw.html
    elif (( $(echo "$val > 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Yellow; color: black\"/g" sw.html
    fi
done

# Transform the html into an image
now=$(date +%d%m%Y_%H%M)
xvfb-run --server-args="-screen 0, 1024x768x24" cutycapt --url=file://$PWD/sw.html --out=/$PWD/imageFiles/finalSW_$now.png

# remove useless files
rm swImages1.csv swImages.csv