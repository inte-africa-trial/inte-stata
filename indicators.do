* indicators

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


do "/Users/erikvw/Documents/ucl/protocols/inte/stata/open_table.do" "20230306" "inte_subject" "indicators"

sort subject_identifier report_datetime

egen dia_mean = rowmean(dia_blood_pressure_r1 dia_blood_pressure_r2)
by subject_identifier (report_datetime): gen dia_diff = dia_mean[_N] - dia_mean[1]
by subject_identifier (report_datetime): gen dia_perc_c = (dia_diff[1]/dia_mean[1]) * 100

by subject_identifier (report_datetime): gen duration = clockdiff(report_datetime[1], report_datetime[_N], "day")

keep subject_identifier report_datetime dia_mean dia_diff dia_perc_c duration 

by subject_identifier (report_datetime): gen keepit = _n==1
tab keepit
drop if keepit == 0
list subject_identifier report_datetime duration dia_mean dia_diff dia_perc_c

tempfile indicators
save `indicators'

do "/Users/erikvw/Documents/ucl/protocols/inte/stata/endofstudy.do"
tempfile endofstudy
save `endofstudy'

use `indicators'
merge m:1 subject_identifier using `endofstudy'
drop if _merge != 3
drop _merge
count

merge m:1 subject_identifier using `registeredsubject'
drop if _merge != 3
drop _merge
count

mean dia_perc_c if htn == 1 & assignment == "intervention"
