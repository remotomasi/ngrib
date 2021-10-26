#!/bin/bash
#################################################################################
#	BASH program to download and parse grib2 files and generate a final csv file
#	Thanks to NOAA - http://nomads.ncep.noaa.gov
#
#	by Remo Tomasi
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
m=$(date +%M)
hh=""
if ([ "$o" -ge 0 ] && [ "$o" -lt 8 ] || [ "$o" -ge 23 ]) # && [ "$m" -ge 15 ])
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
elif [[ $unameOut == *"Microsoft"* ]] || [[ $unameOut == *"microsoft"* ]]
	then
		command="wgrib2.exe"
fi

# curl VERSION
# for i in ${h[*]}; do curl "http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t${hh}z.pgrb2.0p25.f${i}&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_2_m_above_ground=on&lev_500_mb=on&lev_700_mb=on&lev_850_mb=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_mean_sea_level=on&lev_middle_cloud_layer=on&lev_surface=on&lev_tropopause=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HGT=on&var_ICEC=on&var_LFTX=on&var_PEVPR=on&var_PRATE=on&var_PRES=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&subregion=&leftlon=$lon&rightlon=$lon&toplat=$lat&bottomlat=$lat&dir=%2Fgfs.${today}${hh}" -o pro$i; done

# wget VERSION
#incipit="https://ftpprd.ncep.noaa.gov/data/nccf/com/gfs/prod/gfs."
#wget "$incipit$today/${hh}/filter_gfs_0p25_1hr.pl?file=gfs.t${hh}z.pgrb2.0p25.anl&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_2_m_above_ground=on&lev_500_mb=on&lev_700_mb=on&lev_850_mb=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_mean_sea_level=on&lev_middle_cloud_layer=on&lev_surface=on&lev_tropopause=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HGT=on&var_ICEC=on&var_LFTX=on&var_PEVPR=on&var_PRATE=on&var_PRES=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&subregion=&leftlon=$lon2&rightlon=$lon1&toplat=$lat1&bottomlat=$lat2&dir=%2Fgfs.${today}%2F${hh}"  2>/dev/null -O - > anlFile
wget "https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25_1hr.pl?file=gfs.t${hh}z.pgrb2.0p25.anl&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_200_mb=on&lev_2_m_above_ground=on&lev_300_mb=on&lev_400_mb=on&lev_500_mb=on&lev_600_mb=on&lev_700_mb=on&lev_850_mb=on&lev_925_mb=on&lev_950_mb=on&lev_975_mb=on&lev_mean_sea_level=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HCDC=on&var_HGT=on&var_HINDEX=on&var_ICEC=on&var_LCDC=on&var_LFTX=on&var_MCDC=on&var_PEVPR=on&var_POT=on&var_PRATE=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&var_HLCY=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_middle_cloud_layer=on&lev_3000-0_m_above_ground=on&subregion=&leftlon=$lon2&rightlon=$lon1&toplat=$lat1&bottomlat=$lat2&dir=%2Fgfs.${today}%2F${hh}%2Fatmos"  2>/dev/null -O - > anlFile
run="$(./$command anlFile | head -n 1  | cut -d'=' -f2 | cut -c9-10)"

