#!/bin/bash

cat final.txt | cut -d',' -f1,41,42,43,46,47,48,51,53,55,39,56,57,58,63,64,65,67,68,69,79,80,82 | sed '/03:00/d;/09:00/d;/15:00/d;/21:00/d' > finalImage.csv
sed -i -e '/03:00/d;/09:00/d;/15:00/d;/21:00/d' finalImage.csv
#sed '/00:00/d;/03:00/d;/15:00/d;/21:00/d' final.html > finalImages2.html
#sed '1d;2d;3d;27d;28d' finalImages2.html > finalImages3.html
#sed 's/<\/td><td>/|/g' finalImages3.html > finalImages4.html

# restoration of some title for Wind and WindDirection
sed -i -e 's/ PRMSL ,,/ PRMSL , WIND , WINDIR/g' finalImage.csv
sed -i -e 's/ mean_sea ,,/ mean_sea , 10m , 10m/g' finalImage.csv

awk 'BEGIN{FS=OFS=","}{ print $1,$3,$4,$5,$22,$23,$18,$19,$20,$16,$17,$21,$14,$8,$7,$9,$10,$13,$6,$12,$11,$2,$15 }' finalImage.csv > finalImages.csv

echo -e "<html><head><link rel="stylesheet" href="graphic.css"></head><body><table style='font-family:"Arial", Courier, monospace; font-size:70%; white-space:nowrap; overflow: hidden; border-collapse: collapse; text-align:center' border='1' align='center'>" > finalImage.html
    while read INPUT ; do
            echo "<tr><td>${INPUT//,/</td><td>}</td></tr>" >> finalImage.html;
    done < finalImages.csv;
echo -e "</font></table></body></html>" >> finalImage.html

# restoration of some title: 100 -> TCDC // 100 -> high_cloud
sed -i -e 's/TCDC <\/td><td>100</TCDC <\/td><td> TCDC </g' finalImage.html
sed -i -e 's/middle_cloud <\/td><td>100</middle_cloud <\/td><td> high_cloud </g' finalImage.html

awk '{gsub("<td>","\n<td>"); print}' finalImage.html > finalMiddle.html
awk '{gsub("<td>","<td id=" ++n ">"); print}' finalMiddle.html > finalImage.html

# Wind direction
sed -i -e 's/>N</><img src="icons\/n.png" class="center" height="20" width="20"><\/img></g' finalImage.html
sed -i -e 's/>NE</><img src="icons\/ne.png" class="center" height="20" width="20"><\/img></g' finalImage.html
sed -i -e 's/>E</><img src="icons\/e.png" class="center" height="20" width="20"><\/img></g' finalImage.html
sed -i -e 's/>SE</><img src="icons\/se.png" class="center" height="20" width="20"><\/img></g' finalImage.html
sed -i -e 's/>S</><img src="icons\/s.png" class="center" height="20" width="20"><\/img></g' finalImage.html
sed -i -e 's/>SW</><img src="icons\/sw.png" class="center" height="20" width="20"><\/img></g' finalImage.html
sed -i -e 's/>W</><img src="icons\/w.png" class="center" height="20" width="20"><\/img></g' finalImage.html
sed -i -e 's/>NW</><img src="icons\/nw.png" class="center" height="20" width="20"><\/img></g' finalImage.html

# Titles
h=()
for l in {4..25..1}
    do h+=($l)
done

for i in "${h[@]}"
do
    sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: darkblue; color: white\"/g" finalImage.html
done


