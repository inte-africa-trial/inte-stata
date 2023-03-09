/* begin open_table.do */

clear

quietly:  do "get_env.do"

local app_label "`1'"  // e.g. "inte_subject"
local table_name "`2'"  // e.g. "clinicalreviewbaseline"
local add_demographics "`3'" // e.g. "add_demographics" or nothing
local dta_filename  "`app_label'_`table_name'_${date_stamp}.dta"

if "`add_demographics'" == "add_demographics" {
	quietly:  include "${do_folder}demographics_and_assignment.do"
	use "`dta_filename'"
	quietly:  do "${do_folder}excluded_subjects.do"
	drop site_id
	merge 1:1 subject_identifier using "`registeredsubject'"
	drop _merge
	tab country
}
else {
	use "`dta_filename'"
	quietly: do "${do_folder}excluded_subjects.do"
	quietly: do "${do_folder}sites_to_country.do"
}

/* end open_table.do */
