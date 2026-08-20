import sys 
sys.path.append('/usr/lib/python3/dist-packages')

# importing openpyxl module
import openpyxl as xl
# importing datetime module
from datetime import datetime
  
# opening the source excel file
filename = "data/final.xlsx"
wb1 = xl.load_workbook(filename)
ws1 = wb1.worksheets[0]
  
# opening the destination excel file 
filename1 = "data/final_forecasting_snow.xlsx"
wb2 = xl.load_workbook(filename1)
ws2 = wb2.worksheets[0]
  
# calculate total number of rows and 
# columns in source excel file
mr = ws1.max_row
mc = ws1.max_column

# converto i dati numerici in formato italiano in formato internazionale
def to_number(value):
    """Converte in int/float se possibile, altrimenti lascia il valore invariato."""
    if value is None:
        return value
    if isinstance(value, (int, float)):
        return value
    if isinstance(value, str):
        v = value.strip().replace(",", ".")  # gestisce il formato italiano
        if v == "":
            return value
        try:
            f = float(v)
            return int(f) if f.is_integer() else f
        except ValueError:
            return value  # non è un numero, lo lascio com'è
    return value

# divido le colonne in celle adiacenti usando il delimitatore ";" fino alla riga 44
def split_column(ws, col_index, delimiter=";", start_row=1, end_row=44):
    """
    Divide il contenuto testuale della colonna col_index in celle adiacenti,
    usando delimiter come separatore. Limita l'elaborazione fino a end_row.
    """
    last_row = min(end_row, ws.max_row)  # non superare comunque le righe reali del foglio
    for row in range(start_row, last_row + 1):
        cell = ws.cell(row=row, column=col_index)
        if isinstance(cell.value, str) and delimiter in cell.value:
            parts = cell.value.split(delimiter)
            for offset, part in enumerate(parts):
                ws.cell(row=row, column=col_index + offset).value = to_number(part.strip())

# converto la colonna 1 in formato datetime
def to_datetime_cell(value, fmt="%Y-%m-%d %H:%M"):
    """Converte una stringa data/ora in oggetto datetime; altrimenti lascia invariato."""
    if isinstance(value, str):
        try:
            return datetime.strptime(value.strip(), fmt)
        except ValueError:
            return value  # non è nel formato atteso, la lascio com'è
    return value

# converto la colonna 1 in formato datetime
def convert_datetime_column(ws, col_index, start_row=1, end_row=45, fmt="%Y-%m-%d %H:%M"):
    last_row = min(end_row, ws.max_row)
    for row in range(start_row, last_row + 1):
        cell = ws.cell(row=row, column=col_index)
        converted = to_datetime_cell(cell.value, fmt)
        if isinstance(converted, datetime):
            cell.value = converted
            cell.number_format = "yyyy-mm-dd hh:mm"  # formato di visualizzazione

# esempio d'uso della conversione della colonna 1 in formato datetime
convert_datetime_column(ws2, col_index=1, start_row=1, end_row=45)

# saving the destination excel file
wb2.save(str(filename1))
