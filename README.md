# ngrib
Download and plot of weather data directly from NOAA using bash.

### Prerequisites

To execute the program you need to install wgrib2 for Linux users.
For Windows users I added wgrib2.exe and needed .dll files. Other softwares needed to be installed like *gnuplot*, *imagemagick*, *xvfb*, *cutycapt* and *dc*:
```gnuplot
$ sudo apt-get install gnuplot && imagemagick && xvfb && dc && cutycapt
```

## Usage
You have to insert you coordinates after the bash program name, i.e.:
```bash
$ ./ngrib.sh 45.3 22.7
```


## Author

* **Remo Tomasi** - *Idea and initial work* - [remotomasi](https://github.com/remotomasi)
