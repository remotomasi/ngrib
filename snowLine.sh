#!/bin/bash

cat final.txt | cut -d',' -f1,41,21,13,76,35,20,12,4,55  > sw.csv #,21,13,76,35,20,12,4,55
#sed -i -e '/03:00/d;/09:00/d;/15:00/d;/21:00/d' sw.csv
#sed '/00:00/d;/03:00/d;/15:00/d;/21:00/d' final.html > finalImages2.html
#sed '1d;2d;3d;27d;28d' finalImages2.html > finalImages3.html
#sed 's/<\/td><td>/|/g' finalImages3.html > finalImages4.html

# restoration of some title for Wind and WindDirection
#sed -i -e 's/ PRMSL ,,/ PRMSL , WIND , WINDIR/g' sw.csv
#sed -i -e 's/ mean_sea ,,/ mean_sea , 10m , 10m/g' sw.csv

# some operations on the values
awk 'BEGIN{FS=OFS=","}{if (NR<3) print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,"1000-500","1000-700","1000-850","850-700","850-500","700-500" }' sw.csv > swImages.csv #$1,$9,$8,$7,$6,$4,$3,$2,$5,$2-$5,$2-$7,$-$2
awk 'BEGIN{FS=OFS=","}{if (NR>=3) print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$2-$7,$3-$7,$5-$7,$3-$5,$2-$5,$2-$3 }' sw.csv > swImages1.csv
#awk 'BEGIN{FS=OFS=","}{if (NR>=3) print $1,$10,$8-$9,$7-$9,$7-$8,$6-$7,$6-$8,$6-$9,$5,$4,$3,$2 }' sw.csv > swImages1.csv	# added function that transform direction from degree to a capital letter

cat swImages1.csv >> swImages.csv

echo -e "<html><head><link rel="stylesheet" href="graphic.css"></head><body><table style='font-family:Arial; font-size:75%; white-space:nowrap; overflow: hidden; border-collapse: collapse; text-align:center' border='1' align='center'>" > sw.html
    while read INPUT ; do
            echo "<tr><td>${INPUT//,/</td><td>}</td></tr>" >> sw.html;
    done < swImages.csv;
echo -e "</font></table></body></html>" >> sw.html

# Transform the html into an image
now=$(date +%d%m%Y_%H%M)
xvfb-run --server-args="-screen 0, 1024x768x24" cutycapt --url=file://$PWD/sw.html --out=/$PWD/imageFiles/finalSWL_$now.png

# remove useless files
rm swImages1.csv #swImages.csv