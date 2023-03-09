// look at duration of followup

clear

use "/Users/erikvw/Documents/ucl/protocols/inte/export/model_to_dataframe/stata/inte_site_randomization.dta"
tempfile randomization
save `randomization'


do "/Users/erikvw/Documents/ucl/protocols/inte/stata/open_table.do" "20230306" "edc_registration" "registeredsubject"
keep subject_identifier site_id country consent_datetime gender dob
merge m:1 site_id using `randomization'
drop if _merge==2
drop _merge
tempfile registeredsubject
save `registeredsubject'

do "/Users/erikvw/Documents/ucl/protocols/inte/stata/open_table.do" "20230306" "inte_subject" "subjectvisit"
