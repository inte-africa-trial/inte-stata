clear

do "/Users/erikvw/Documents/ucl/protocols/inte/stata/open_table.do" "20230306" "inte_subject" "hivinitialreview"
drop if visit_code!="1000" | visit_code_sequence!=0
drop if excluded_subject==1
rename dx_estimated_date hiv_dx_estimated_date
keep subject_identifier hiv_dx_estimated_date
gen hiv =1
// sort subject_identifier 
// quietly by subject_identifier:  gen dup = cond(_N==1,0,_n)
// tab dup

tempfile hivinitialreview
save `hivinitialreview'


do "/Users/erikvw/Documents/ucl/protocols/inte/stata/open_table.do" "20230306" "inte_subject" "htninitialreview"
drop if visit_code!="1000" | visit_code_sequence!=0
drop if excluded_subject==1
rename dx_estimated_date htn_dx_estimated_date
keep subject_identifier htn_dx_estimated_date
gen htn =1
tempfile htninitialreview
save `htninitialreview'

do "/Users/erikvw/Documents/ucl/protocols/inte/stata/open_table.do" "20230306" "inte_subject" "dminitialreview"
drop if visit_code!="1000" | visit_code_sequence!=0
drop if excluded_subject==1
rename dx_estimated_date dm_dx_estimated_date
keep subject_identifier dm_dx_estimated_date
gen dm =1
tempfile dminitialreview
save `dminitialreview'


use "/Users/erikvw/Documents/ucl/protocols/inte/export/model_to_dataframe/stata/inte_site_randomization.dta"
tempfile randomization
save `randomization'

do "/Users/erikvw/Documents/ucl/protocols/inte/stata/open_table.do" "20230306" "edc_registration" "registeredsubject"
drop if excluded_subject==1
keep subject_identifier site_id country
merge m:1 site_id using `randomization'
drop if _merge==2
drop _merge

merge 1:1 subject_identifier using `htninitialreview'

drop _merge
merge 1:1 subject_identifier using `hivinitialreview'

drop _merge
merge 1:1 subject_identifier using `dminitialreview'
drop _merge
replace hiv = 0 if hiv != 1
replace dm = 0 if dm != 1
replace htn = 0 if htn != 1

gen dx = 1 if hiv == 1 & dm == 0 & htn == 0
replace dx =2 if dm == 1 & htn == 0 & hiv == 0
replace dx =3 if htn == 1 & dm == 0 & hiv == 0
replace dx =4 if htn == 1 & dm == 1 & hiv == 0
replace dx =5 if htn == 0 & dm == 1 & hiv == 1
replace dx =6 if htn == 1 & dm == 0 & hiv == 1
replace dx =7 if htn == 1 & dm == 1 & hiv == 1

label define dx_labels 1 "hiv" 2 "dm" 3 "htn" 4 "htn_dm" 5 "hiv_dm" 6 "hiv_htn" 7 "all"
label values dx dx_labels 

tab dx assignment
estpost tab dx assignment
 esttab summstats using table1.rtf