# main function divided into 4 in parallel
# 1° function
for i in ${h[@]:0:11};
	do
		#wget "http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t${hh}z.pgrb2.0p25.f${i}&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_2_m_above_ground=on&lev_500_mb=on&lev_700_mb=on&lev_850_mb=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_mean_sea_level=on&lev_middle_cloud_layer=on&lev_surface=on&lev_tropopause=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HGT=on&var_ICEC=on&var_LFTX=on&var_PEVPR=on&var_PRATE=on&var_PRES=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&subregion=&leftlon=$lon&rightlon=$lon&toplat=$lat&bottomlat=$lat&dir=%2Fgfs.${today}${hh}"  2>/dev/null -O - > pro$i
		#wget "$incipit$today/${hh}/filter_gfs_0p25_1hr.pl?file=gfs.t${hh}z.pgrb2.0p25.f${i}&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_2_m_above_ground=on&lev_500_mb=on&lev_700_mb=on&lev_850_mb=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_mean_sea_level=on&lev_middle_cloud_layer=on&lev_surface=on&lev_tropopause=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HGT=on&var_ICEC=on&var_LFTX=on&var_PEVPR=on&var_PRATE=on&var_PRES=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&subregion=&leftlon=$lon2&rightlon=$lon1&toplat=$lat1&bottomlat=$lat2&dir=%2Fgfs.${today}%2F${hh}"  2>/dev/null -O - > pro$i
		wget "https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t${hh}z.pgrb2.0p25.f${i}&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_200_mb=on&lev_2_m_above_ground=on&lev_300_mb=on&lev_400_mb=on&lev_500_mb=on&lev_600_mb=on&lev_700_mb=on&lev_850_mb=on&lev_925_mb=on&lev_950_mb=on&lev_975_mb=on&lev_mean_sea_level=on&lev_surface=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HCDC=on&var_HGT=on&var_HINDEX=on&var_ICEC=on&var_LCDC=on&var_LFTX=on&var_MCDC=on&var_PEVPR=on&var_POT=on&var_PRATE=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&var_HLCY=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_middle_cloud_layer=on&lev_3000-0_m_above_ground=on&subregion=&leftlon=$lon2&rightlon=$lon1&toplat=$lat1&bottomlat=$lat2&dir=%2Fgfs.${today}%2F${hh}%2Fatmos"  2>/dev/null -O - > pro$i
		./$command pro$i -csv csv$i.csv		# obtain infos from gribs to csvs
		cat csv$i.csv >> final.csv			# merge of csvs
done &

# 2° function
for i in ${h[@]:11:11};
	do
		wget "https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t${hh}z.pgrb2.0p25.f${i}&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_200_mb=on&lev_2_m_above_ground=on&lev_300_mb=on&lev_400_mb=on&lev_500_mb=on&lev_600_mb=on&lev_700_mb=on&lev_850_mb=on&lev_925_mb=on&lev_950_mb=on&lev_975_mb=on&lev_mean_sea_level=on&lev_surface=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HCDC=on&var_HGT=on&var_HINDEX=on&var_ICEC=on&var_LCDC=on&var_LFTX=on&var_MCDC=on&var_PEVPR=on&var_POT=on&var_PRATE=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&var_HLCY=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_middle_cloud_layer=on&lev_3000-0_m_above_ground=on&subregion=&leftlon=$lon2&rightlon=$lon1&toplat=$lat1&bottomlat=$lat2&dir=%2Fgfs.${today}%2F${hh}%2Fatmos"  2>/dev/null -O - > pro$i
		./$command pro$i -csv csv$i.csv		# obtain infos from gribs to csvs
		cat csv$i.csv >> final.csv			# merge of csvs
done &

# 3° function
for i in ${h[@]:22:11};
	do
		wget "https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t${hh}z.pgrb2.0p25.f${i}&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_200_mb=on&lev_2_m_above_ground=on&lev_300_mb=on&lev_400_mb=on&lev_500_mb=on&lev_600_mb=on&lev_700_mb=on&lev_850_mb=on&lev_925_mb=on&lev_950_mb=on&lev_975_mb=on&lev_mean_sea_level=on&lev_surface=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HCDC=on&var_HGT=on&var_HINDEX=on&var_ICEC=on&var_LCDC=on&var_LFTX=on&var_MCDC=on&var_PEVPR=on&var_POT=on&var_PRATE=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&var_HLCY=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_middle_cloud_layer=on&lev_3000-0_m_above_ground=on&subregion=&leftlon=$lon2&rightlon=$lon1&toplat=$lat1&bottomlat=$lat2&dir=%2Fgfs.${today}%2F${hh}%2Fatmos"  2>/dev/null -O - > pro$i
		./$command pro$i -csv csv$i.csv		# obtain infos from gribs to csvs
		cat csv$i.csv >> final.csv			# merge of csvs
