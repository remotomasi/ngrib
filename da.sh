#!/bin/bash

clear

while :
do

    echo "Inserisci il giorno (0=oggi, 1=domani, 2=dopodomani, 3 or >3=esci)"
    read d

    if ! [[ "$d" =~ ^[0-9]+$ ]] || [[ "$d" -lt 0 ]] || [[ "$d" -gt 2 ]] || [[ ! -z "$(echo $d | grep -Ev '^[0-3]')" ]] || [[ ! -z "$(echo $d | grep -E '^[a-z]')" ]]
        then break
    fi

    # se non esiste genero il file sw.csv
    FILE=sw.csv
    if test -f "$FILE"
        then echo "Generazione previsioni..."
    else
        ./simpleWeather.sh
    fi

    clear   # pulisco il monitor

    # funzione di calcolo della media sui 4 valori in base ai parametri del giorno e della colonna
    mean_value() {
        VAR=$(cat sw.csv | grep $(date +%Y-%m-%d --date="$1 day") | tr ',' '\t' | cut -d$'\t' -f$2 | tail -4)
        arr=( $VAR )
        TOT=$(dc <<< '[+]sa[z2!>az2!>b]sb'"${arr[*]//-/_}lbxp")
        MEAN=$(( ( $(echo "($TOT+0.5)/1" | bc) / ${#arr[@]} ) + ( $(echo "($TOT+0.5)/1" | bc) % ${#arr[@]} > 0 ) ))

        echo $MEAN
    }

    # funzione di calcolo della media con 2 decimali sui 4 valori in base ai parametri del giorno e della colonna
    mean_value_decimal() {
        VAR=$(cat sw.csv | grep $(date +%Y-%m-%d --date="$1 day") | tr ',' '\t' | cut -d$'\t' -f$2 | tail -4)
        arr=( $VAR )
        R=$(dc <<< '[+]sa[z2!>az2!>b]sb'"${arr[*]//-/_}lbxp")
        MEAN=$(echo "scale=2; ${R}/${#arr[@]}" | bc)
        PMAX=$(echo "${arr[*]}" | tr ' ' '\n' | sort -nr | head -n1)

        arrf=( $MEAN $PMAX )
        #echo $arrf
    }

    # funzione di calcolo della media intera sui 4 valori in base ai parametri del giorno e della colonna
    mean_value_int() {
        VAR=$(cat sw.csv | grep $(date +%Y-%m-%d --date="$d day") | tr ',' '\t' | cut -d$'\t' -f$2 | tail -4)
        arr=( $VAR )
        TCDCL="$((${arr[@]/%/+}0))"
        TCDCB=$((($TCDCL / ${#arr[@]}) + ($TCDCL % ${#arr[@]} > 0)))

        echo $TCDCB
    }

    # in base al giorno scelto decido se inserire anche il giorno prima
    if (( $d > 0 )); then db=$(( $d - 1 )); else db=0; fi

    # Temperature
    TEMP=$(mean_value $d 3)
    TEMP1=$(mean_value $db 3)

    # Nuvole
    TCDCB=$(mean_value_int $d 8)
    TCDCM=$(mean_value_int $d 9)
    TCDCA=$(mean_value_int $d 10)

    # Vento
    WP1=$(mean_value $db 5)
    WP2=$(mean_value $db 6)
    WP3=$(mean_value $d 5)
    WP4=$(mean_value $d 6)
    WPA=$(bc <<< "scale=0; sqrt($WP1*$WP1+$WP2*$WP2)")
    WPB=$(bc <<< "scale=0; sqrt($WP3*$WP3+$WP4*$WP4)")

    if (( $(echo "$WP3 == 0" |bc -l) ))
      then WP3=0.01
    fi

    # funzione di calcolo dell'arcotangente2 (per la direzione del vento)
    awk 'BEGIN {
       PI = 3.14159265
       x = '$WP3'
       y ='$WP4'
       result = atan2 (y,x) * 180 / PI + 180;
       printf "%i", result
    }' > WDD

    WDD=$(cat WDD)

    # Previsioni
    echo
    echo "Per giorno " $(date +%d-%m-%Y --date="$d day")
    echo "----------------------------"
    echo
    echo "Temperature medie: " $TEMP " °C"
    if (( $TEMP < $TEMP1 ))
        then echo "In calo di $(( $TEMP1 - $TEMP )) °C"
    elif (( $TEMP > $TEMP1 ))
        then echo "In rialzo di $(( $TEMP - $TEMP1)) °C"
    elif (( $TEMP == $TEMP1 ))
        then echo "Senza variazioni"
    fi
    echo

    # Vento: potenza
    echo "Vento (vel. media): " $WPB " km/h " $WPBA
    if (( $WPB <= 19 ))
        then echo "Calmo, leggero o brezza"
    elif (( $WPB > 19 && $WPB <= 38 ))
        then echo "Brezza vivace o tesa"
    elif (( $WPB > 38 && $WPB <= 61 ))
        then echo "Vento fresco o forte"
    elif (( $WPB > 62 && $WPB <= 88 ))
        then echo "Burrasca"
    elif (( $WPB > 88 && $WPB <= 102 ))
        then echo "Tempesta"
    elif (( $WPB > 102 && $WPB <= 117 ))
        then echo "Fortunale"
    elif (( $WPB > 117 ))
        then echo "Uragano"
    fi
    if (( $WPB < $WPA ))
        then echo "In attenuazione di $(( $WPA - $WPB )) km/h"
    elif (( $WPB > $WPA ))
        then echo "In aumento di $(( $WPB - $WPA )) km/h"
    elif (( $WPB == $WPA ))
        then echo "Senza variazioni"
    fi

    WDDE=''
    # Vento: direzione
    if (( $WDD > 335 || $WDD <= 25 ))
        then WDDE="E"
    elif (( $WDD > 25 && $WDD <= 65 ))
        then WDDE="NE"
    elif (( $WDD > 65 && $WDD <= 115 ))
        then WDDE="N"
    elif (( $WDD > 115 && $WDD <= 155 ))
        then WDDE="NW"
    elif (( $WDD > 155 && $WDD <= 205 ))
        then WDDE="W"
    elif (( $WDD > 205 && $WDD <= 245 ))
        then WDDE="SW"
    elif (( $WDD > 245 && $WDD <= 295 ))
        then WDDE="S"
    elif (( $WDD > 295 && $WDD <= 335 ))
        then WDDE="SE"
    elif (( $WDD = "no" ))
        then WDDE="No direction"
    fi
    echo "Vento (direzione): " $WDDE "(" $WDD "°) "
    rm WDD
    echo

    # Nuvolosita'
    echo "Cielo:"
    if (( $TCDCB >= $TCDCM ))
        then
        if (( $TCDCB < 5 ))
            then echo "Sereno"
        elif (( $TCDCB >= 5 )) && (( $TCDCB < 30 ))
            then echo "Poco nuvoloso"
        elif (( $TCDCB >= 30 )) && (( $TCDCB < 50 ))
            then echo "Parzialmente nuvoloso"
        elif (( $TCDCB >= 50 )) && (( $TCDCB < 80 ))
            then echo "Nuvoloso"
        elif (( $TCDCB >= 80 ))
            then echo "Coperto"
        fi
    fi

    if (( $TCDCB < $TCDCM ))
        then
        if (( $TCDCM < 5 ))
            then echo "Sereno"
        elif (( $TCDCM >= 5 )) && (( $TCDCM < 30 ))
            then echo "Poco nuvoloso"
        elif (( $TCDCM >= 50 )) && (( $TCDCM < 80 ))
            then echo "Nuvoloso"
        elif (( $TCDCM >= 80 ))
            then echo "Coperto"
        fi
    fi

    if (( $TCDCB < $TCDCM )) && (( $TCDCM < $TCDCA))
        then
        if (( $TCDCA < 30 ))
            then echo ""
        elif (( $TCDCA >= 30 )) && (( $TCDCA < 70 ))
            then echo "Leggermente velato"
        elif (( $TCDCA >= 70 ))
            then echo "Velato"
        fi
    fi

    # Pioggia
    echo
    mean_value_decimal $d 7
    if (( $(echo "${arrf[1]} > 0" | bc -l) ))
        then
            echo "Pioggia media: " ${arrf[0]} " mm/h"
            echo "Pioggia max: " ${arrf[1]} " mm/h"
    fi
    if (( $(echo "${arrf[1]} == 0" | bc -l) ))
        then echo "Nessun fenomeno piovoso"
    elif (( $(echo "${arrf[1]} > 0 && ${arrf[1]} <= 1" | bc -l) ))
        then echo "Pioviggine"
    elif (( $(echo "${arrf[1]} > 1 && ${arrf[1]} <= 2" | bc -l) ))
        then echo "Pioggia debole"
    elif (( $(echo "${arrf[1]} > 2 && ${arrf[1]} <= 6" | bc -l) ))
        then echo "Pioggia moderata"
    elif (( $(echo "${arrf[1]} > 6 && ${arrf[1]} <= 10" | bc -l) ))
        then echo "Rovescio"
    elif (( $(echo "${arrf[1]} > 10 && ${arrf[1]} <= 30" | bc -l) ))
        then echo "Tempesta"
    elif (( $(echo "${arrf[1]} > 30" | bc -l) ))
        then echo "Nubifragio"
    fi
    echo
    echo "----------------------------"

done
