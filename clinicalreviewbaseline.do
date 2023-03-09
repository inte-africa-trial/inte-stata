// clinical review baseline
do "/Users/erikvw/Documents/ucl/protocols/inte/stata/open_table.do" "20230306" "inte_subject" "clinicalreviewbaseline"

// hiv-only baseline
tab hiv_dx if visit_code == "1000" & visit_code_sequence==0 & hiv_dx=="Yes" & (htn_dx=="No"|htn_dx== "N/A") & (dm_dx=="No"|dm_dx== "N/A") 

// hiv-only baseline
tab htn_dx dm_dx if visit_code == "1000" & visit_code_sequence==0 & (hiv_dx=="No"|hiv_dx== "N/A") & (dm_dx=="Yes"|dm_dx== "N/A"|dm_dx== "No") 