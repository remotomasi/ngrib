#!/bin/bash
#################################################################################
#	BASH program to download and parse grib2 files and generate a final csv file
#	Thanks to NOAA - http://nomads.ncep.noaa.gov
#
#	by Remo Tomasi
#	24-02-2019 v0.31
#	16-04-2019 v0.5
#################################################################################

#echo -e "Insert latitude and longitude separated by spaces (i.e.: 60.75 21.34)"
#read lat lon

lat=$1
lon=$2

# calculation of the coordinates of the square area
lat1=`echo $lat+0.1|bc`
lat2=`echo $lat-0.1|bc`
lon1=`echo $lon+0.1|bc`
lon2=`echo $lon-0.1|bc`

today=$(date +%Y%m%d)

o=00
o=$(date +%H)
hh=""
if [ "$o" -ge 0 ] && [ "$o" -lt 8 ]
	then hh="18"
		today=$(date +%Y%m%d -d "yesterday")
elif [ "$o" -ge 8 ] && [ "$o" -lt 12 ]
	then hh="00"
elif [ "$o" -ge 12 ] && [ "$o" -lt 18 ]
	then hh="06"
elif [ "$o" -ge 18 ]
	then hh="12"
fi

#today="20190115"

h=(000 003 006 009 012 015 018 021 024 027 030 033 036 039 042 045 048 051 054 057 060 063 066 069 072 075 078 081 084 087 090 093 096 099 102 105 108 111 114 117 120 123 126 129 132)

# OS VERSION - only Ubuntu/Windows
unameOut="$(uname -a)"
# case "${unameOut}" in
#     Linux*)     machine=Linux;;
#     Darwin*)    machine=Mac;;
#     CYGWIN*)    machine=Cygwin;;
#     MINGW*)     machine=MinGw;;
#     *)          machine="UNKNOWN:${unameOut}"
# esac
#echo ${machine}
if [[ $unameOut == *"Ubuntu"* ]]
	then
		command="wgrib2"
elif [[ $unameOut == *"Microsoft"* ]]
	then
		command="wgrib2.exe"
fi

# curl VERSION
# for i in ${h[*]}; do curl "http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t${hh}z.pgrb2.0p25.f${i}&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_2_m_above_ground=on&lev_500_mb=on&lev_700_mb=on&lev_850_mb=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_mean_sea_level=on&lev_middle_cloud_layer=on&lev_surface=on&lev_tropopause=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HGT=on&var_ICEC=on&var_LFTX=on&var_PEVPR=on&var_PRATE=on&var_PRES=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&subregion=&leftlon=$lon&rightlon=$lon&toplat=$lat&bottomlat=$lat&dir=%2Fgfs.${today}${hh}" -o pro$i; done

# wget VERSION

wget "https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25_1hr.pl?file=gfs.t${hh}z.pgrb2.0p25.anl&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_2_m_above_ground=on&lev_500_mb=on&lev_700_mb=on&lev_850_mb=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_mean_sea_level=on&lev_middle_cloud_layer=on&lev_surface=on&lev_tropopause=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HGT=on&var_ICEC=on&var_LFTX=on&var_PEVPR=on&var_PRATE=on&var_PRES=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&subregion=&leftlon=$lon2&rightlon=$lon1&toplat=$lat1&bottomlat=$lat2&dir=%2Fgfs.${today}%2F${hh}"  2>/dev/null -O - > anlFile
run="$(./$command anlFile | head -n 1  | cut -d'=' -f2 | cut -c9-10)"

for i in ${h[*]};
	do
		#wget "http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t${hh}z.pgrb2.0p25.f${i}&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_2_m_above_ground=on&lev_500_mb=on&lev_700_mb=on&lev_850_mb=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_mean_sea_level=on&lev_middle_cloud_layer=on&lev_surface=on&lev_tropopause=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HGT=on&var_ICEC=on&var_LFTX=on&var_PEVPR=on&var_PRATE=on&var_PRES=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&subregion=&leftlon=$lon&rightlon=$lon&toplat=$lat&bottomlat=$lat&dir=%2Fgfs.${today}${hh}"  2>/dev/null -O - > pro$i
		wget "https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t${hh}z.pgrb2.0p25.f${i}&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_2_m_above_ground=on&lev_500_mb=on&lev_700_mb=on&lev_850_mb=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_mean_sea_level=on&lev_middle_cloud_layer=on&lev_surface=on&lev_tropopause=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HGT=on&var_ICEC=on&var_LFTX=on&var_PEVPR=on&var_PRATE=on&var_PRES=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&subregion=&leftlon=$lon2&rightlon=$lon1&toplat=$lat1&bottomlat=$lat2&dir=%2Fgfs.${today}%2F${hh}"  2>/dev/null -O - > pro$i
		./$command pro$i -csv csv$i.csv		# obtain infos from gribs to csvs
		cat csv$i.csv >> final.csv			# merge of csvs
