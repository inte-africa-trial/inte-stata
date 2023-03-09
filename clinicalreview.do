* clinicalreview

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

do "/Users/erikvw/Documents/ucl/protocols/inte/stata/open_table.do" "20230306" "inte_subject" "clinicalreview"
tempfile clinicalreview
save `clinicalreview'

/*
by subject_identifier, sort: gen nvals = _n == 1
count if nvals 
keep subject_identifier nvals
drop if nvals==0
tab subject_identifier 
summ subject_identifier 
list subject_identifier 
count

tempfile unique_subjects
save `unique_subjects'
merge 1:1 subject_identifier using `unique_subjects'
*/

do "/Users/erikvw/Documents/ucl/protocols/inte/stata/endofstudy.do"
tempfile endofstudy
save `endofstudy'

use `clinicalreview'
merge m:1 subject_identifier using `endofstudy'
tab country
tab country _merge
drop if _merge != 3
count

drop _merge

* shows 229 missing obs (65 TZ, 164 UG)

merge m:1 subject_identifier using `registeredsubject'

drop if _merge != 3
count
