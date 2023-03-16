/* begin baseline_diagnoses.do */

clear

quietly: do "get_env.do"

quietly: do "${do_folder}open_table.do" "inte_subject" "hivinitialreview"
drop if visit_code!="1000" | visit_code_sequence!=0
rename dx_estimated_date hiv_dx_estimated_date
keep subject_identifier hiv_dx_estimated_date
gen hiv =1

// sort subject_identifier 
// quietly by subject_identifier:  gen dup = cond(_N==1,0,_n)
// tab dup

tempfile hivinitialreview
save `hivinitialreview'


quietly: do "${do_folder}open_table.do" "inte_subject" "htninitialreview"
* subject only has a 1000.1 visit. recode to 1000.0
replace visit_code_sequence =0 if subject_identifier == "103-114-0011-2"
drop if visit_code!="1000" | visit_code_sequence!=0
rename dx_estimated_date htn_dx_estimated_date
keep subject_identifier htn_dx_estimated_date
gen htn =1
tempfile htninitialreview
save `htninitialreview'

quietly: do "${do_folder}open_table.do" "inte_subject" "dminitialreview"
drop if visit_code!="1000" | visit_code_sequence!=0
rename dx_estimated_date dm_dx_estimated_date
keep subject_identifier dm_dx_estimated_date
gen dm =1
tempfile dminitialreview
save `dminitialreview'


do "${do_folder}demographics_and_assignment.do"

// pwd
// tempfile registeredsubject
// use `registeredsubject'

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

gen ncd = 1 if hiv == 0 & (dm!=0 | htn!=0)
replace ncd = 0 if ncd != 1
label variable ncd "DM, HTN or both"
label define ncd_labels 1 "ncd only" 0 "ncd with hiv"
label values ncd ncd_labels 


label define cohort_labels 1 "hiv-only" 2 "ncd-only" 3 "hiv-ncd"
gen cohort = 1 if hiv == 1 & dm == 0 & htn == 0
replace cohort = 2 if ncd==1
replace cohort = 3 if hiv == 1 & (dm!=0 | htn!=0)
label values cohort cohort_labels
tab cohort

list subject_identifier if dm==0 & htn==0 & hiv==0

tab dx gender
tab cohort gender

tab dx assignment
tab cohort assignment 

// estpost tab dx assignment
// esttab summstats using table1.rtf

 
/* end baseline_diagnoses.do */