done
for i in ${h[*]}; do cut -d',' -f7 csv$i.csv | paste -s; done  | tail -n +2 > p.csv 	# union of the values of all the grib files
for i in ${h[*]}; do cut -d',' -f2 csv$i.csv | head -1; done | tail -n +2 > p1.csv		# obtain date $1umn

echo ',' > p2.csv							# adding a comma in p2.csv temporary file
cut -d',' -f3 csv003.csv >> p2.csv			# adding labels + sublabels to p2.csv: labels complete!
echo ',' > p2b.csv							# adding a comma in p2b.csv temporary file
cut -d',' -f4 csv003.csv >> p2b.csv			# atmosphere labels
cat p2.csv | paste -s > p2c.csv				# labels
cat p2b.csv | paste -s >> p2c.csv			# labels + atmosphere labels
cat p2c.csv | tr ' ' '_' > p2d.csv			# transform spaces to _ (to obtain one word")
paste -d',' p1.csv p.csv > p5.csv			# adding date to datas

awk 'BEGIN{FS=OFS=";"}{if (NR>=3&&NR<=46) print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$70,$71,$72,$73,$74,$75,$76,$77,$78,$79 }' p5.csv
cut -d',' -f2 p2d.csv > p3.csv				# taking the 2nd column after the comma
cat p5.csv >> p3.csv						# adding labels + (date + datas)
cat p3.csv | tr '\t' ',' > p6.csv			# convert tabs and commas into semicolon

#cat p6.csv | cut -d',' -f6,7,8,9,13,14,15,16,20,21,22,23,25,26,27,28,29,32,33,34,58,60,61,62,65 --complement > p6d.csv
#cat p6.csv | cut -d',' -f6,7,8,9,10,13,14,15,16,17,18,19,22,23,24,25,26,27,28,29,30,31,32,33,34,70,71,72,73,74,75,77 --complement > p6d.csv
cat p6.csv > p6d.csv

awk 'BEGIN{FS=OFS=","}{if (NR>=1&&NR<=2) print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$70,$71,$72,$73,$74,$75,$76,$77,$78,$79 }' p6d.csv > p6e.csv

