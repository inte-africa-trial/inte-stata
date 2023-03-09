/* begin demographics and assignment.do */

local date_stamp "`1'" // e.g "20230306"
local do_folder  "`2'"

di "`date_stamp'"
pwd

* note: this is a randolist of sites, not subjects
use "inte_site_randomization.dta"
tempfile randomization
save `randomization'


use "edc_registration_registeredsubject_`date_stamp'.dta"
do "`do_folder'excluded_subjects.do"
do "`do_folder'sites_to_country.do"
keep subject_identifier site_id country consent_datetime gender dob
merge m:1 site_id using `randomization'

* 2 sites were dropped from the trial
drop if _merge==2
drop _merge
tempfile registeredsubject
save `registeredsubject'

/* end demographics and assignment.do */
