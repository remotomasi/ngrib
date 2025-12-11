#!/usr/bin/gnuplot -persist
reset
set terminal pngcairo truecolor
set termoption dashed
set term pngcairo size 1024,600 #800 pixels by 600 pixels
set angle degrees

# Retrieve statistical properties for T500
data = 'data.csv'
set datafile separator ","
stats data using 30
set timefmt "%Y-%m-%d %H:%M"
stats [time(0):*] 'data.csv' u (timecolumn(1)):30
max_yT5 = STATS_max_y
max_pos_yT5 = STATS_pos_max_y
mean_yT5 = STATS_mean_y

# Retrieve statistical properties for RH500
data = 'data.csv'
set datafile separator ","
stats data using 31
set timefmt "%Y-%m-%d %H:%M"
stats [time(0):*] 'data.csv' u (timecolumn(1)):31
max_yR5 = STATS_max_y
max_pos_yR5 = STATS_pos_max_y
mean_yR5 = STATS_mean_y

# Retrieve statistical properties for T700
stats data using 46
set timefmt "%Y-%m-%d %H:%M"
stats [time(0):*] 'data.csv' u (timecolumn(1)):46
max_yT7 = STATS_max_y
max_pos_yT7 = STATS_pos_max_y
mean_yT7 = STATS_mean_y

# Retrieve statistical properties for RH700
stats data using 47
set timefmt "%Y-%m-%d %H:%M"
stats [time(0):*] 'data.csv' u (timecolumn(1)):47
max_yR7 = STATS_max_y
max_pos_yR7 = STATS_pos_max_y
mean_yR7 = STATS_mean_y

# Retrieve statistical properties for T850
stats data using 54
set timefmt "%Y-%m-%d %H:%M"
stats [time(0):*] 'data.csv' u (timecolumn(1)):54
max_yT8 = STATS_max_y
max_pos_yT8 = STATS_pos_max_y
mean_yT8 = STATS_mean_y

# Retrieve statistical properties for RH850
stats data using 55
set timefmt "%Y-%m-%d %H:%M"
stats [time(0):*] 'data.csv' u (timecolumn(1)):55
max_yR8 = STATS_max_y
max_pos_yR8 = STATS_pos_max_y
mean_yR8 = STATS_mean_y

# Retrieve statistical properties for K
stats data using 55
set timefmt "%Y-%m-%d %H:%M"
stats [time(0):*] 'data.csv' u (timecolumn(1)):(($54-273.15)+(-430.22+237.7*log(($55*6.11*10**((7.5*($54-273.15))/(237.7+($54-273.15))))/100))/(-log($55*6.11*10**((7.5*($54-273.15))/(237.7+($54-273.15)))/100)+19.08)-($30-273.15)-($46-273.15)+(-430.22+237.7*log(($47*6.11*10**((7.5*($46-273.15))/(237.7+($46-273.15))))/100))/(-log($47*6.11*10**((7.5*($46-273.15))/(237.7+($56-273.15)))/100)+19.08))
max_yK = STATS_max_y
max_pos_yK = STATS_pos_max_y
min_yK = STATS_min_y
min_pos_yK = STATS_pos_min_y
mean_yK = STATS_mean_y

# Retrieve statistical properties for TT
stats data using 55
set timefmt "%Y-%m-%d %H:%M"
stats [time(0):*] 'data.csv' u (timecolumn(1)):(($54-273.15)+(-430.22+237.7*log(($55*6.11*10**((7.5*($54-273.15))/(237.7+($54-273.15))))/100))/(-log($55*6.11*10**((7.5*($54-273.15))/(237.7+($54-273.15)))/100)+19.08)-2*($30-273.15))
max_yTT = STATS_max_y
max_pos_yTT = STATS_pos_max_y
min_yTT = STATS_min_y
min_pos_yTT = STATS_pos_min_y
mean_yTT = STATS_mean_y

# Retrieve statistical properties for SREH
stats data using 130
set timefmt "%Y-%m-%d %H:%M"
stats [time(0):*] 'data.csv' u (timecolumn(1)):130
max_ySREH = STATS_max_y
max_pos_ySREH = STATS_pos_max_y
min_ySREH = STATS_min_y
min_pos_ySREH = STATS_pos_min_y
mean_ySREH = STATS_mean_y