awk 'BEGIN{FS=OFS=","}
function windDirection(x) {
	if ((x > 335) || (x <= 25)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8,$9*3.6,$10*3.6,$11,$12,$13-273.15,$14,$15,$16,$17*3.6,$18*3.6,$19,$20,$21-273.15,$22,$23,$24,$25*3.6,$26*3.6,$27,$28-273.15,$29,$30,$31,$32*3.6,$33*3.6,$34,$35,$36,$37,$38-273.15,$39,$40,$41-273.15,$42-273.15,$43,$44*3.6,$45*3.6,$46,$47,$48,$49,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$70/100,$71,$72-273.15,$73*3.6,$74*3.6,$75,$76,$77,$78,$79/100,(sqrt($44*$44+$45*$45))*3.6,(atan2($44,$45)*57.3+180),"N"                   #North (Tramontana)
	}
	else if	((x > 25) && (x <= 65)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8,$9*3.6,$10*3.6,$11,$12,$13-273.15,$14,$15,$16,$17*3.6,$18*3.6,$19,$20,$21-273.15,$22,$23,$24,$25*3.6,$26*3.6,$27,$28-273.15,$29,$30,$31,$32*3.6,$33*3.6,$34,$35,$36,$37,$38-273.15,$39,$40,$41-273.15,$42-273.15,$43,$44*3.6,$45*3.6,$46,$47,$48,$49,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$70/100,$71,$72-273.15,$73*3.6,$74*3.6,$75,$76,$77,$78,$79/100,(sqrt($44*$44+$45*$45))*3.6,(atan2($44,$45)*57.3+180),"NE"                   #North (Tramontana)
	}
	else if ((x > 65) && (x <= 115)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8,$9*3.6,$10*3.6,$11,$12,$13-273.15,$14,$15,$16,$17*3.6,$18*3.6,$19,$20,$21-273.15,$22,$23,$24,$25*3.6,$26*3.6,$27,$28-273.15,$29,$30,$31,$32*3.6,$33*3.6,$34,$35,$36,$37,$38-273.15,$39,$40,$41-273.15,$42-273.15,$43,$44*3.6,$45*3.6,$46,$47,$48,$49,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$70/100,$71,$72-273.15,$73*3.6,$74*3.6,$75,$76,$77,$78,$79/100,(sqrt($44*$44+$45*$45))*3.6,(atan2($44,$45)*57.3+180),"E"                   #North (Tramontana)
	}
	else if ((x > 115) && (x <= 155)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8,$9*3.6,$10*3.6,$11,$12,$13-273.15,$14,$15,$16,$17*3.6,$18*3.6,$19,$20,$21-273.15,$22,$23,$24,$25*3.6,$26*3.6,$27,$28-273.15,$29,$30,$31,$32*3.6,$33*3.6,$34,$35,$36,$37,$38-273.15,$39,$40,$41-273.15,$42-273.15,$43,$44*3.6,$45*3.6,$46,$47,$48,$49,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$70/100,$71,$72-273.15,$73*3.6,$74*3.6,$75,$76,$77,$78,$79/100,(sqrt($44*$44+$45*$45))*3.6,(atan2($44,$45)*57.3+180),"SE"                   #North (Tramontana)
	}
	else if ((x > 155) && (x <= 205)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8,$9*3.6,$10*3.6,$11,$12,$13-273.15,$14,$15,$16,$17*3.6,$18*3.6,$19,$20,$21-273.15,$22,$23,$24,$25*3.6,$26*3.6,$27,$28-273.15,$29,$30,$31,$32*3.6,$33*3.6,$34,$35,$36,$37,$38-273.15,$39,$40,$41-273.15,$42-273.15,$43,$44*3.6,$45*3.6,$46,$47,$48,$49,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$70/100,$71,$72-273.15,$73*3.6,$74*3.6,$75,$76,$77,$78,$79/100,(sqrt($44*$44+$45*$45))*3.6,(atan2($44,$45)*57.3+180),"S"                   #North (Tramontana)
	}
	else if ((x > 205) && (x <= 245)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8,$9*3.6,$10*3.6,$11,$12,$13-273.15,$14,$15,$16,$17*3.6,$18*3.6,$19,$20,$21-273.15,$22,$23,$24,$25*3.6,$26*3.6,$27,$28-273.15,$29,$30,$31,$32*3.6,$33*3.6,$34,$35,$36,$37,$38-273.15,$39,$40,$41-273.15,$42-273.15,$43,$44*3.6,$45*3.6,$46,$47,$48,$49,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$70/100,$71,$72-273.15,$73*3.6,$74*3.6,$75,$76,$77,$78,$79/100,(sqrt($44*$44+$45*$45))*3.6,(atan2($44,$45)*57.3+180),"SW"                   #North (Tramontana)
	}
	else if ((x > 245) && (x <= 295)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8,$9*3.6,$10*3.6,$11,$12,$13-273.15,$14,$15,$16,$17*3.6,$18*3.6,$19,$20,$21-273.15,$22,$23,$24,$25*3.6,$26*3.6,$27,$28-273.15,$29,$30,$31,$32*3.6,$33*3.6,$34,$35,$36,$37,$38-273.15,$39,$40,$41-273.15,$42-273.15,$43,$44*3.6,$45*3.6,$46,$47,$48,$49,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$70/100,$71,$72-273.15,$73*3.6,$74*3.6,$75,$76,$77,$78,$79/100,(sqrt($44*$44+$45*$45))*3.6,(atan2($44,$45)*57.3+180),"W"                   #North (Tramontana)
	}
	else if ((x > 295) && (x <= 335)) {
		print $1,$2,$3*3.6,$4,$5-273.15,$6,$7,$8,$9*3.6,$10*3.6,$11,$12,$13-273.15,$14,$15,$16,$17*3.6,$18*3.6,$19,$20,$21-273.15,$22,$23,$24,$25*3.6,$26*3.6,$27,$28-273.15,$29,$30,$31,$32*3.6,$33*3.6,$34,$35,$36,$37,$38-273.15,$39,$40,$41-273.15,$42-273.15,$43,$44*3.6,$45*3.6,$46,$47,$48,$49,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$70/100,$71,$72-273.15,$73*3.6,$74*3.6,$75,$76,$77,$78,$79/100,(sqrt($44*$44+$45*$45))*3.6,(atan2($44,$45)*57.3+180),"NW"                   #North (Tramontana)
	}
}
{if (NR>=3&&NR<=46) print windDirection((atan2($44,$45)*57.3+180)) }' p6d.csv > p6f.csv			# added function that transform direction from degree to a capital letter

sed -i '/^$/d' p6f.csv						# delete void lines
cat p6f.csv >> p6e.csv

