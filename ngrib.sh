#!/bin/bash
#################################################################################
#	BASH program to download and parse grib2 files and generate a final csv file
#	Thanks to NOAA - http://nomads.ncep.noaa.gov
#
#	by Remo Tomasi
#	12-02-2019 v0.21
#
#################################################################################

echo -e "Insert latitude and longitude (only integer values) separated by spaces (i.e.: 60 21)"
read lat lon

today=$(date +%Y%m%d)

o=00
o=$(date +%H)
hh=""
if [ "$o" -ge 0 ] && [ "$o" -lt 8 ]
	then hh="18"
		today=$(date +%Y%m%d -d "yesterday")
elif [ "$o" -ge 8 ] && [ "$o" -lt 13 ]
	then hh="00"
elif [ "$o" -ge 13 ] && [ "$o" -lt 18 ]
	then hh="06"
elif [ "$o" -ge 18 ]
	then hh="12"
fi

#today="20190115"

h=(000 003 006 009 012 015 018 021 024 027 030 033 036 039 042 045 048 051 054 057 060 063 066 069 072 075 078 081 084 087 090 093 096 099 102 105 108 111 114 117 120)

# curl VERSION
# for i in ${h[*]}; do curl "http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t${hh}z.pgrb2.0p25.f${i}&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_2_m_above_ground=on&lev_500_mb=on&lev_700_mb=on&lev_850_mb=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_mean_sea_level=on&lev_middle_cloud_layer=on&lev_surface=on&lev_tropopause=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HGT=on&var_ICEC=on&var_LFTX=on&var_PEVPR=on&var_PRATE=on&var_PRES=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&subregion=&leftlon=$lon&rightlon=$lon&toplat=$lat&bottomlat=$lat&dir=%2Fgfs.${today}${hh}" -o pro$i; done
# wget VERSION
for i in ${h[*]};
	do
		#wget "http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t${hh}z.pgrb2.0p25.f${i}&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_2_m_above_ground=on&lev_500_mb=on&lev_700_mb=on&lev_850_mb=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_mean_sea_level=on&lev_middle_cloud_layer=on&lev_surface=on&lev_tropopause=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HGT=on&var_ICEC=on&var_LFTX=on&var_PEVPR=on&var_PRATE=on&var_PRES=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&subregion=&leftlon=$lon&rightlon=$lon&toplat=$lat&bottomlat=$lat&dir=%2Fgfs.${today}${hh}"  2>/dev/null -O - > pro$i
		wget "http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_1p00.pl?file=gfs.t${hh}z.pgrb2.1p00.f${i}&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_2_m_above_ground=on&lev_500_mb=on&lev_700_mb=on&lev_850_mb=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_mean_sea_level=on&lev_middle_cloud_layer=on&lev_surface=on&lev_tropopause=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HGT=on&var_ICEC=on&var_LFTX=on&var_PEVPR=on&var_PRATE=on&var_PRES=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&subregion=&leftlon=$lon&rightlon=$lon&toplat=$lat&bottomlat=$lat&dir=%2Fgfs.${today}${hh}"  2>/dev/null -O - > pro$i
		./wgrib2.exe pro$i -csv csv$i.csv			# obtain infos from gribs to csvs
		cat csv$i.csv >> final.csv						# merge of csvs
done
for i in ${h[*]}; do cut -d',' -f7 csv$i.csv | paste -s; done  | tail -n +2 > p.csv # union of the values of all the grib files
for i in ${h[*]}; do cut -d',' -f2 csv$i.csv | head -1; done | tail -n +2> p1.csv		# obtain date $1umn

echo ',' > p2.csv												# adding a comma in p2.csv temporary file
cut -d',' -f3 csv033.csv >> p2.csv			# adding labels + sublabels to p2.csv: labels complete!
echo ',' > p2b.csv											# adding a comma in p2b.csv temporary file
cut -d',' -f4 csv033.csv >> p2b.csv			# atmosphere labels
cat p2.csv | paste -s > p2c.csv					# labels
cat p2b.csv | paste -s >> p2c.csv				# labels + atmosphere labels
cat p2c.csv | tr ' ' '_' > p2d.csv			# transform spaces to _ (to obtain one word")
paste -d',' p1.csv p.csv > p5.csv				# adding date to datas

awk 'BEGIN{FS=OFS=";"}{if (NR>=3&&NR<=42) print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42 }' p5.csv
cut -d',' -f2 p2d.csv > p3.csv			# taking the 2nd $1umn after the comma
cat p5.csv >> p3.csv								# adding labels + (date + datas)
cat p3.csv | tr '\t' ',' > p6.csv		# convert tabs and commas into semi$1on

cat p6.csv | cut -d',' -f6,7,8,9,13,14,15,16,20,21,22,23,25,26,27,28,29,32,33,34,58,60,61,62,65 --complement > p6d.csv

awk 'BEGIN{FS=OFS=","}{if (NR>=1&&NR<=2) print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42 }' p6d.csv > p6e.csv

