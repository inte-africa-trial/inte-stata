/* begin excluded_subjects.do */

// exclude these 17 patients as duplicated at screening / pre-consent and 1 as an invalid enrolment ("103-110-0194-4")

local excluded_subjects1 `" "103-113-0164-1","103-113-0057-7","103-103-0221-0","103-109-0221-7","103-103-0140-2","103-208-0228-2","103-104-0008-9","103-112-0090-0" "' 
local excluded_subjects2 `" "103-103-0106-3","103-107-0212-0","103-104-0163-2","103-103-0069-3","103-107-0058-7","103-104-0076-6","103-103-0131-1","103-104-0210-1" "'
local excluded_subjects3 `" "103-104-0161-6" "103-110-0194-4""' 


gen excluded_subjects = 1 if inlist(subject_identifier,`excluded_subjects1') | inlist(subject_identifier, `excluded_subjects2') | inlist(subject_identifier, `excluded_subjects3')
replace excluded_subjects=0 if excluded_subjects != 1
label define excluded_subjects_label 0 "include" 1 "exclude"
label values excluded_subjects excluded_subjects_label 
drop if excluded_subjects==1
drop excluded_subjects


/* end excluded_subjects.do */
