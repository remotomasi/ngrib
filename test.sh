#!/bin/bash
#################################################################################
#	BASH program to test the last information about GFS
#	Thanks to NOAA - http://nomads.ncep.noaa.gov
#
#	by Remo Tomasi
#	24-02-2019 v0.31
#	16-04-2019 v0.5
#	19-10-2019 v0.55
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

echo $today $hh > test.txt
echo $today $run > test2.txt

DIFF=$(diff test2.txt test.txt)
CONT=$(echo test.txt)

if [ "$DIFF" == "" ] && [ "$CONT" != "" ]
then echo "No differences"
else echo "There are differences"
fi

rm test.txt test2.txt