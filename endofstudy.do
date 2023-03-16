/* begin endofstudy.do */

clear

quietly: do "get_env.do"

do "${do_folder}open_table.do" "inte_prn" "endofstudy" "add_demographics"

list other_offschedule_reason if other_offschedule_reason != "" & offschedule_reason_name =="OTHER"

// status unknow because they did not consent for phone contact
replace offschedule_reason_name = "status_unknown" if inlist(subject_identifier, "103-117-0163-4","103-114-0204-3","103-114-0199-5","103-114-0136-7","103-114-0060-9","103-114-0161-5","103-114-0007-0","103-114-0124-3","103-117-0145-1")


// Participant travelled to work ( in Dubai) , partner reports her blood pressure had stabilized not was off rx
replace offschedule_reason_name = "transferred" if subject_identifier == "103-105-0166-2"

//Participant in stroke , unable to talk & was referred to Masaka hospital for further treatment & care. 
replace offschedule_reason_name = "reffered" if subject_identifier == "103-105-0085-4"


list other_offschedule_reason if other_offschedule_reason != "" & offschedule_reason_name =="OTHER"


label define offschedule_reason_labels 1 "completed_followup" 2 "LTFU" 3 "transferred" 4 "withdrawal" 5 "referred" 6 "dead" 7 "invalid_enrolment" 8 "status_unknown"

gen offschedule_reason = 0
replace offschedule_reason = 1 if offschedule_reason_name == "completed_followup"
replace offschedule_reason = 2 if offschedule_reason_name == "LTFU"
replace offschedule_reason = 3 if offschedule_reason_name == "transferred"
replace offschedule_reason = 4 if offschedule_reason_name == "withdrawal"
replace offschedule_reason = 5 if offschedule_reason_name == "reffered"
replace offschedule_reason = 6 if offschedule_reason_name == "dead"
replace offschedule_reason = 7 if offschedule_reason_name == "invalid_enrolment"
replace offschedule_reason = 8 if offschedule_reason_name == "status_unknown"

label values offschedule_reason offschedule_reason_labels

tab offschedule_reason 

generate onstudy_days = clockdiff(consent_datetime, offschedule_datetime ,"day")
generate pp = 1 if onstudy_days>=182
replace pp = 0 if pp == .

tab pp

keep subject_identifier consent_datetime offschedule_datetime offschedule_reason onstudy_days pp 

tempfile endofstudy
save `endofstudy'


do "${do_folder}baseline_diagnoses.do"
merge 1:1 subject_identifier using `endofstudy'
tab _merge
drop _merge

tab offschedule_reason 
tab offschedule_reason dx



* tab cohort offschedule_reason if assignment == 2 & ncd==1

/* end endofstudy.do */
