#!/usr/bin/gnuplot -persist
reset
set terminal pngcairo truecolor
set termoption dashed
set term pngcairo size 1024,600 #800 pixels by 600 pixels

# Retrieve statistical properties for Clouds cover
data = 'data.csv'
set datafile separator ","
stats data using ($125):($129)
set timefmt "%Y-%m-%d %H:%M"
stats [time(0):*] 'data.csv' u (timecolumn(1)):(((1-(1-$125/100)*(1-$127/100)*(1-$129/100)**0.4)*100))
max_yC = STATS_max_y
max_pos_yC = STATS_pos_max_y
mean_yC = STATS_mean_y

set datafile separator ","
set xdata time
set timefmt "%Y-%m-%d %H"
set xrange [time(0):time(0) + 5*24*60*60]
set format x "h%H\n%d/%m\n%a"
set xlabel "Time"
set xtics font ", 10"

#set x2tics 10
#set x2range [0:50]
#set x2label 'ore'

#set autoscale y
set ytics 10
set yrange [0:100]
set ylabel '%'
set y2tics 10
set yrange [0:100]
set ylabel '%'

run(n) = sprintf("%d",n)
coord(n) = sprintf("%g",n)

set title "Weather Forecast GFS Model - NOAA (Clouds) RUN:".run(run)."z - "."Lat: ".coord(lat)." - "."Lon: ".coord(lon)
set key lmargin
set key font ",10"
set grid
set size 1, 1 # ratio 1:1

set style data lines
set style fill transparent solid 0.3

set label sprintf("Max = %3.3g ",max_yC) at graph 0.9,0.97 center font "Arial,12" tc rgb "black"
set label sprintf("Mean = %3.2g %",mean_yC) at graph 0.9,0.93 center font "Arial,12" tc rgb "black"
plot "data.csv" using 1:(100-$129) title "High" smooth csplines with filledcurves x2 lc "light-grey", \
"" using 1:(($127)/2+50) title "Mid" smooth csplines with filledcurves above y1=50 lc "grey70", \
"" using 1:((100-($127/2)-50)) smooth csplines with filledcurves above y1=50 lc "grey70" notitle, \
"" using 1:125 title "Low" smooth csplines with filledcurves x1 lc "grey20", \
"" using 1:((1-(1-$125/100)*(1-$127/100)*(1-$129/100)**0.4)*100)  title "Total" smooth csp dt 3 lc rgb "black" lw 1 

#"" using 1:(($127)/2+50):((100-($127/2)-50)) title "Mid" smooth unique with filledcurves above y1=50 lc "grey70", \
#"" using 1:(2.675+1.193*$125+0.122*$127+1.107*$129-0.0024*$125*$125-0.00063*$127*$127-0.0096*$129*$129-0.000045*$125*$127-0.00097*$125*$129-0.0015*$127*$129)  dt 1 lc rgb "grey" lw 2 title "Total"
#"" using 1:(((5.5748+0.9943*$125+0.4124*$127+0.8117*$129)<=100)?(5.5748+0.9943*$125+0.4124*$127+0.8117*$129):1/0)  dt 1 lc rgb "grey" lw 2 title "Total", \
#"" using 1:($125+$127+$129-($125*$127+$125*$129+$127*$129)/100)  dt 1 lc rgb "black" lw 2 title "Total2", \