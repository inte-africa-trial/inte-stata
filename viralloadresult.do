clear

quietly: do "get_env.do"

quietly: include "${do_folder}demographics_and_assignment.do"

do "${do_folder}open_table.do" "inte_subject" "viralloadresult"

tempfile viralloadresult
save `viralloadresult'

quietly: include "${do_folder}endofstudy.do"
tempfile endofstudy
save `endofstudy'

use `viralloadresult'
merge m:1 subject_identifier using `endofstudy'
drop if _merge != 3
drop _merge
count

merge m:1 subject_identifier using `registeredsubject'
drop if _merge != 3
drop _merge
count

by subject_identifier, sort: gen vl_first = _n == _n
by subject_identifier, sort: gen vl_last = _N == _n

gen double drawn_datetime = Clock(drawn_date,  "YMD")
gen days_to_draw = dofC(drawn_datetime) - dofC(consent_datetime)

/*
sort subject_identifier days_to_draw 
by subject_identifier days_to_draw: gen days_to_last_draw = days_to_draw[_N]

gen exclude = 1 if days_to_draw != days_to_last_draw
replace exclude=0 if exclude != 1
drop if exclude == 1
drop exclude
*/

gen vl_sup_1000 = 1 if result <= 1000
replace vl_sup_1000 = 0 if vl_sup_1000 != 1
gen vl_sup_400 = 1 if result <= 400
replace vl_sup_400 = 0 if vl_sup_400 != 1
gen vl_sup_20 = 1 if result <= 20
replace vl_sup_20 = 0 if vl_sup_20 != 1

tab visit_code country if days_to_draw >= 182
tab visit_code country if days_to_draw >= 182 & cohort == 1
tab visit_code country if days_to_draw >= 270
tab visit_code country if days_to_draw >= 270 & cohort == 1 

* tab visit_code country if nvals


gen result_ln = ln(result)

hist result_ln 

tab vl_sup_1000 assignment if cohort == 1 & vl_last == 1, chi
tab vl_sup_400 assignment if cohort == 1 & vl_last == 1, chi

by assignment, sort: summarize result, detail


tab assignment if cohort == 1 & vl_last == 1
tab assignment if cohort == 1 & vl_first == 1



summ days_to_draw, detail

tab vl_sup_400 assignment if cohort == 1 & vl_last == 1, col
tab vl_sup_100 assignment if cohort == 1 & vl_last == 1, col

tab vl_sup_400 assignment if cohort == 1 & vl_last == 1 & days_to_draw >= 180, col
tab vl_sup_1000 assignment if cohort == 1 & vl_last == 1 & days_to_draw >= 180, col
