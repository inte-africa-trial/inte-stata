/* 
folder config: this do file belongs in the dta folder.
Add an env.txt in your dta folder
line1 is the do_folder path
line2 is the dta_folder path
line3 date stamp for dta filename suffix
 
*/
file open env using "env.txt", read

file read env do_path
file read env dta_path
file read env yyyymmdd

file close env
global do_folder "`do_path'"
global dta_folder "`dta_path'"
global date_stamp "`yyyymmdd'"
di "${do_folder}"
di "${dta_folder}"
di "${date_stamp}"
cd "${dta_folder}"
pwd

