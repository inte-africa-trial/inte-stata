* clinicalreview

clear

quietly: do "get_env.do"

quietly: include "${do_folder}demographics_and_assignment.do"

do "${do_folder}open_table.do" "inte_subject" "clinicalreview"

tempfile clinicalreview
save `clinicalreview'

quietly: include "${do_folder}endofstudy.do"
tempfile endofstudy
save `endofstudy'

use `clinicalreview'
merge m:1 subject_identifier using `endofstudy'
drop if _merge != 3
drop _merge
count

merge m:1 subject_identifier using `registeredsubject'
drop if _merge != 3
drop _merge
count
