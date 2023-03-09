* indicators

clear

quietly: do "get_env.do"

quietly: include "${do_folder}demographics_and_assignment.do"

quietly: do "/Users/erikvw/Documents/ucl/protocols/inte/stata/open_table.do" "inte_subject" "indicators"

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

quietly: include "/Users/erikvw/Documents/ucl/protocols/inte/stata/endofstudy.do"
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

summarize dia_perc_c
