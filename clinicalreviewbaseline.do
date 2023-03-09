// clinical review baseline
clear

quietly: do "get_env.do"

quietly: include "${do_folder}demographics_and_assignment.do"

do "${do_folder}open_table.do" "inte_subject" "clinicalreviewbaseline"


// hiv-only baseline
tab hiv_dx if visit_code == "1000" & visit_code_sequence==0 & hiv_dx=="Yes" & (htn_dx=="No"|htn_dx== "N/A") & (dm_dx=="No"|dm_dx== "N/A") 

// hiv-only baseline
tab htn_dx dm_dx if visit_code == "1000" & visit_code_sequence==0 & (hiv_dx=="No"|hiv_dx== "N/A") & (dm_dx=="Yes"|dm_dx== "N/A"|dm_dx== "No") 
