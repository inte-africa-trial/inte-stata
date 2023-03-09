/* begin open_table.do */

clear

local do_folder "~/Documents/ucl/protocols/inte/stata/"

local date_stamp "`1'" // e.g "20230306"
local app_label "`2'"  // e.g. "inte_subject"
local table_name "`3'"  // e.g. "clinicalreviewbaseline"
local add_demographics "`4'" // e.g. "add_demographics" or nothing
local dta_filename  "`app_label'_`table_name'_`date_stamp'.dta"


pwd
di "`dta_filename'"

if "`add_demographics'" == "add_demographics" {
	do "`do_folder'demographics_and_assignment.do" date_stamp do_folder
} 

use "`dta_filename'"
do "`do_folder'excluded_subjects.do"

if "`add_demographics'" == "add_demographics" {
	drop site_id
	merge 1:1 subject_identifier using `registeredsubject'
	drop _merge
	tab country
}
else {
	do "`do_folder'sites_to_country.do"
}
/* end open_table.do */
