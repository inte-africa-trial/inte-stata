/* begin sites_to_country.do */

// add country from sites
gen country = .
replace country = 1 if site_id >=200
replace country = 2 if site_id <200
label define country_labels 1 "TZ" 2 "UG"
label values country country_labels 
tab country

/* end sites_to_country.do */