col="$1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8-273.15,$9,$10,$11-273.15,$12,$13,$14,$15,$16,$17-273.15,$18-273.15,$19,$20*3.6,$21*3.6,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31/3600,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42/100,(sqrt($20*$20+$21*$21))*3.6,(atan2($20,$21)*57.3+180)"
awk 'BEGIN{FS=OFS=","}
function windDirection(x) {
	if ((x > 335) || (x <= 25)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8-273.15,$9,$10,$11-273.15,$12,$13,$14,$15,$16,$17-273.15,$18-273.15,$19,$20*3.6,$21*3.6,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31/3600,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42/100,(sqrt($20*$20+$21*$21))*3.6,(atan2($20,$21)*57.3+180),"N"                   #North (Tramontana)
	}
	else if	((x > 25) && (x <= 65)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8-273.15,$9,$10,$11-273.15,$12,$13,$14,$15,$16,$17-273.15,$18-273.15,$19,$20*3.6,$21*3.6,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31/3600,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42/100,(sqrt($20*$20+$21*$21))*3.6,(atan2($20,$21)*57.3+180),"NE"                  #North-East (Grecale)
	}
	else if ((x > 65) && (x <= 115)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8-273.15,$9,$10,$11-273.15,$12,$13,$14,$15,$16,$17-273.15,$18-273.15,$19,$20*3.6,$21*3.6,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31/3600,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42/100,(sqrt($20*$20+$21*$21))*3.6,(atan2($20,$21)*57.3+180),"E"                   #East (Levante)
	}
	else if ((x > 115) && (x <= 155)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8-273.15,$9,$10,$11-273.15,$12,$13,$14,$15,$16,$17-273.15,$18-273.15,$19,$20*3.6,$21*3.6,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31/3600,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42/100,(sqrt($20*$20+$21*$21))*3.6,(atan2($20,$21)*57.3+180),"SE"                  #South-East (Scirocco)
	}
	else if ((x > 155) && (x <= 205)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8-273.15,$9,$10,$11-273.15,$12,$13,$14,$15,$16,$17-273.15,$18-273.15,$19,$20*3.6,$21*3.6,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31/3600,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42/100,(sqrt($20*$20+$21*$21))*3.6,(atan2($20,$21)*57.3+180),"S"                   #South (Ostro)
	}
	else if ((x > 205) && (x <= 245)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8-273.15,$9,$10,$11-273.15,$12,$13,$14,$15,$16,$17-273.15,$18-273.15,$19,$20*3.6,$21*3.6,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31/3600,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42/100,(sqrt($20*$20+$21*$21))*3.6,(atan2($20,$21)*57.3+180),"SW"                  #South-West (Libeccio)
	}
	else if ((x > 245) && (x <= 295)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8-273.15,$9,$10,$11-273.15,$12,$13,$14,$15,$16,$17-273.15,$18-273.15,$19,$20*3.6,$21*3.6,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31/3600,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42/100,(sqrt($20*$20+$21*$21))*3.6,(atan2($20,$21)*57.3+180),"W"                   #West (Ponente)
	}
	else if ((x > 295) && (x <= 335)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8-273.15,$9,$10,$11-273.15,$12,$13,$14,$15,$16,$17-273.15,$18-273.15,$19,$20*3.6,$21*3.6,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31/3600,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42/100,(sqrt($20*$20+$21*$21))*3.6,(atan2($20,$21)*57.3+180),"NW"                  #North-West (Maestrale)
	}
}
{if (NR>=3&&NR<=42) print windDirection((atan2($20,$21)*57.3+180)) }' p6d.csv > p6f.csv			# added function that transform direction from degree to a capital letter

sed -i '/^$/d' p6f.csv				# delete void lines
# "'"`windDirection "$44"`"'"
cat p6f.csv >> p6e.csv

sed -i -e 's/2_m_above_ground/2m/g;s/10_m_above_ground/10m/g;s/low_cloud_layer/low_cloud/g' p6e.csv
sed -i -e 's/middle_cloud_layer/middle_cloud/g;s/high_cloud_layer/high_cloud/g' p6e.csv
sed -i -e 's/mean_sea_level/mean_sea/g;s/:00:00/:00/g' p6e.csv

awk 'BEGIN{FS=OFS=","}{ print $1,$17,$18,$19,$20,$21,$43,$44,$45,$3,$35,$36,$37,$42,$23,$24,$25,$26,$30,$29,$28,$22,$27,$15,$32,$33,$38,$4,$7,$10,$14,$40,$41,$5,$8,$11,$6,$9,$12,$13,$2,$16,$39,$31 }' p6e.csv > final.csv

cat final.csv | tr '"' ' ' > final.txt

echo -e "<html><body><table style='font-family:"Arial", Courier, monospace; font-size:60%; white-space:nowrap; overflow: hidden; border-collapse: collapse;' border='1'>" > final.html
    while read INPUT ; do
            echo "<tr><td>${INPUT//,/</td><td>}</td></tr>" >> final.html;
    done < final.txt ;
echo -e "</font></table></body></html>" >> final.html

# cleaning of some files
if [ -e "final.csv" ]; then rm final.csv; fi																# remove final.csv
for i in ${h[*]};
	do
		$(if [ -e "pro$i" ]; then rm pro$i; fi)
		$(if [ -e "csv$i.csv" ]; then rm csv$i.csv; fi)
done	# remove pro*.csv and csv*.csv
rm p*.csv																																		# remove all p*.csv