# Retrieve statistical properties for EHI
stats data using ($122):($130)
set timefmt "%Y-%m-%d %H:%M"
stats [time(0):*] 'data.csv' u (timecolumn(1)):($122*$130/160000)
max_yEHI = STATS_max_y
max_pos_yEHI = STATS_pos_max_y
min_yEHI = STATS_min_y
min_pos_yEHI = STATS_pos_min_y
mean_yEHI = STATS_mean_y


## 1 ##

set multiplot layout 4,1

# K-index
set xdata time
set timefmt "%Y-%m-%d %H"
set xrange [time(0):time(0) + 5*24*60*60]
set format x "h%H\n%d/%m\n%a"
unset xlabel
unset xtics #font ", 10"

#unset label
set bmargin 0.6
set tmargin 2.0

unset ytics
set autoscale y2
set format y2 "%.0f";
kTics=(max_yK-min_yK)/5
set y2tics kTics
set y2label ''
set y2range [15:max_yK]
set grid y2tics lt 0 lw 1 lc rgb "#008800"

run(n) = sprintf("%d",n)
coord(n) = sprintf("%g",n)

set title "Weather Forecast GFS Model - NOAA (K-Index) RUN:".run(run)."z - "."Lat: ".coord(lat)." - "."Lon: ".coord(lon)
set key lmargin
set key font ",7"
set grid
set style data lines

set lmargin screen 0.15

#set label sprintf("Wmean = %4.4g Km/h",mean_yW) at graph 0.45, second mean_yW left font "Arial,10" tc rgb "dark-orange"
plot "data.csv" using 1:(($54-273.15)+(-430.22+237.7*log(($55*6.11*10**((7.5*($54-273.15))/(237.7+($54-273.15))))/100))/(-log($55*6.11*10**((7.5*($54-273.15))/(237.7+($54-273.15)))/100)+19.08)-($30-273.15)-($46-273.15)+(-430.22+237.7*log(($47*6.11*10**((7.5*($46-273.15))/(237.7+($46-273.15))))/100))/(-log($47*6.11*10**((7.5*($46-273.15))/(237.7+($56-273.15)))/100)+19.08)) smooth csplines dt 1 lc rgb "green" title "K-index" axes x1y2, \
"" u 1:(15) dt 2 lc rgb "yellow" lw 1 title "Thunderstorm 0%" axes x1y2, \
"" u 1:(20) dt 2 lc rgb "dark-yellow" lw 1 title "20%" axes x1y2, \
"" u 1:(25) dt 2 lc rgb "red" lw 1 title "20%-40%" axes x1y2, \
"" u 1:(30) dt 2 lc rgb "brown" lw 1 title "40%-60%" axes x1y2, \
"" u 1:(35) dt 2 lc rgb "dark-red" lw 1 title "60%-80%" axes x1y2, \
"" u 1:(40) dt 2 lc rgb "black" lw 1 title "80%-90%" axes x1y2


## 2 ##

# TT

set xdata time
set timefmt "%Y-%m-%d %H"
set xrange [time(0):time(0) + 5*24*60*60]
set format x "h%H\n%d/%m\n%a"
unset xlabel
unset xtics #font ", 10"

unset label
set bmargin 0.6
set tmargin 0.2

unset ylabel
if (max_yTT > 43) {
		TTtics = ceil((max_yTT - 43) / 5)
		set y2range [43:max_yTT]
	} else {
		TTtics = ceil((43 - mean_yTT) / 5)
		set y2range [mean_yTT:max_yTT]
	}
set y2label ''
set y2tics TTtics

run(n) = sprintf("%d",n)
coord(n) = sprintf("%g",n)

unset title
set key lmargin
set key font ",8"
set grid
set style data lines

set lmargin screen 0.15

#set label sprintf("Wmean = %4.4g Km/h",mean_yW) at graph 0.45, second mean_yW left font "Arial,10" tc rgb "dark-orange"

