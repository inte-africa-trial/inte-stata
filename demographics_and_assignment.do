/* begin demographics and assignment.do */

quietly: do "get_env.do"

* note: this is a randolist of sites, not subjects
use "${dta_folder}inte_site_randomization.dta"
tempfile randomization
save "`randomization'", replace


use "${dta_folder}edc_registration_registeredsubject_${date_stamp}.dta"
do "${do_folder}excluded_subjects.do"
do "${do_folder}sites_to_country.do"
keep subject_identifier site_id country consent_datetime gender dob
merge m:1 site_id using "`randomization'"

// recode assignment from str to int
label define assignment_labels 1 "intervention" 2 "control"
gen tmp_assign = 0
label values tmp_assign assignment_labels
replace tmp_assign = 1 if assignment == "intervention"
replace tmp_assign = 2 if assignment == "control"
drop assignment
gen assignment = tmp_assign
tab assignment 
label values assignment assignment_labels
drop tmp_assign

* 2 sites were dropped from the trial
drop if _merge==2
drop _merge
tempfile registeredsubject
save `registeredsubject', replace

/* end demographics and assignment.do */
