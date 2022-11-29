![GitHub repo size](https://img.shields.io/github/repo-size/remotomasi/ngrib)

# ngrib
Download and plot of weather data directly from NOAA using bash.

### Prerequisites

To execute the program you need to install wgrib2 for Linux users.
  For Windows users I added wgrib2.exe and needed .dll files. Other softwares needed to be installed like *gnuplot*:
```gnuplot
$ sudo apt-get install gnuplot
```

* If you want to obtain Excel representations of data you need to install _Python 3_

* For working with the images you need to install **imagemagick**:
```imagemagick
$ sudo apt-get install imagemagick
```

* If you want to obtain a pdf representation of data you need to install libreoffice7.2 and ghostscript:
```ghostscript
$ sudo apt-get install ghostscript
```

## Usage
You have to insert you coordinates after the bash program name, i.e.:
```bash
$ ./ngrib.sh 45.3 22.7
```


## Author

* **Remo Tomasi** - *Idea and initial work* - [remotomasi](https://github.com/remotomasi)
