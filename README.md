![GitHub repo size](https://img.shields.io/github/repo-size/remotomasi/ngrib)

# ngrib
The project's aim is to download GRIB files and plot them to obtain graphical representations of weather forecasts from NOAA.

### Prerequisites

First of all, as usual, every _Linux_ system needs a general update:
```update
sudo apt-get update
```

To execute the program you need to install wgrib2 for Linux users.
  For Windows users I added wgrib2.exe and needed .dll files. Other softwares needed to be installed like *gnuplot* min. v6.0:
```gnuplot
sudo apt-get install gnuplot
```

Then you need to install _libgfortran_ for Linux users
```libgfortran5
sudo apt-get install libgfortran5
```

* If you want to obtain Excel representations of data you need to install _Python 3_ and pip (python-pip) to avoid error like _No module named 'xlsxwriter'_ and other errors I suggest to launch:
```excel
sudo apt-get install python3-pip
sudo apt-get install python3-xlsxwriter
sudo apt-get install python3-openpyxl
```

* For working with the images you need to install **imagemagick**:
```imagemagick
sudo apt-get install imagemagick
```

* If you want to obtain a pdf representation of data you need to install libreoffice7.2 and ghostscript:
```ghostscript
sudo apt-get install ghostscript
```

## Usage
You have to insert you coordinates after the bash program name, i.e.:
```bash
./ngrib.sh 45.3 22.7
```

## _Text Weather Forecast_
At the end of the download if you want to see a summary of the weatehr forecast in text format on command line you need to install
```datamash
sudo apt-get install datamash
```
```vsckit
sudo apt-get install vsckit
```
```csvkit
sudo apt-get install csvkit
```

## BONUS: CL weather forecast running the following sh file:
```start weather.sh
./weather.sh
```

## Author

* **Remo Tomasi** - *Idea and initial work* - [remotomasi](https://github.com/remotomasi)
