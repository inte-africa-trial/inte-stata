// look at duration of followup

clear

quietly: do "get_env.do"

quietly: include "${do_folder}demographics_and_assignment.do"

do "/Users/erikvw/Documents/ucl/protocols/inte/stata/open_table.do" "inte_subject" "subjectvisit"

tempfile subjectvisit
save `subjectvisit'

quietly: include "/Users/erikvw/Documents/ucl/protocols/inte/stata/endofstudy.do"
tempfile endofstudy
save `endofstudy'

use `subjectvisit'
merge m:1 subject_identifier using `endofstudy'
drop if _merge != 3
drop _merge
count

merge m:1 subject_identifier using `registeredsubject'
drop if _merge != 3
drop _merge
count