sed -i -e 's/2_m_above_ground/2m/g;s/10_m_above_ground/10m/g;s/low_cloud_layer/low_cloud/g' p6e.csv
sed -i -e 's/middle_cloud_layer/middle_cloud/g;s/high_cloud_layer/high_cloud/g' p6e.csv
sed -i -e 's/mean_sea_level/mean_sea/g;s/:00:00/:00/g' p6e.csv

#awk 'BEGIN{FS=OFS=","}{ print $1,$17,$18,$19,$20,$21,$43,$44,$45,$3,$35,$36,$37,$42,$23,$24,$25,$26,$30,$29,$28,$22,$27,$15,$32,$33,$38,$4,$7,$10,$14,$40,$41,$5,$8,$11,$6,$9,$12,$13,$2,$16,$39,$31,$10-$14,$7-$14,$4-$14,$7-$10,$4-$10,2.5-($17-$18),$34 }' p6e.csv > final.csv
#awk 'BEGIN{FS=OFS=","}{ print $1,$18,$22,$23,$24,$25,$54,$55,$56,$3,$42,$43,$44,$53,$27,$28,$29,$33,$30,$37,$36,$36,$38,$19,$40,$33,$45,$4,$8,$10,$15,$50,$51,$5,$8,$11,$7,$11,$12,$13,$3,$20,$46,$39,$10-$14,$8-$15,$4-$15,$8-$10,$4-$10,2.5-($18-$22),$41 }' p6e.csv > final.csv
awk 'BEGIN{FS=OFS=","}{ print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$80,$81,$82,$20-$35,$12-$35,$4-$35,$12-$20,$4-$20,2.5-($41-$42) }' p6e.csv > final.csv

cat final.csv | tr '"' ' ' > final.txt

echo -e "<html><body><table style='font-family:"Arial", Courier, monospace; font-size:60%; white-space:nowrap; overflow: hidden; border-collapse: collapse;' border='1'>" > final.html
    while read INPUT ; do
            echo "<tr><td>${INPUT//,/</td><td>}</td></tr>" >> final.html;
    done < final.txt ;
echo -e "</font></table></body></html>" >> final.html


# restoration of some title: 100 -> TCDC // 100 -> high_cloud
sed -i -e 's/TCDC <\/td><td>100<\/td><td> PRMSL/TCDC <\/td><td> TCDC <\/td><td> PRMSL/g' final.html
sed -i -e 's/middle_cloud <\/td><td>100<\/td><td> mean_sea/middle_cloud <\/td><td> high_cloud <\/td><td> mean_sea/g' final.html

# cleaning of some files
if [ -e "final.csv" ]; then rm final.csv; fi	# remove final.csv
for i in ${h[*]};								# remove all pro*.csv and csv*.csv files
	do
		$(if [ -e "pro$i" ]; then rm pro$i; fi)
		$(if [ -e "csv$i.csv" ]; then rm csv$i.csv; fi)
done

rm p*.csv	# remove all p*.csv

# graphic part
cat final.txt | tr '|' ' ' | tr ',' ' ' | tr '"' ' ' | cut -d' ' -f2- > final2.csv
sed -i -e 's/  / /g;s/:00:00/ /g;s/  / /g' final2.csv
awk '{if (NR>=3&&NR<46) print $0, NR }' final2.csv > final3.csv	# added the number of the line at the end of each of them

if [ -d graphs ]   # control if the imageFiles folder exists 
then 
    echo "..creating folder"
else
    $(mkdir graphs)
fi

gnuplot -e "run=$run" ./weather.pg > graphs/weather.png
gnuplot -e "run=$run" ./pressureWind.pg > graphs/pressureWind.png
gnuplot -e "run=$run" ./precipitations.pg > graphs/precipitations.png
gnuplot -e "run=$run" ./clouds.pg > graphs/clouds.png
gnuplot -e "run=$run" ./hgt.pg > graphs/hgt.png
gnuplot -e "run=$run" ./temperatures.pg > graphs/temperatures.png
gnuplot -e "run=$run" ./cape-lftx.pg > graphs/cape-lftx.png
gnuplot -e "run=$run" ./precTypes.pg > graphs/precTypes.png
gnuplot -e "run=$run" ./cloud700.pg > graphs/cloud700.png

convert \( graphs/clouds.png graphs/cloud700.png graphs/precipitations.png  -append \) \( graphs/temperatures.png graphs/hgt.png graphs/precTypes.png -append \) \( graphs/weather.png graphs/pressureWind.png graphs/cape-lftx.png  -append \) +append graphs/weatherForecastFinal.png

# clean last created files
rm final2.csv
rm anlFile

# move data files into data folder

if [ -d data ]   # control if the imageFiles folder exists 
then 
    echo "..creating folder"
else
    $(mkdir data)
fi

mv *.csv data
mv *.html data