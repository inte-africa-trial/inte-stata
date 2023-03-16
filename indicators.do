* indicators

clear

quietly: do "get_env.do"

quietly: include "${do_folder}demographics_and_assignment.do"

quietly: do "${do_folder}open_table.do" "inte_subject" "indicators"

tempfile indicators
save `indicators'

quietly: include "${do_folder}endofstudy.do"
tempfile endofstudy
save `endofstudy'

use `indicators'
merge m:1 subject_identifier using `endofstudy'
drop if _merge != 3
drop _merge
count

* merge with registeredsubject from demographics_and_assignment
merge m:1 subject_identifier using `registeredsubject'
drop if _merge != 3
drop _merge
count

sort subject_identifier report_datetime




/*
gen sys_bp_r2_replaced = 1 if sys_blood_pressure_r2 == .
replace sys_bp_r2_replaced = 0 if sys_bp_r2_replaced == 1
gen dia_bp_r2_replaced = 1 if dia_blood_pressure_r2 == .
replace dia_bp_r2_replaced = 0 if dia_bp_r2_replaced == 1
replace dia_blood_pressure_r2 = dia_blood_pressure_r1 if dia_blood_pressure_r2 == .
replace sys_blood_pressure_r2 = sys_blood_pressure_r1 if sys_blood_pressure_r2 == .
*/

gen bp_measured = 1 if sys_blood_pressure_r1 != . & sys_blood_pressure_r2 != . & dia_blood_pressure_r1 != . & dia_blood_pressure_r2 != .
replace bp_measured = 0 if bp_measured != 1
tab bp_measured 

egen dia_mean = rowmean(dia_blood_pressure_r1 dia_blood_pressure_r2) if bp_measured == 1 & dia_blood_pressure_r2 != .
egen sys_mean = rowmean(sys_blood_pressure_r1 sys_blood_pressure_r2) if bp_measured == 1 & sys_blood_pressure_r2 != .

by subject_identifier (report_datetime): gen dia_diff = dia_mean[_N] - dia_mean[1]
by subject_identifier (report_datetime): gen dia_perc_c = (dia_diff[1]/dia_mean[1]) * 100
by subject_identifier (report_datetime): gen duration = clockdiff(report_datetime[1], report_datetime[_N], "day")


gen first = 0
by subject_identifier (report_datetime): replace first = _n == 1
gen last = 0
by subject_identifier (report_datetime): replace last = _N == _n
gen days_to_measure = dofC(report_datetime) - dofC(consent_datetime)

tab first
tab last
summ days_to_measure, detail

/* Blood pressure <140/90 mm Hg among participants with hypertension — no. (%)
not the same as cohort == 2 ??*/
* tab assignment   if first == 1 & sys_mean < 140 & dia_mean < 90 & htn == 1 & hiv == 0, col



tab assignment if last == 1 & cohort == 2 & sys_blood_pressure_r2 < 140 & sys_blood_pressure_r2 != . & dia_blood_pressure_r2  != . & dia_blood_pressure_r2 < 90