done &

# 4° function
for i in ${h[@]:33:12};
	do
		wget "https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t${hh}z.pgrb2.0p25.f${i}&lev_0C_isotherm=on&lev_1000_mb=on&lev_10_m_above_ground=on&lev_200_mb=on&lev_2_m_above_ground=on&lev_300_mb=on&lev_400_mb=on&lev_500_mb=on&lev_600_mb=on&lev_700_mb=on&lev_850_mb=on&lev_925_mb=on&lev_950_mb=on&lev_975_mb=on&lev_mean_sea_level=on&lev_surface=on&var_ABSV=on&var_ACPCP=on&var_APCP=on&var_CAPE=on&var_CFRZR=on&var_CICEP=on&var_CIN=on&var_CPOFP=on&var_CPRAT=on&var_CRAIN=on&var_CSNOW=on&var_DPT=on&var_GUST=on&var_HCDC=on&var_HGT=on&var_HINDEX=on&var_ICEC=on&var_LCDC=on&var_LFTX=on&var_MCDC=on&var_PEVPR=on&var_POT=on&var_PRATE=on&var_PRMSL=on&var_RH=on&var_SNOD=on&var_SUNSD=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_VIS=on&var_VVEL=on&var_VWSH=on&var_HLCY=on&lev_high_cloud_layer=on&lev_low_cloud_layer=on&lev_middle_cloud_layer=on&lev_3000-0_m_above_ground=on&subregion=&leftlon=$lon2&rightlon=$lon1&toplat=$lat1&bottomlat=$lat2&dir=%2Fgfs.${today}%2F${hh}%2Fatmos"  2>/dev/null -O - > pro$i
		./$command pro$i -csv csv$i.csv		# obtain infos from gribs to csvs
		cat csv$i.csv >> final.csv			# merge of csvs
done &


wait # wait until the previous functions ended

for i in ${h[*]}; do cut -d',' -f7 csv$i.csv | paste -s; done | tail -n +2 > values.csv # p 	# union of the values of all the grib files
for i in ${h[*]}; do cut -d',' -f2 csv$i.csv | head -1; done | tail -n +2 > date.csv	# p1		# obtain date $1umn

echo ',' > a.csv							# adding a comma in p2.csv temporary file
cut -d',' -f3 csv003.csv >> a.csv			# adding labels + sublabels to p2.csv: labels complete!
echo ',' > b.csv							# adding a comma in p2b.csv temporary file
cut -d',' -f4 csv003.csv >> b.csv			# atmosphere labels
paste a.csv b.csv > c.csv					# labels
#cat p2b.csv | paste -s >> p2c.csv			# labels + atmosphere labels	# p2c.csv
cat c.csv | tr ' ' '_'  | tr '\n' ',' | tr '"' ' ' | tr '\t' '-' | cut -c 4- | tr '\t'  ',' > d.csv			# transform spaces to _ (to obtain one word") p2d.csv
paste -d',' date.csv values.csv > e.csv						# adding date to datas
cat e.csv | tr '\t' ',' >> d.csv							# adding values to the head

# deleting double quotes from the date >> deleting the last part of the time format ":00" and spaces before and after comma
cat d.csv | tr '"' ' ' | sed -i -e 's/, /,/g;s/ ,/,/g;s/:00:00/:00/g' d.csv 

# adding a comma and a progressive number at the end of each line and substitute ',,' with ',' where found 
sed 's/$/,/' d.csv | awk '{if (NR>=1&&NR<46) print $0, NR }' | sed 's/,,/,/g' > final.csv

# awk '{if (NR>=2&&NR<46) print $0, NR }' d.csv > final.csv	# added count numbers as last column