# Temperatures
h=()
for l in {52..556..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val <= -10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: black; color: white\"/g" finalImage.html
    elif (( $(echo "$val > -10" |bc -l) && $(echo "$val <= -5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: navy; color: white\"/g" finalImage.html
    elif (( $(echo "$val > -5" |bc -l) && $(echo "$val <= 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: blue; color: white\"/g" finalImage.html
    elif (( $(echo "$val > 0" |bc -l) && $(echo "$val <= 5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: teal; color: white\"/g" finalImage.html
    elif (( $(echo "$val > 5" |bc -l) && $(echo "$val <= 10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: aqua; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 10" |bc -l) && $(echo "$val <= 15" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: lime; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 15" |bc -l) && $(echo "$val <= 20" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: yellow; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 20" |bc -l) && $(echo "$val <= 25" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: orange; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 25" |bc -l) && $(echo "$val <= 30" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: red; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 30" |bc -l) && $(echo "$val <= 35" |bc -l) ))
        then sed -i -e "s/d=$(echo $i)\>/id=$(echo $i) style=\"background-color: maroon; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 35" |bc -l) && $(echo "$val <= 40" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: fuchsia; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 40" |bc -l) && $(echo "$val <= 45" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: purple; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 45" |bc -l) && $(echo "$val <= 50" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: fuchsia; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 50" |bc -l) && $(echo "$val <= 55" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: purple; color: black\"/g" finalImage.html
    fi
done


# Humidity
h=()
for l in {54..558..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val >=0" |bc -l) && $(echo "$val <= 20" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: LightCyan; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 20" |bc -l) && $(echo "$val <= 40" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Lavender; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 40" |bc -l) && $(echo "$val <= 60" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: LightBlue; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 60" |bc -l) && $(echo "$val <= 80" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: DeepSkyBlue; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 80" |bc -l) && $(echo "$val <= 100" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Blue; color: white\"/g" finalImage.html
    fi
done


# Dew Point
h=()
for l in {53..557..24}
    do h+=($l)
done


for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val <= 10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: LightBlue; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 10" |bc -l) && $(echo "$val <= 12" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #01A9DB; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 12" |bc -l) && $(echo "$val <= 15" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: green; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 15" |bc -l) && $(echo "$val <= 18" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: yellow; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 18" |bc -l) && $(echo "$val <= 21" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #ff5500; color: white\"/g" finalImage.html
    elif (( $(echo "$val > 21" |bc -l) && $(echo "$val <= 24" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #ff8000; color: white\"/g" finalImage.html
    elif (( $(echo "$val > 24" |bc -l) && $(echo "$val <= 26" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: red; color: white\"/g" finalImage.html
    elif (( $(echo "$val > 26") ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: maroon; color: white\"/g" finalImage.html
    fi
done


# Wind power
h=()
for l in {55..559..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val <= 1" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #ffffff; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 1" |bc -l) && $(echo "$val <= 5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #e6ffe6; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 5" |bc -l) && $(echo "$val <= 11" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #ccffcc; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 11" |bc -l) && $(echo "$val <= 19" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #b3ffb3; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 19" |bc -l) && $(echo "$val <= 28" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #99ff99; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 28" |bc -l) && $(echo "$val <= 38" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #80ff80; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 38" |bc -l) && $(echo "$val <= 49" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #66ff66; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 49" |bc -l) && $(echo "$val <= 61" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #4dff4d; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 61" |bc -l) && $(echo "$val <= 74" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #33ff33; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 74" |bc -l) && $(echo "$val <= 88" |bc -l) ))
        then sed -i -e "s45d=$(echo $i)\>/id=$(echo $i) style=\"background-color: #1aff1a; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 88" |bc -l) && $(echo "$val <= 102" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #00ff00; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 102" |bc -l) && $(echo "$val <= 117" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #00e600; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 117" |bc -l) && $(echo "$val <= 176" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #00cc00; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 176" |bc -l) && $(echo "$val <= 204" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #00b300; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 204" |bc -l) && $(echo "$val <= 241" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #009900; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 241" |bc -l) && $(echo "$val <= 287" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #008000; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 287" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #006600; color: black\"/g" finalImage.html
    fi
done


# Cloud cover low
h=()
for l in {57..561..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val >= 0" |bc -l) && $(echo "$val <= 5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #FFFFFF; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 5" |bc -l) && $(echo "$val <= 10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: LightGray; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 10" |bc -l) && $(echo "$val <= 30" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Silver; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 30" |bc -l) && $(echo "$val <= 60" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Gray; color: white\"/g" finalImage.html
    elif (( $(echo "$val > 60" |bc -l) && $(echo "$val <= 85" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: DarkGray; color: white\"/g" finalImage.html
    elif (( $(echo "$val > 85" |bc -l) && $(echo "$val <= 100" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Gray; color: white\"/g" finalImage.html
    fi
done


# Cloud cover middle
h=()
for l in {58..562..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val >= 0" |bc -l) && $(echo "$val <= 5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #FFFFFF; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 5" |bc -l) && $(echo "$val <= 10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: LightGray; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 10" |bc -l) && $(echo "$val <= 30" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Silver; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 30" |bc -l) && $(echo "$val <= 60" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Gray; color: white\"/g" finalImage.html
    elif (( $(echo "$val > 60" |bc -l) && $(echo "$val <= 85" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: DarkGray; color: white\"/g" finalImage.html
    elif (( $(echo "$val > 85" |bc -l) && $(echo "$val <= 100" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Gray; color: white\"/g" finalImage.html
    fi
done


# Cloud cover high
h=()
for l in {59..563..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val >= 0" |bc -l) && $(echo "$val <= 5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #FFFFFF; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 5" |bc -l) && $(echo "$val <= 10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: LightGray; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 10" |bc -l) && $(echo "$val <= 30" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Silver; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 30" |bc -l) && $(echo "$val <= 60" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Gray; color: white\"/g" finalImage.html
    elif (( $(echo "$val > 60" |bc -l) && $(echo "$val <= 85" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: DarkGray; color: white\"/g" finalImage.html
    elif (( $(echo "$val > 85" |bc -l) && $(echo "$val <= 100" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Gray; color: white\"/g" finalImage.html
    fi
done


# Precipitations rate
h=()
for l in {64..568..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val == 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: White; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 0" |bc -l) && $(echo "$val < 1" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #CCFAF4; color: black\"/g" finalImage.html
    elif (( $(echo "$val >= 1" |bc -l) && $(echo "$val < 2.5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #A8DBEA; color: black\"/g" finalImage.html
    elif (( $(echo "$val >= 2.5" |bc -l) && $(echo "$val < 10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Blue; color: white\"/g" finalImage.html
    elif (( $(echo "$val >= 10" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Dark-Blue; color: white\"/g" finalImage.html
    fi
done


# Rain (categorical)
h=()
for l in {63..567..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val == 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: White; color: black\"/g" finalImage.html
    elif (( $(echo "$val == 1" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Green; color: white\"/g" finalImage.html
    fi
done


# Total precipitations
h=()
for l in {66..570..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val == 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: White; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 0" |bc -l) && $(echo "$val < 16.7" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: LightGreen; color: black\"/g" finalImage.html
    elif (( $(echo "$val >= 16.7" |bc -l) && $(echo "$val < 33.3" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Yellow; color: black\"/g" finalImage.html
    elif (( $(echo "$val >= 33.3" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Red; color: white\"/g" finalImage.html
    fi
done


# Convective precipitations rate
h=()
for l in {65..569..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val == 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: White; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Brown; color: white\"/g" finalImage.html
    fi
done


# Convective total precipitations
h=()
for l in {67..571..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val == 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: White; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Orange; color: black\"/g" finalImage.html
    fi
done


# Freezing Rain (categorical)
h=()
for l in {68..572..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val == 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: White; color: black\"/g" finalImage.html
    elif (( $(echo "$val == 1" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Dark-Grey; color: white\"/g" finalImage.html
    fi
done


# Ice Pellets (categorical)
h=()
for l in {70..574..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val == 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: White; color: black\"/g" finalImage.html
    elif (( $(echo "$val == 1" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Black; color: white\"/g" finalImage.html
    fi
done


# Frozen precipitations (percentage)
h=()
for l in {69..573..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    #valConv=$(convert $val)
    valConv=$(echo $val | awk '{printf "%4.6f\n",$1}')
    if (( $(echo "$valConv < 1.915" |bc -l) )) 
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: White; color: black\"/g" finalImage.html
    elif (( $(echo "$valConv <= 0.895" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #E8DAEF; color: black\"/g" finalImage.html
    elif (( $(echo "$valConv <= 0.49" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #D2B4DE; color: black\"/g" finalImage.html
     elif (( $(echo "$valConv <= 0.21" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #BB8FCE; color: white\"/g" finalImage.html
     elif (( $(echo "$valConv <= -0.5" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #A569BD; color: white\"/g" finalImage.html
     elif (( $(echo "$valConv <= -0.825" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #8E44AD; color: white\"/g" finalImage.html
     elif (( $(echo "$valConv <= -1.28" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #7D3C98; color: white\"/g" finalImage.html
     elif (( $(echo "$valConv <= -1.75" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #6C3483; color: white\"/g" finalImage.html
     elif (( $(echo "$valConv <= -2.9" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: #5B2C6F; color: white\"/g" finalImage.html
     fi
done


# Snow (categorical)
h=()
for l in {71..575..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val == 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: White; color: black\"/g" finalImage.html
    elif (( $(echo "$val == 1" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Dark-Yellow; color: black\"/g" finalImage.html
    fi
done


# Snow
h=()
for l in {72..576..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val == 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: White; color: black\"/g" finalImage.html
    elif (( $(echo "$val > 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Yellow; color: black\"/g" finalImage.html
    fi
done


# Lifted Index
h=()
for l in {60..564..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val >= 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: White; color: black\"/g" finalImage.html
    elif (( $(echo "$val > -2" |bc -l) && $(echo "$val < 0" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Cyan; color: black\"/g" finalImage.html
    elif (( $(echo "$val > -4" |bc -l) && $(echo "$val <= -2" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Lightseagreen; color: black\"/g" finalImage.html
    elif (( $(echo "$val > -6" |bc -l) && $(echo "$val <= -4" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: cadetblue; color: white\"/g" finalImage.html
    elif (( $(echo "$val < -6" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: darkcyan; color: white\"/g" finalImage.html
    fi
done


# CAPE
h=()
for l in {61..565..24}
    do h+=($l)
done

for i in "${h[@]}"
do
    val=$(cat finalImage.html | grep "id=$(echo $i)>" | awk -F[=\>] '{print $3}' | awk -F[=\<] '{print $1}')
    if (( $(echo "$val < 500" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: While; color: black\"/g" finalImage.html
    elif (( $(echo "$val >= 500" |bc -l) && $(echo "$val < 1000" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Gold; color: black\"/g" finalImage.html
    elif (( $(echo "$val >= 1000" |bc -l) && $(echo "$val < 2000" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Orange; color: white\"/g" finalImage.html
    elif (( $(echo "$val > 2000" |bc -l) ))
        then sed -i -e "s/id=$(echo $i)\>/id=$(echo $i) style=\"background-color: Orangered; color: white\"/g" finalImage.html
    fi
done

if [ -d imageFiles ]   # control if the imageFiles folder exists 
then 
    echo "..creating folder"
else
    $(mkdir imageFiles)
fi

# Transform the html into an image
now=$(date +%d%m%Y_%H%M)
xvfb-run --server-args="-screen 0, 1024x768x24" cutycapt --url=file://$PWD/finalImage.html --out=/$PWD/imageFiles/finalImage_$now.png