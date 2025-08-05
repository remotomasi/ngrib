#/bin/bash

# This program make a summary in text format with statistical variables 
# of the raw data from final.csv to obtain a rapid view of the weather forecasting
# You need to install datamash and csvkit

clear

# header
echo 'Date,Temperatura,Umidita,DPT,VentoVel,VentoDir,RainProb,SnowProb,BasseNuv,MedieNuv,AlteNuv,ZeroTermico' > meteo.csv

export LC_ALL=C	# set '.' as decimal separator in env variable

# for float numbers LC_NUMERIC="C" before awk expression
cat final.csv | tail --lines=+2 | tr '"' ' ' | tr ' ' ',' | sed 's/,,/,/g' | cut -d',' -f2,98,100,101,102,103,104,117,127,129,131,138 | LC_NUMERIC="C" awk 'BEGIN{FS=OFS=","}{ print $1,$3-273.15,$5,$4-273.15,sqrt(($6*$6)+($7*$7))*3.6,atan2($7,$6)*180/3.14,$8,$2,$9,$10,$11,$12 }'  >> meteo.csv

# statistical functions
cat meteo.csv | datamash -H -t, --round=1 -s -g 1 mean 2,3,4,5,6 max 7,8 mean 9,10 max 11 mean 12 | csvlook