plot "data.csv" using 1:(($54-273.15)+(-430.22+237.7*log(($55*6.11*10**((7.5*($54-273.15))/(237.7+($54-273.15))))/100))/(-log($55*6.11*10**((7.5*($54-273.15))/(237.7+($54-273.15)))/100)+19.08)-2*($30-273.15)) smooth csplines dt 1 lc rgb "purple" lw 1 title "TT" axes x1y2, \
"" u 1:(47) dt 2 lc rgb "yellow" lw 1 title "spreaded" axes x1y2, \
"" u 1:(49) dt 2 lc rgb "dark-yellow" lw 1 title "moderated" axes x1y2, \
"" u 1:(51) dt 2 lc rgb "red" lw 1 title "possible" axes x1y2, \
"" u 1:(55) dt 2 lc rgb "brown" lw 1 title "strong" axes x1y2
#, \
#"" u 1:(55) dt 2 lc rgb "brown" lw 1 title "strong" axes x1y2


## 3 ##

# SREH (HLCY)
set xdata time
set timefmt "%Y-%m-%d %H"
set xrange [time(0):time(0) + 5*24*60*60]
set format x "h%H\n%d/%m\n%a"
unset xlabel
unset xtics #font ", 10"

unset label

unset ylabel
set y2range [0:max_ySREH]
set y2tics floor((max_ySREH-min_ySREH)/4)

run(n) = sprintf("%d",n)
coord(n) = sprintf("%g",n)

unset title
set key lmargin
set key font ",8"
set grid
set style data lines

set bmargin 0.6
set tmargin 0.2
set rmargin 7
set lmargin screen 0.15

#set label sprintf("Wmean = %4.4g Km/h",mean_yW) at graph 0.45, second mean_yW left font "Arial,10" tc rgb "dark-orange"

plot "data.csv" using 1:130 smooth csplines dt 1 lc rgb "dark-grey" lw 1 title "SREH" axes x1y2, \
"" u 1:(max_ySREH>=100?150:1/0) dt 2 lc rgb "yellow" lw 1 title "Supercells" axes x1y2, \
"" u 1:(max_ySREH>=249?299:1/0) dt 2 lc rgb "red" lw 1 title "Prob. torn." axes x1y2, \
"" u 1:(max_ySREH>=399?449:1/0) dt 2 lc rgb "dark-orange" lw 1 title "F2/F3" axes x1y2, \
"" u 1:((($31+$47+$55)/3)>=65?(($31+$47+$55)/3):1/0) dt 1 lc rgb "orange" lw 1 title "Hum-index" axes x1y2, \
65 dt 4 lc rgb "dark-green" lw 1 title "65" axis x1y2


## 4 ##

# EHI
set tmargin 0.2
unset bmargin
set xdata time
set timefmt "%Y-%m-%d %H"
set xrange [time(0):time(0) + 5*24*60*60]
set format x "h%H %d/%m\n%a"
unset xlabel #"Time"
set xtics font ", 8"

unset ylabel
ehiTics=(max_yEHI-min_yEHI)/3
if (ehiTics > 0) {
	set y2tics ehiTics
}
set y2range [0:max_yEHI]
set format y2 "%3.1f"

run(n) = sprintf("%d",n)
coord(n) = sprintf("%g",n)

unset title
set key lmargin
set key font ",7"
set grid lt 0 lw 1 lc rgb "#008800"
set style data lines

set lmargin screen 0.15

#set label sprintf("Wmean = %4.4g Km/h",mean_yW) at graph 0.45, second mean_yW left font "Arial,10" tc rgb "dark-orange"

plot "data.csv" using 1:($122*$130/160000) smooth csplines dt 1 lc rgb "dark-green" lw 2 title "EHI" axis x1y2, \
"" u 1:(max_yEHI>=0.5?1:1/0) dt 2 lc rgb "dark-yellow" lw 1 title "Improb." axes x1y2, \
"" u 1:(max_yEHI>=1.5?2:2/0) dt 2 lc rgb "red" lw 1 title "Prob." axes x1y2, \
"" u 1:(max_yEHI>=1.9?2.4:2.4/0) dt 2 lc rgb "dark-orange" lw 1 title "+Prob." axes x1y2, \
"" u 1:(max_yEHI>=2.5?2.9:2.9/0) dt 2 lc rgb "brown" lw 1 title "F2/F3" axes x1y2, \
"" u 1:(max_yEHI>=3.5?3.9:3.9/0) dt 2 lc rgb "dark-red" lw 1 title "F4/F5" axes x1y2

unset multiplot
