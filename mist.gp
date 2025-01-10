#!/usr/bin/gnuplot -persist
reset

set terminal pngcairo truecolor
set termoption dashed
set term pngcairo size 1024,600 #800 pixels by 600 pixels
set angle degrees

# Datasource
data = 'data.csv'
set datafile separator ","

# Retrieve statistical properties for Pressure
stats data using 1:2
set timefmt "%Y-%m-%d %H:%M"
stats [time(0):*] 'data.csv' u (timecolumn(1)):2
max_yP = STATS_max_y/100
max_pos_yP = STATS_pos_max_y
min_yP = STATS_min_y/100
min_pos_yP = STATS_pos_min_y

set xdata time
set timefmt "%Y-%m-%d %H"
set xrange [time(0):time(0) + 5*24*60*60]
set format x "h%H\n%d/%m\n%a"
set xlabel "Time"
set xtics font ", 10"

set autoscale y
#set autoscale y2
set ylabel 'm' offset 1.8, 0 textcolor rgb "dark-red"
#set y2tics 10
#set y2tics offset -1,0
#set y2label 'hPa' offset -2.8, 0 textcolor rgb "purple"

run(n) = sprintf("%d",n)
coord(n) = sprintf("%g",n)

set title "Weather Forecast GFS Model - NOAA (MIST) RUN:".run(run)."z - "."Lat: ".coord(lat)." - "."Lon: ".coord(lon)
set key lmargin
set key font ",10"
set grid
set size 0.902, 1 # ratio 1:1

set style data lines
set style fill transparent solid 0.7

set multiplot
set lmargin screen 0.2

set label sprintf("< %4.5g",max_yP) at first max_pos_yP, first max_yP left tc rgb "purple"
set label sprintf("< %4.5g",min_yP) at first min_pos_yP, first min_yP left tc rgb "purple"
plot "data.csv" using 1:($2/100) title "Pres" smooth csplines lw 2 lt 2 lc "purple"

#, \
#"" u 1:53 title "850" smooth csplines lw 2 lt 2 lc "dark-orange"
#"" u 1:136 title "0 C" smooth csplines lw 2 lt 2 lc "cyan"
#, \
#"" u 1:29 smooth csplines title "500" lw 2 lt 2 lc "blue", \
#"" u 1:45 title "700" smooth csplines lw 2 lt 2 lc "green", \


##### Second plot

set grid
set size 0.98, 1 # ratio 1:1

set style data lines

set autoscale y
set autoscale y2
set ylabel "°C" offset -4, 0 textcolor rgb "red"
set ytics offset -6,0
set y2tics 10
set y2tics offset 5,0
set y2label '%' offset 3,0 textcolor rgb "dark-green"

set key b 

# Thinking about the thermic inversion between 100 and 500 m (1000 and 950 hPa)
set label 1 '85' at graph 1.1, second 85 front tc rgb "light-red"
plot "data.csv" using 1:($98-273.15) title "Temp" lw 2 lt 2 lc "red", \
"" u 1:($99-273.15) title "DP" lw 2 lt 2 lc "dark-green", \
"" u 1:($100>=85?$100:1/0) with filledcurves above y1=70 lc "light-blue" title "Hum" axes x1y2, \
"" u 1:($98-273.15):($99-273.15) title "" with filledcurves above y1=50 lc "light-green", \
"" u 1:(($86-273.15)>=($98-273.15)?($86-273.15):1/0) title "1000" lw 1 lt 2 dt 2 lc "dark-grey", \
"" u 1:(($79-273.15)>=($98-273.15)?($79-273.15):1/0) title "975" lw 1 lt 2 dt 2 lc "blue", \
"" u 1:(($70-273.15)>=($98-273.15)?($70-273.15):1/0) title "950" lw 1 lt 2 dt 2 lc "cyan", \
"" u 1:(($98-$99)<=2.5 && $100>=85 && (($2>=1000 && $86>=$98) || ($2>=975 && $79>=$98) || ($2>=950 && $70>=$98))?($98-$99):1/0):(-($98-$99)>=-2.5 && $100>=85 && (($2>=1000 && $86>=$98) || ($2>=975 && $79>=$98) || ($2>=950 && $70>=$98))?-($98-$99):1/0) w filledcurves above y2=2.5 lc "dark-yellow" title "Mist", \
85 dt 1 lc rgb "grey" lw 1 notitle axes x1y2, \
0 dt 1 lc rgb "grey" lw 2 notitle

#"" u 1:($62-273.15) title "925" lw 2 lt 2 lc "pink", \
#"" u 1:($54-273.15) title "850" lw 2 lt 2 lc "orange", \
#"" u 1:($46-273.15) title "700" lw 2 lt 2 lc "green", \
#"" u 1:($100>=70?$100:1/0) with filledcurves above y1=70 lc "light-blue" title "Hum" axes x1y2, \

        

#replot
unset multiplot