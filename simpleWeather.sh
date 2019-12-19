#!/bin/bash

cat final.txt | cut -d',' -f1,41,43,44,45,48,39,67,68,69 | sed '/03:00/d;/09:00/d;/15:00/d;/21:00/d' > sw.csv
sed -i -e '/03:00/d;/09:00/d;/15:00/d;/21:00/d' sw.csv
#sed '/00:00/d;/03:00/d;/15:00/d;/21:00/d' final.html > finalImages2.html
#sed '1d;2d;3d;27d;28d' finalImages2.html > finalImages3.html
#sed 's/<\/td><td>/|/g' finalImages3.html > finalImages4.html

# restoration of some title for Wind and WindDirection
sed -i -e 's/ PRMSL ,,/ PRMSL , WIND , WINDIR/g' sw.csv
sed -i -e 's/ mean_sea ,,/ mean_sea , 10m , 10m/g' sw.csv

# some operations on the values
awk 'BEGIN{FS=OFS=","}
function windDirection(x) {
	if ((x > 335) || (x <= 25)) {
		print $1,$3,$4,int((sqrt($5*$5+$6*$6))*3.6),"N",$7,$8,$9,$10,$2*100
    }
	else if	((x > 25) && (x <= 65)) {
		print $1,$3,$4,int((sqrt($5*$5+$6*$6))*3.6),"NE",$7,$8,$9,$10,$2*10
    }
	else if ((x > 65) && (x <= 115)) {
		print $1,$3,$4,int((sqrt($5*$5+$6*$6))*3.6),"E",$7,$8,$9,$10,$2*100
    }
	else if ((x > 115) && (x <= 155)) {
		print $1,$3,$4,int((sqrt($5*$5+$6*$6))*3.6),"SE",$7,$8,$9,$10,$2*100
    }
	else if ((x > 155) && (x <= 205)) {
		print $1,$3,$4,int((sqrt($5*$5+$6*$6))*3.6),"S",$7,$8,$9,$10,$2*100
    }
	else if ((x > 205) && (x <= 245)) {
		print $1,$3,$4,int((sqrt($5*$5+$6*$6))*3.6),"SE",$7,$8,$9,$10,$2*100
    }
	else if ((x > 245) && (x <= 295)) {
		print $1,$3,$4,int((sqrt($5*$5+$6*$6))*3.6),"W",$7,$8,$9,$10,$2*100
    }
	else if ((x > 295) && (x <= 335)) {
		print $1,$3,$4,int((sqrt($5*$5+$6*$6))*3.6),"NW",$7,$8,$9,$10,$2*100
    }
}
{if (NR>=3) print windDirection((atan2($5,$6)*57.3+180)) }'  sw.csv > swImages1.csv		# added function that transform direction from degree to a capital letter
awk 'BEGIN{FS=OFS=","}{if (NR<3) print $1,$3,$4,$5,$6,$7,$8,$9,$10,$2 }' sw.csv > swImages.csv

cat swImages1.csv >> swImages.csv

echo -e "<html><head><link rel="stylesheet" href="graphic.css"></head><body><table style='font-family:"Arial", Courier, monospace; font-size:70%; white-space:nowrap; overflow: hidden; border-collapse: collapse; text-align:center' border='1' align='center'>" > sw.html
    while read INPUT ; do
            echo "<tr><td>${INPUT//,/</td><td>}</td></tr>" >> sw.html;
    done < swImages.csv;
echo -e "</font></table></body></html>" >> sw.html

# substitution of Labels
sed -i -e 's/UGRD/Vento (Kmh)/g' sw.html
sed -i -e 's/VGRD/Vento Dir./g' sw.html
sed -i -e 's/TMP/Temp. (deg)/g' sw.html
sed -i -e 's/RH/Umidita (%)/g' sw.html
sed -i -e 's/PRATE/Pioggia (mm/h)/g' sw.html
sed -i -e 's/TCDC/Nuvolosita (%)/g' sw.html
sed -i -e 's/SNOD/Neve (cm)/g' sw.html
sed -i -e 's/low_cloud/Bassa/g' sw.html
sed -i -e 's/middle_cloud/Media/g' sw.html
sed -i -e 's/high_cloud/Alta/g' sw.html

# restoration of some title: 100 -> TCDC // 100 -> high_cloud
sed -i -e 's/TCDC <\/td><td>100</TCDC <\/td><td> TCDC </g' sw.html
sed -i -e 's/middle_cloud <\/td><td>100</middle_cloud <\/td><td> high_cloud </g' sw.html

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

# Transform the html into an image
now=$(date +%d%m%Y_%H%M)
xvfb-run --server-args="-screen 0, 1024x768x24" cutycapt --url=file://$PWD/sw.html --out=/$PWD/imageFiles/finalSW_$now.png

# remove useless files
rm sw.html? sw.csv? swImages.csv?