# transforming the foinal.csv into an html file
echo -e "<html><body><table style='font-family:"Arial", Courier, monospace; font-size:60%; white-space:nowrap; overflow: hidden; border-collapse: collapse;' border='1'>" > final.html
    while read INPUT ; do
            echo "<tr><td>${INPUT//,/</td><td>}</td></tr>" >> final.html;
    done < final.csv ;
echo -e "</font></table></body></html>" >> final.html

# cleaning of some files
# if [ -e "final.csv" ]; then rm final.csv; fi	# remove final.csv
for i in ${h[*]};								# remove all pro*.csv and csv*.csv files
	do
		$(if [ -e "pro$i" ]; then rm pro$i; fi)
		$(if [ -e "csv$i.csv" ]; then rm csv$i.csv; fi)
done

tail -n +2 final.csv > data.csv	# obtaining data.csv containing only data without the first line (head)

# control if the imageFiles folder already exists
if [ -d graphs ]   
then
    echo "..creating folder"
else
    $(mkdir graphs)
fi

gnuplot -e "run=$run;lat=$lat;lon=$lon" ./weather.pg > graphs/weather.png
gnuplot -e "run=$run;lat=$lat;lon=$lon" ./pressureWind.pg > graphs/pressureWind.png
gnuplot -e "run=$run;lat=$lat;lon=$lon" ./precipitations.pg > graphs/precipitations.png
gnuplot -e "run=$run;lat=$lat;lon=$lon" ./clouds.pg > graphs/clouds.png
gnuplot -e "run=$run;lat=$lat;lon=$lon" ./hgt.pg > graphs/hgt.png
gnuplot -e "run=$run;lat=$lat;lon=$lon" ./temperatures.pg > graphs/temperatures.png
gnuplot -e "run=$run;lat=$lat;lon=$lon" ./cape-lftx.pg > graphs/cape-lftx.png
gnuplot -e "run=$run;lat=$lat;lon=$lon" ./precTypes.pg > graphs/precTypes.png
gnuplot -e "run=$run;lat=$lat;lon=$lon" ./health.pg > graphs/health.png
gnuplot -e "run=$run;lat=$lat;lon=$lon" ./stability.pg > graphs/stability.png
gnuplot -e "run=$run;lat=$lat;lon=$lon" ./sweat.pg > graphs/sweat.png
gnuplot -e "run=$run;lat=$lat;lon=$lon" ./kindex.pg > graphs/kindex.png

convert \( graphs/weather.png graphs/health.png graphs/pressureWind.png  -append \) \( graphs/temperatures.png graphs/hgt.png graphs/precTypes.png -append \) \( graphs/cape-lftx.png graphs/kindex.png graphs/sweat.png  -append \) \( graphs/stability.png graphs/clouds.png graphs/precipitations.png -append \) +append graphs/weatherForecastFinal.png

python3 convertXLSX.py
python3 saveFile.py
python3 my.py

# delete previous pdf, png and xlsx versions
if [ -f simpleWeatherSimply.pdf ] 
then
	rm simpleWeatherSimply.pdf 
fi

if [ -f simpleWeatherSimply.png ]
then
	rm simpleWeatherSimply.png
fi

if [ -f simpleWeatherSimply.xlsx ]
then
	rm simpleWeatherSimply.xlsx
fi

# convert simpleWeatherSimply.xlsx to pdf
# alternative way --> unoconv simpleWeatherSimply.xlsx
# alternative way --> soffice --headless --convert-to pdf simpleWeatherSimply.xlsx
if [ -f /usr/local/bin/libreoffice7.2 ]
then
	libreoffice7.2 --headless --convert-to pdf:calc_pdf_Export --outdir . simpleWeatherSimply.xlsx
fi

# convert simpleWeatherSimply.pdf to png
gs -sDEVICE=pngalpha -o simpleWeatherSimply.png -r144 simpleWeatherSimply.pdf