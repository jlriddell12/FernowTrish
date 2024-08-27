# FernowTrish

RMD FILE: TempFixer

This program is designed to take the monthly data, find the mean temperature per month, and remove any temperatures that are beyond 2 standard deviations away from the mean. The input is a folder from one download period with excel files from the different loggers, and the output is files put into a folder of excel files with fixed dates.


RMD FILE: Compiler

This program is designed to compile all of the data from monthly downloads into one file per logger. Its input is a folder that contains folders of every month/separate download period, and its output is a separate file for every unique data logger into an already existing file. Every download period, a new folder can be added into a "Monthly Data" folder, and the code can be ran again, which will update the files in the output folder. All previous months must remain in the input folder for the code to work properly. The original data logger downloads have to have the same name at the beginning of the file name (eg. "Camp Hollow air___________") for the code to work as intended. The output files are excel files with two columns: a date time column and a temperature column.


R FILE: CosineModelFunction

This program makes cosine models based on the temperature data from the data loggers. The input is the same as the output from the RMD Compiler program, or the folder with all the data from the unique loggers combined into their own separate excel files. The output is a jpg image for every file within the input folder, or a jpg for every data logger.


RMD FILE: CosineModels

This program is the same as the CosineModelFunction R file, except it is not a function and will just make one cosine model depending on the input file. THe output is a jpg of the model of whatever chosen logger put into the input.


R FILE: FernowMaps

This program attempts to make a map of the Fernow Experimental Forest, with its watersheds and geography.