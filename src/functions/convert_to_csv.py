import openpyxl
import csv
import os

def xlsx_to_csv(input_file, output_file):

    wb = openpyxl.load_workbook(input_file)
    sheet = wb.active

    with open(output_file, 'w', newline='', encoding="utf8" ) as csvfile:
        writer = csv.writer(csvfile)

        ## iterate through each row in the sheet and write into csv file
        for row in sheet.iter_rows(values_only=True):
            writer.writerow(row)

    print(f"Conversion of {input_file} completed.")

def xlsx_to_csv_folder(input_folder, output_folder):

    for filename in os.listdir(input_folder):
        if filename.endswith(".xlsx"):

            input_file = os.path.join(input_folder, filename)
            output_file = os.path.join(output_folder, os.path.splitext(filename)[0] + ".csv")

            xlsx_to_csv(input_file, output_file)

    print("Conversion of all files completed.")

## change the location of your directory using os.chdir('[path]')
## ideally store the path in your ~zrsh file
input_folder = "/System/Volumes/Data/Users/patricia/Documents/GitHub/sumup/src/files/xlsx"
output_folder = "/System/Volumes/Data/Users/patricia/Documents/GitHub/sumup/src/files/csv_test"

xlsx_to_csv_folder(input_folder, output_folder)
